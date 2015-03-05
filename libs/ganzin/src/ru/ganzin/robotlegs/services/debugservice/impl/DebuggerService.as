package ru.ganzin.robotlegs.services.debugservice.impl
{
    import com.junkbyte.console.Cc;

    import flash.events.ErrorEvent;
    import flash.events.UncaughtErrorEvent;
    import flash.utils.describeType;

    import robotlegs.bender.extensions.contextView.ContextView;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.api.LogLevel;

    import ru.ganzin.robotlegs.Service;
    import ru.ganzin.robotlegs.extensions.watcher.api.IWatchService;

    public class DebuggerService extends Service implements IWatchService
    {
        [Inject(optional=true)]
        public var context:IContext;

        [Inject]
        public var contextView:ContextView;

        [PostConstruct]
        public function init():void
        {
            Cc.config.commandLineAllowed = true;
            Cc.config.commandLineAutoScope = true;
            Cc.startOnStage(contextView.view, "`");
            Cc.commandLine = true;

            Cc.remoting = true;
            Cc.config.remotingPassword = "remote";

            context.addLogTarget(new FlashConsoleLogTarget(context));
            context.logLevel = LogLevel.DEBUG;

            contextView.view.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,
                    uncaughtErrorHandler, false, 0, true);
        }

        private function uncaughtErrorHandler(event:UncaughtErrorEvent):void
        {
            event.preventDefault();

            try
            {
                fatal(event.error);
            }
            catch (e:Error)
            {

            }
        }

//        private function filterCompleteHandler(event:FilterEvent):void
//        {
//            if (!debugConfigVO.enabled)
//            {
//                Cc.remove();
//                context.logLevel = LogLevel.WARN;
//            }
//            else
//            {
////                const prop:Properties = injector.getInstance(Properties, "build");
////                var ver:String = prop.getProperty("Specification-Title");
////                ver += " " + prop.getProperty("Implementation-Version");
////                IMain(contextView).setVersionText(ver);
//            }
//        }

        public function watch(value:*, name:String = null):void
        {
            var describe:XML = describeType(value);
            var name:String = describe.@name.toString();
            if (name.indexOf(".as$") == -1) name = name.substr(name.indexOf("::") + 2);

            Cc.watch(value, name);
        }

        public function fatal(value:*):void
        {
            if (value is Error) logger.fatal(Error(value).getStackTrace());
            else if (value is ErrorEvent) logger.fatal(ErrorEvent(value).toString());
            else logger.fatal(value);
        }
    }
}