package ru.ganzin.robotlegs.services.debugservice
{
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.api.IExtension;

    import ru.ganzin.robotlegs.services.debugservice.impl.DebuggerService;
    import ru.ganzin.robotlegs.services.debugservice.utils.DebugConfig;

    public class DebugServiceExtension implements IExtension
	{
        private var _context:IContext;

		public function extend(context:IContext):void
		{
            _context = context;
            context.afterInitializing(whenInitializing);
		}

        private function whenInitializing():void
        {
            _context.injector.map(DebugConfig).asSingleton();
            _context.injector.map(DebuggerService).toSingleton(DebuggerService, true);
        }
	}
}
