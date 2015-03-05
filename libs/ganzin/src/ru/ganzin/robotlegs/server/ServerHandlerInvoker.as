/**
 * User: Dmitriy Ganzin
 * Date: 24.11.10
 * Time: 20:15
 */
package ru.ganzin.robotlegs.server
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;

    import org.as3commons.lang.ClassUtils;
    import org.as3commons.reflect.Metadata;
    import org.as3commons.reflect.MetadataArgument;
    import org.as3commons.reflect.Method;
    import org.as3commons.reflect.Parameter;
    import org.as3commons.reflect.Type;
    import org.osflash.signals.Signal;

    import ru.ganzin.apron2.collections.HashMap;
    import ru.ganzin.apron2.errors.IllegalArgumentException;
    import ru.ganzin.robotlegs.Actor;
    import ru.ganzin.robotlegs.server.api.IPacket;

    public class ServerHandlerInvoker extends Actor
    {
        public var eventsListUpdated:Signal = new Signal(Array);

        private var serverEventInfoMap:HashMap = new HashMap(true);
        private var serverMessageInfoMap:HashMap = new HashMap(true);

        public function mapHandlers(instance:*):void
        {
            var sehInfosList:Vector.<ServerEventInfo> = new Vector.<ServerEventInfo>();
            var smhInfosList:Vector.<ServerMessageInfo> = new Vector.<ServerMessageInfo>();

            for each (var method:Method in Type.forInstance(instance).methods)
            {
                var seInfo:ServerEventInfo = getServerEventInfo(method);
                var smInfo:ServerMessageInfo = getServerMessageInfo(method);

                if (seInfo) sehInfosList.push(seInfo);
                if (smInfo) smhInfosList.push(smInfo);
            }

            if (sehInfosList.length > 0)
            {
                serverEventInfoMap.put(instance, sehInfosList);
                eventsListUpdated.dispatch(getEvents());
            }

            if (smhInfosList.length > 0) serverMessageInfoMap.put(instance, smhInfosList);
        }

        public function unmapHandlers(instance:*):void
        {
            if (!serverEventInfoMap.containsKey(instance))
            {
                serverEventInfoMap.remove(instance);
                eventsListUpdated.dispatch(getEvents());
            }
            if (!serverMessageInfoMap.containsKey(instance)) serverMessageInfoMap.remove(instance);
        }

        private function getEvents():Array
        {
            var ret:Array = [];
            for each (var list:Vector.<ServerEventInfo> in serverEventInfoMap.getValues())
                for each (var info:ServerEventInfo in list)
                    ret.push(info.type);
            return ret;
        }

        private function getServerMessageInfo(method:Method):ServerMessageInfo
        {
            if (method.hasMetadata("ServerMessageHandler"))
            {
                if (!checkMethodParamsMap(method, [IPacket]))
                    throw new IllegalArgumentException("Не верные аргументы для функции " +
                                                       method.declaringType.name + "::" + method.name + ". Должно быть [IPacket].");

                return new ServerMessageInfo(method);
            }

            return null;
        }

        private function getServerEventInfo(method:Method):ServerEventInfo
        {
            var metaData:Metadata;
            var metaDataArg:MetadataArgument;

            if (method.hasMetadata("ServerEventHandler"))
            {
                var paramsMap:Array = [
                    [IOErrorEvent],
                    [Object],
                ];

                if (!checkMethodParamsMaps(method, paramsMap))
                    throw new IllegalArgumentException("Не верные входящие параметры для функции " +
                                                       method.declaringType.name + "::" + method.name +
                                                       ". Должно быть [Event] || [Event, Object] || [Object]");
                else if (method.parameters.length > 2)
                    throw new IllegalArgumentException("Количество параметров функции " +
                                                       method.declaringType.name + "::" + method.name + " не должно быть больше двух");

                for each (metaData in method.getMetadata("ServerEventHandler"))
                {
                    metaDataArg = metaData.getArgument("type");
                    if (metaDataArg == null || metaDataArg.value == null)
                        throw new ArgumentError("Для матаданных [ServerEventHandler] должне быть установлен параметр type");

                    return new ServerEventInfo(method, metaDataArg.value);
                }
            }

            return null;
        }

        private function checkMethodParamsMaps(method:Method, list:Array, fullCheck:Boolean = false):Boolean
        {
            for each (var arr:Array in list)
                if (checkMethodParamsMap(method, arr, fullCheck)) return true;

            return false;
        }

        private function checkMethodParamsMap(method:Method, list:Array, fullCheck:Boolean = false):Boolean
        {
            if (method.parameters.length != list.length) return false;
            for (var i:int = 0; i < list.length; i++)
            {
                var clazz:Class = Parameter(method.parameters[i]).type.clazz;
                if (fullCheck) return clazz == list[i];
                else return ClassUtils.isAssignableFrom(list[i], clazz);
            }
            return true;
        }

        public function invokeEventHandlers(event:Event):void
        {
            for each (var instance:* in serverEventInfoMap.getKeys())
                for each (var info:ServerEventInfo in serverEventInfoMap.getValue(instance))
                    for each (var metaData:Metadata in info.method.getMetadata("ServerEventHandler"))
                        if (metaData.getArgument("type").value == event.type)
                        {
                            var method:Method = info.method;
                            if (method.parameters.length == 2)
                            {
                                throw new IllegalArgumentException("Тип события [" + Type.forInstance(event).name +
                                                                   "] передаваемый в метод" +
                                                                   (method.declaringType.name + "::" + method.name) +
                                                                   " должен соответсвовать SFSEvent");
                            }
                            else
                            {
                                if (checkMethodParamsMap(method, [Event])) method.invoke(instance, [event]);
//								else if (checkMethodParamsMap(method, [SFSEvent])) method.invoke(instance, [event]);
//								else if (checkMethodParamsMap(method, [HttpEvent])) method.invoke(instance, [event]);
                                else if (checkMethodParamsMap(method, [IOErrorEvent])) method.invoke(instance, [event]);
                                else if (checkMethodParamsMap(method, [Object]))
                                {
                                    throw new IllegalArgumentException("Для того чтобы принимать аргумент с типом Object в метод"
                                                                       + (method.declaringType.name + "::" + method.name) +
                                                                       " нужно подписывать на событи типа SFSEvent");
                                }
                            }
                        }
        }

        public function invokeMethods(packet:IPacket):void
        {
            for each (var instance:* in serverMessageInfoMap.getKeys())
                for each (var info:ServerMessageInfo in serverMessageInfoMap.getValue(instance))
                    for each (var metaData:Metadata in info.method.getMetadata("ServerMessageHandler"))
                    {
                        var method:Method = info.method;

                        if (metaData.hasArgumentWithKey("command") && (metaData.getArgument("command").value == packet.action))
                        {
                            if (checkMethodParamsMap(method, [IPacket])) $invokeMethod(method, metaData, instance, packet);
                            else throw new IllegalArgumentException("Не верные входящие параметры для функции " +
                                                                    method.declaringType.name + "::" + method.name +
                                                                    ". Должно быть [IPacket]");
                        }
                        else
                        {
                            if (checkMethodParamsMap(method, [Type.forInstance(packet).clazz])) $invokeMethod(method, metaData, instance,
                                    packet);
                            else if (checkMethodParamsMap(method, [IPacket], true)) $invokeMethod(method, metaData, instance, packet);
                        }
                    }
        }

        private function $invokeMethod(method:Method, metaData:Metadata, instance:*, packet:IPacket):void
        {
            for each (var mdArg:MetadataArgument in metaData.arguments)
            {
                if (packet[mdArg.key] == null) return;
                else if (packet[mdArg.key].toString() != mdArg.value) return;
            }

            method.invoke(instance, [packet]);
        }
    }
}

import org.as3commons.reflect.Method;

class ServerMessageInfo
{
    public var method:Method;

    public function ServerMessageInfo(method:Method)
    {
        this.method = method;
    }
}

class ServerEventInfo
{
    public var method:Method;
    public var type:String;

    public function ServerEventInfo(method:Method, type:String)
    {
        this.method = method;
        this.type = type;
    }
}
