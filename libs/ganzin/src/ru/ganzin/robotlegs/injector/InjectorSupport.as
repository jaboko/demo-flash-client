/**
 * User: Dmitriy Ganzin
 * Date: 21.02.11
 * Time: 15:05
 */
package ru.ganzin.robotlegs.injector
{
    import flash.events.IEventDispatcher;
    import flash.utils.getQualifiedClassName;

    import org.as3commons.collections.Map;
    import org.as3commons.collections.framework.IMapIterator;
    import org.osflash.signals.Signal;
    import org.swiftsuspenders.mapping.MappingEvent;

    import ru.ganzin.apron2.events.EventDispatcher2;
    import ru.ganzin.apron2.interfaces.IDisposable;
    import ru.ganzin.apron2.utils.CallLaterManager;
    import ru.ganzin.apron2.utils.StringUtil;
    import ru.ganzin.robotlegs.Actor;

    /**
     * Помошник для среты robotlegs и swiftsuspenders.
     * Занимается отслеживанием маппинга классов.
     */

    public class InjectorSupport extends Actor implements IDisposable
    {
        private var _callLaterManager:CallLaterManager;
        protected function get callLaterManager():CallLaterManager
        {
            if (!_callLaterManager) _callLaterManager = new CallLaterManager();
            return _callLaterManager;
        }

        private var _injectorEventDispatcher:EventDispatcher2;
        public function get injectorEventDispatcher():IEventDispatcher
        {
            return _injectorEventDispatcher ||
                   (_injectorEventDispatcher = new EventDispatcher2(IEventDispatcher(injector)));
        }

        [PostConstruct]
        public function initWainInjectClass():void
        {
            var ed:IEventDispatcher = injectorEventDispatcher;
            if (!ed.hasEventListener(MappingEvent.POST_MAPPING_CREATE))
            {
                ed.addEventListener(MappingEvent.POST_MAPPING_CREATE, function (e:MappingEvent):void
                {
                    callLaterManager.add(executeWaitSignalByClass, [e.mappedType, e.mappedName],
                            CallLaterManager.CLEAR_ALL_PREV_ACTION);
                });
            }
        }

        private var waitInjectSignals:Map = new Map();


        /**
         * Возвращает сигнал для подписки на событие маппинга класса.
         * Все подписки удаляются после вызовы метода dispose()
         *
         * @param clazz Тип класса
         * @param named Имя под которым замаппили класс
         *
         * @return Сигнал для подписки
         */
        public function waitInjectClass(clazz:Class, named:String = ""):Signal
        {
            var className:String = getQualifiedClassName(clazz) + ((!StringUtil.isEmpty(named)) ? "_" + named : "");
            if (!waitInjectSignals.hasKey(className)) waitInjectSignals.add(className, []);
            var list:Array = waitInjectSignals.itemFor(className);
            var signal:Signal = new Signal(clazz);
            list.push(signal);

            if (injector.hasMapping(clazz, named))
                callLaterManager.add(executeWaitSignal, [signal, clazz, named], CallLaterManager.CLEAR_ALL_PREV_ACTION);

            return signal;
        }

        private function executeWaitSignalByClass(clazz:Class, named:String = ""):void
        {
            var className:String = getQualifiedClassName(clazz) + ((!StringUtil.isEmpty(named)) ? "_" + named : "");
            if (waitInjectSignals.hasKey(className))
            {
                var list:Array = (waitInjectSignals.itemFor(className) as Array);
                for each (var signal:Signal in list)
                    executeWaitSignal(signal, clazz, named);
            }
        }

        private function executeWaitSignal(signal:Signal, clazz:Class, named:String):void
        {
            signal.dispatch(injector.getInstance(clazz, named));
        }

        override public function dispose():void
        {
            var itr:IMapIterator = IMapIterator(waitInjectSignals.iterator());
            while (itr.hasNext())
                for each (var signal:Signal in itr.next())
                    signal.removeAll();

            waitInjectSignals.clear();
            _injectorEventDispatcher.removeAllEventListeners();

            super.dispose();
        }
    }
}
