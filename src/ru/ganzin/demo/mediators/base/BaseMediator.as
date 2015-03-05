/**
 * Created by Dmitriy Ganzin on 04.03.15.
 */
package ru.ganzin.demo.mediators.base
{
    import robotlegs.bender.framework.api.IInjector;
    import robotlegs.starling.bundles.mvcs.Mediator;

    import ru.ganzin.robotlegs.injector.InjectorSupport;
    import ru.ganzin.signal.SignalsSupport;
    import ru.ganzin.utils.CallLaterManager;

    public class BaseMediator extends Mediator
    {
        [Inject]
        public var injector:IInjector;

        private var _callLaterManager:CallLaterManager;

        /**
         * Менеджер отложенных вызовов.
         *
         * @see ru.ganzin.utils.CallLaterManager
         */

        protected function get callLaterManager():CallLaterManager
        {
            if (!_callLaterManager) _callLaterManager = new CallLaterManager();
            return _callLaterManager;
        }

        private var _injectorSupport:InjectorSupport;

        /**
         * Помошник для работы с инжекторами в robotlegs пространстве.
         * Основная его задача - это вешать хуки на событие маппинга какого-то класса в robotlegs.
         * Удаляет все хуки созданные через него после уничтожение класса через метод preRemove().
         *
         * @see ru.ganzin.robotlegs.injector.InjectorSupport
         * @see #preRemove
         */

        protected function get injectorSupport():InjectorSupport
        {
            if (!_injectorSupport)
            {
                _injectorSupport = new InjectorSupport();
                injector.injectInto(_injectorSupport);
            }
            return _injectorSupport;
        }

        private var _signalsSupport:SignalsSupport;

        /**
         * Помошник для работы с сигналами в ограниченном пространства данного класса.
         * Удаляет все хуки созданные через него, после уничтожение класса через метод preRemove().
         *
         * @see SignalsSupport
         * @see #preRemove
         */

        protected function get signalsSupport():SignalsSupport
        {
            if (!_signalsSupport)
            {
                _signalsSupport = new SignalsSupport();
                injector.injectInto(_signalsSupport);
            }
            return _signalsSupport;
        }

        override public function destroy():void
        {
            if (_injectorSupport) _injectorSupport.dispose();
            if (_callLaterManager) _callLaterManager.dispose();
            if (_signalsSupport) _signalsSupport.dispose();
        }
    }
}
