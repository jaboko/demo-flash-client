/**
 * Created by jaboko on 27.09.14.
 */
package ru.ganzin.robotlegs.extensions.watcher.impl
{
    import flash.utils.Dictionary;

    import org.swiftsuspenders.InjectionEvent;
    import org.swiftsuspenders.mapping.MappingEvent;

    import robotlegs.bender.framework.api.IInjector;

    import ru.ganzin.robotlegs.extensions.watcher.api.IWatchService;

    /**
	 * @private
	 */
	public class InjectorListener
	{

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		private static const INJECTION_TYPES:Array = [
			InjectionEvent.POST_CONSTRUCT
//			, InjectionEvent.POST_INSTANTIATE
//			, InjectionEvent.PRE_CONSTRUCT
        ];

		private static const MAPPING_TYPES:Array = [
//			MappingEvent.MAPPING_OVERRIDE,
//			MappingEvent.POST_MAPPING_CHANGE,
//			MappingEvent.POST_MAPPING_CREATE,
//			MappingEvent.POST_MAPPING_REMOVE,
//			MappingEvent.PRE_MAPPING_CHANGE,
//			MappingEvent.PRE_MAPPING_CREATE
        ];

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:IInjector;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Creates an Injector Listener
		 * @param injector Injector
		 * @param logger Logger
		 */
		public function InjectorListener(injector:IInjector)
		{
			_injector = injector;
			addListeners();
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * Destroys this listener
		 */
		public function destroy():void
		{
            watchers = null;

			var type:String;
			for each (type in INJECTION_TYPES)
				_injector.removeEventListener(type, onInjectionEvent);

            for each (type in MAPPING_TYPES)
				_injector.removeEventListener(type, onMappingEvent);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function addListeners():void
		{
			var type:String;
			for each (type in INJECTION_TYPES)
				_injector.addEventListener(type, onInjectionEvent);

            for each (type in MAPPING_TYPES)
				_injector.addEventListener(type, onMappingEvent);
		}

        private var watchers:Dictionary = new Dictionary(true);

		private function onInjectionEvent(event:InjectionEvent):void
		{
            if (event.instance is IWatchService)
            {
                watchers[event.instance] = true;
            }
            else
            {
                for (var o:* in watchers)
                    (o as IWatchService).watch(event.instance);
            }
		}

		private function onMappingEvent(event:MappingEvent):void
		{
		}
	}
}
