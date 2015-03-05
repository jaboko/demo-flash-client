package ru.ganzin.robotlegs
{
    import org.as3commons.lang.ClassUtils;
    import org.osflash.signals.natives.sets.StageSignalSet;

    import robotlegs.bender.bundles.mvcs.Mediator;
    import robotlegs.bender.extensions.contextView.ContextView;
    import robotlegs.bender.framework.api.IInjector;

    import ru.ganzin.apron2.interfaces.IDisposable;
    import ru.ganzin.apron2.utils.CallLaterManager;
    import ru.ganzin.robotlegs.injector.InjectorSupport;
    import ru.ganzin.signal.SignalsSupport;

    public class Mediator extends robotlegs.bender.bundles.mvcs.Mediator
    {
        [Inject]
        public var injector:IInjector;

        private var _cachedClassName:String;

        private var _viewComponent:Object;

        /**
         * @private
         */
        override public function set viewComponent(view:Object):void
        {
            _viewComponent = super.viewComponent = view;
        }

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

        public function getClassName():String
        {
            if (_cachedClassName) return _cachedClassName;
            return _cachedClassName = ClassUtils.getName(getClass());
        }

        private var _cachedFullClassName:String;

        public function getFullyClassName():String
        {
            if (_cachedFullClassName) return _cachedFullClassName;
            return _cachedFullClassName = ClassUtils.getFullyQualifiedName(getClass(), true);
        }

        private var _stageSignalSet:StageSignalSet;

        /**
         * Сет сигналов для стайджа.
         */
        public function get stageSignalSet():StageSignalSet
        {
            if (!_stageSignalSet)
            {
                if (!injector.hasMapping(StageSignalSet))
                {
                    var contextView:ContextView = injector.getInstance(ContextView);
                    injector.map(StageSignalSet).toValue(new StageSignalSet(contextView.view.stage));
                }
                _stageSignalSet = injector.getInstance(StageSignalSet);
            }
            return _stageSignalSet;
        }

        private var _cachedClass:Class;

        public function getClass():Class
        {
            if (_cachedClass) return _cachedClass;
            return _cachedClass = ClassUtils.forInstance(this);
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

            if (autoDisposeView && _viewComponent && _viewComponent is IDisposable)
            {
                IDisposable(_viewComponent).dispose();
            }
        }

        private var _autoDisposeView:Boolean = true;

        /**
         * Вызывать метод dispose() во viewComponent после удаления медиатора.
         */

        public function get autoDisposeView():Boolean
        {
            return _autoDisposeView;
        }

        public function set autoDisposeView(value:Boolean):void
        {
            _autoDisposeView = value;
        }
    }
}
