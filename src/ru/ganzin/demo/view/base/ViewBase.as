/**
 * Created by jaboko on 27.02.15.
 */
package ru.ganzin.demo.view.base
{
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.ResizeEvent;

    public class ViewBase extends Sprite
    {
        public function ViewBase()
        {
            super();
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }

        private function onAddedToStage(event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            stage.addEventListener(ResizeEvent.RESIZE, onStageResize);

            onSetup();
            onLayout();
        }

        private function onStageResize(event:ResizeEvent):void
        {
            onLayout();
        }

        protected function onLayout():void
        {
        }

        protected function onSetup():void
        {
        }
    }
}
