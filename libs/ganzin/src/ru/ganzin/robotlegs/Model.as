package ru.ganzin.robotlegs
{
    import ru.ganzin.robotlegs.injector.InjectorSupport;
    import ru.ganzin.signal.SignalsSupport;
    import ru.ganzin.utils.CallLaterManager;

    [ExcludeClass]

	public class Model extends Actor
	{
        /**
         * Менеджер отложенных вызовов.
         *
         * @see ru.ganzin.utils.CallLaterManager
         */
		private var _callLaterManager:CallLaterManager;
		protected function get callLaterManager():CallLaterManager
		{
			if (!_callLaterManager) _callLaterManager = new CallLaterManager();
			return _callLaterManager;
		}

		private var _injectorSupport:InjectorSupport;

        /**
         * Помошник для работы с инжекторами в robotlegs пространстве.
         * Основная его задача - это вешать хуки на событие маппинга какого-то класса в robotlegs.
         * Удаляет все хуки созданные через него после уничтожение класса через метод dispose().
         *
         * @see ru.ganzin.robotlegs.injector.InjectorSupport
         * @see #dispose
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
         * Удаляет все хуки созданные через него после уничтожение класса через метод dispose().
         *
         * @see ru.ganzin.signal.SignalsSupport
         * @see #dispose
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

		override public function dispose():void
		{
			if (_injectorSupport) _injectorSupport.dispose();
			if (_signalsSupport) _signalsSupport.dispose();
            if (_callLaterManager) _callLaterManager.dispose();

            super.dispose();
		}
	}
}
