package ru.ganzin.robotlegs
{
    import flash.events.IEventDispatcher;

    import robotlegs.bender.framework.api.IInjector;
    import robotlegs.bender.framework.api.ILogger;

    import ru.ganzin.BaseClass;
    import ru.ganzin.apron2.interfaces.IDisposable;

    public class Actor extends BaseClass implements IDisposable
    {
        [Inject]
        public var injector:IInjector;

        [Inject]
        public var eventDispatcher:IEventDispatcher;

        [Inject]
        public var logger:ILogger;

        override public function dispose():void
        {
            super.dispose();
        }

        [PreDestroy]
        public function preDestroy():void
        {
            dispose();
        }
    }
}
