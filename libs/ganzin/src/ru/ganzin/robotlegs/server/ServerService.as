/**
 * User: Dmitriy Ganzin
 * Date: 24.11.10
 * Time: 20:15
 */
package ru.ganzin.robotlegs.server
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;

    import org.as3commons.lang.ClassUtils;
    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;

    import ru.ganzin.apron2.errors.IllegalArgumentException;
    import ru.ganzin.apron2.utils.StringUtil;
    import ru.ganzin.apron2.utils.UIDUtil;
    import ru.ganzin.robotlegs.Actor;
    import ru.ganzin.robotlegs.server.api.IPacket;
    import ru.ganzin.robotlegs.server.api.IServerService;
    import ru.ganzin.robotlegs.server.api.IServerServiceEmulator;
    import ru.ganzin.robotlegs.server.error.PacketProcessingError;
    import ru.ganzin.robotlegs.server.events.ServerServiceEvent;
    import ru.ganzin.robotlegs.server.signals.ServerSignalsSet;

    /**
     *  Сервис работы с сервером
     */
    public class ServerService extends Actor implements IServerService, IServerServiceEmulator
    {
        public var serverServiceProfilingEnabled:Boolean = true;

        [Inject]
        public var serverMessageHandlerInvoker:ServerHandlerInvoker;

        protected var responcePacketsMap:Dictionary = new Dictionary();

        protected var serverHandlerClient:IEventDispatcher;

        protected var resultSignals:Dictionary = new Dictionary(true);
        protected var resultSignalsCount:uint = 0;

        protected static const SUBSCRIBER_DELIMETER:String = "######";

        [PostConstruct]
        public function initPackets():void
        {
            eventDispatcher.addEventListener(ServerServiceEvent.REGISTER_RESPONSE_PACKET, function (e:ServerServiceEvent):void
            {
                registerResultPacket(e.packetClass);
            });

            eventDispatcher.addEventListener(ServerServiceEvent.UNREGISTER_RESPONSE_PACKET, function (e:ServerServiceEvent):void
            {
                unregisterResultPacket(e.packetClass);
            });

            serverMessageHandlerInvoker.eventsListUpdated.add(updateEventsListHandler);
        }

        public function registerResultPacket(packetClass:Class):void
        {
            var packet:IPacket = new packetClass();
            if (!packet) throw new IllegalArgumentException("Класс передаваемый в событие ServerServiceEvent.REGISTER_RESPONSE_PACKET должен быть наследован от IPacket");

            responcePacketsMap[packet.action] = packetClass;
        }

        public function unregisterResultPacket(packetClass:Class):void
        {
            var packet:IPacket = new packetClass();
            if (!packet) throw new IllegalArgumentException("Класс передаваемый в событие ServerServiceEvent.UNREGISTER_RESPONSE_PACKET должен быть наследован от IPacket");

            delete responcePacketsMap[packet.action];
        }

        protected function preSendPacket(packet:IPacket):void
        {
            const resultSignal:Signal = new Signal(IPacket);

            var subscriber:String = packet.subscriber;
            subscriber ||= UIDUtil.getUID(resultSignal);

            if (!StringUtil.isEmpty(packet.subscriber) && resultSignals[packet.subscriber] != null)
                subscriber = subscriber + SUBSCRIBER_DELIMETER + resultSignalsCount++;

            packet.subscriber = subscriber;

            resultSignals[subscriber] = resultSignal;

            if (signalsSet.beforePacketSend.numListeners > 0)
                signalsSet.beforePacketSend.dispatch(packet);
        }

        protected function getResultSignal(subscriber:String):ISignal
        {
            return resultSignals[subscriber];
        }

        public function sendPacket(packet:IPacket):ISignal
        {
            var sendPacket:Boolean = true;

            try
            {
                preSendPacket(packet);
            }
            catch (e:PacketProcessingError)
            {
                if (e.type == PacketProcessingError.CANCEL_SENDING) sendPacket = false;
            }

            if (sendPacket) sendPacketToServer(packet);

            if (signalsSet.afterPacketSend.numListeners > 0)
                signalsSet.afterPacketSend.dispatch(packet);

            return getResultSignal(packet.subscriber);
        }

        protected function sendPacketToServer(packet:IPacket):void
        {

        }

        private var _serverSignalsSet:ServerSignalsSet = new ServerSignalsSet();

        public function get signalsSet():ServerSignalsSet
        {
            return _serverSignalsSet;
        }

        protected var lockedGroups:Dictionary = new Dictionary();

        public function lockGroup(subscriber:String):void
        {
            if (subscriber in lockedGroups) return;
            lockedGroups[subscriber] = [];
        }

        public function groupIsLocked(subscriber:String):Boolean
        {
            return subscriber in lockedGroups;
        }

        public function unlockGroup(subscriber:String):void
        {
            const stTime:Number = getTimer();
            const list:Array = lockedGroups[subscriber];

            if (list)
            {
                var packet:IPacket;

                while (list.length)
                {
                    packet = list.shift();

                    invokePacket(packet);

                    if (serverServiceProfilingEnabled)
                        logger.debug("unlockGroup :: invokeResponsePacket ({0} ms)", [getTimer() - stTime]);
                }

                delete lockedGroups[subscriber];

                if (signalsSet.groupUnlocked.numListeners > 0)
                    signalsSet.groupUnlocked.dispatch(subscriber);

                if (serverServiceProfilingEnabled)
                    logger.debug("unlockGroup ({0} ms)", [getTimer() - stTime]);
            }
        }

        protected function responseHandler(data:*):void
        {
            if (!data) return;

            const stTime:Number = getTimer();

            if (signalsSet.beforeResponseDataParsing.numListeners > 0)
                signalsSet.beforeResponseDataParsing.dispatch(data);

            const packet:IPacket = (data is IPacket) ? data : parseResponseData(data.action, data);

            if (!packet) return;

            if (serverServiceProfilingEnabled)
                logger.debug("responseHandler :: parseResponseData :: {0} packet setData ({1} ms)", [packet.action, getTimer() - stTime]);

            invokeResponsePacket(packet);
        }

        public function emulateReceivePacket(packet:IPacket):void
        {
            invokeResponsePacket(packet);
        }

        protected function invokeResponsePacket(packet:IPacket):void
        {
            const stTime:Number = getTimer();

            if (signalsSet.afterResponsePacket.numListeners > 0)
                signalsSet.afterResponsePacket.dispatch(packet);

            const groupSubscriber:String = packet.groupSubscriber;

            if (groupSubscriber && groupSubscriber in lockedGroups)
            {
                if (signalsSet.responseLockedPacket.numListeners > 0)
                    signalsSet.responseLockedPacket.dispatch(packet);

                (lockedGroups[groupSubscriber] as Array).push(packet);
                return;
            }

            invokePacket(packet);

            if (serverServiceProfilingEnabled)
                logger.debug("invokeResponsePacket :: invokePacket ({0} ms)", [getTimer() - stTime]);
        }

        protected function invokePacket(packet:IPacket):void
        {
            serverMessageHandlerInvoker.invokeMethods(packet);

            var subscriber:String = packet.subscriber;
            if (subscriber)
            {
                var idx:int = packet.subscriber.indexOf(SUBSCRIBER_DELIMETER);
                if (idx != -1) packet.subscriber = packet.subscriber.substring(0, idx);

                var signal:ISignal = resultSignals[packet.subscriber];
                if (signal)
                {
                    if (signal.valueClasses.length == 0) signal.dispatch();
                    else if (signal.valueClasses.length == 1 &&
                             (signal.valueClasses[0] === ClassUtils.forInstance(packet) || signal.valueClasses[0] === IPacket))
                    {
                        signal.dispatch(packet);
                    }
                    else
                    {
                        if (signal.valueClasses.length > 1)
                        {
                            logger.error("У сигнала для пакета({0}) должно быть не больше 1 аргумента.", [packet.action]);
                        }
                        else
                        {
                            logger.error("У сигнала для пакета({0}) не подходящий агрумент.", [packet.action]);
                        }
                    }

                    signal.removeAll();
                    delete resultSignals[packet.subscriber];
                }
            }
        }

        protected function parseResponseData(action:String, data:*):IPacket
        {
            return null;
        }

        private var prevEventsList:Array = [];

        private function updateEventsListHandler(list:Array):void
        {
            for each (var type:String in prevEventsList)
                if (list.indexOf(type) == -1)
                    serverHandlerClient.removeEventListener(type, serverClientEventHandler);

            for each (type in list)
                if (prevEventsList.indexOf(type) == -1)
                    serverHandlerClient.addEventListener(type, serverClientEventHandler);

            prevEventsList = list;
        }

        private function serverClientEventHandler(event:Event):void
        {
            var stTime:Number = getTimer();
            if (serverServiceProfilingEnabled)
                logger.debug("serverMessageHandlerInvoker.invokeEventHandlers :: start");

            serverMessageHandlerInvoker.invokeEventHandlers(event);

            if (serverServiceProfilingEnabled)
                logger.debug("serverMessageHandlerInvoker.invokeEventHandlers :: end ({0} ms)", [getTimer() - stTime]);
        }
    }
}
