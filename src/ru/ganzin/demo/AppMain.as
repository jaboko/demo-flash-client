package ru.ganzin.demo
{
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.geom.Rectangle;

    import robotlegs.bender.extensions.contextView.ContextView;
    import robotlegs.bender.extensions.contextView.ContextViewExtension;
    import robotlegs.bender.extensions.signalCommandMap.SignalCommandMapExtension;
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.impl.Context;
    import robotlegs.starling.bundles.mvcs.StarlingBundle;
    import robotlegs.starling.extensions.contextView.ContextView;
    import robotlegs.starling.extensions.viewProcessorMap.ViewProcessorMapExtension;

    import ru.ganzin.demo.view.MainView;

    import starling.core.Starling;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    [SWF(width="960", height="640", frameRate="60", backgroundColor="#4a4137")]
    public class AppMain extends Sprite
    {
        public function AppMain()
        {
            if (this.stage)
            {
                this.stage.scaleMode = StageScaleMode.NO_SCALE;
                this.stage.align = StageAlign.TOP_LEFT;
            }
            this.mouseEnabled = this.mouseChildren = false;
            this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
        }

        private var starling:Starling;
        private var context:IContext;

        private function loaderInfo_completeHandler(event:Event):void
        {
            Starling.handleLostContext = true;
            Starling.multitouchEnabled = true;

            starling = new Starling(MainView, this.stage);
            starling.enableErrorChecking = false;
            starling.showStats = true;
            starling.showStatsAt(HAlign.RIGHT, VAlign.TOP);

            starling.start();

            context = new Context()
                    .install(StarlingBundle, SignalCommandMapExtension, ViewProcessorMapExtension)
                    .install(ContextViewExtension)
                    .configure(new robotlegs.bender.extensions.contextView.ContextView(this))
                    .configure(new robotlegs.starling.extensions.contextView.ContextView(starling))
                    .configure(AppConfig);

            this.stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
            this.stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
        }

        private function stage_resizeHandler(event:Event):void
        {
            starling.stage.stageWidth = this.stage.stageWidth;
            starling.stage.stageHeight = this.stage.stageHeight;

            var viewPort:Rectangle = starling.viewPort;
            viewPort.width = this.stage.stageWidth;
            viewPort.height = this.stage.stageHeight;
            try
            {
                starling.viewPort = viewPort;
            }
            catch (error:Error)
            {}
        }

        private function stage_deactivateHandler(event:Event):void
        {
            starling.stop();
            this.stage.addEventListener(Event.ACTIVATE, stage_activateHandler, false, 0, true);
        }

        private function stage_activateHandler(event:Event):void
        {
            this.stage.removeEventListener(Event.ACTIVATE, stage_activateHandler);
            starling.start();
        }
    }
}