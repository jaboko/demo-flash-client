/**
 * Created by jaboko on 27.02.15.
 */
package ru.ganzin.demo.view.base
{
    import feathers.controls.Screen;

    import starling.animation.Tween;
    import starling.core.Starling;
    import starling.events.Event;
    import starling.filters.ColorMatrixFilter;

    public class ScreenBase extends Screen
    {
        public static const INVALIDATION_IS_ENABLE_STATE:String = "isEnable";

        private var currentColorMatrixFilterTween:Tween;
        private var currentSaturation:Number = 0;

        override public function set isEnabled(value:Boolean):void
        {
            var isEnabledChanged:Boolean = (isEnabled != value);
            super.isEnabled = value;
            if (isEnabledChanged) invalidate(INVALIDATION_IS_ENABLE_STATE);
        }

        override protected function draw():void
        {
            super.draw();

            var stateInvalid:Boolean = this.isInvalid(INVALIDATION_IS_ENABLE_STATE);
            if (stateInvalid)
            {
                if (currentColorMatrixFilterTween)
                {
                    currentColorMatrixFilterTween.dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
                    currentColorMatrixFilterTween = null;
                }

                if (!((currentSaturation == 0 && isEnabled) || (currentSaturation == -1 && !isEnabled)))
                {
                    var currentScreen:ScreenBase = this;
                    var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter();
                    colorMatrixFilter.adjustSaturation(currentSaturation);
                    filter = colorMatrixFilter;

                    currentColorMatrixFilterTween = Starling.juggler.tween({saturation: currentSaturation}, .5, {
                        saturation: (isEnabled) ? 0 : -1,
                        onUpdate:   function ()
                        {
//                            trace("onUpdate", Tween(this).target.saturation);
                            currentSaturation = Tween(this).target.saturation;
                            colorMatrixFilter.reset();
                            colorMatrixFilter.adjustSaturation(currentSaturation);
                        },
                        onComplete:  function ()
                        {
//                            trace("onComplete");
                            if (isEnabled) currentScreen.filter = null;
                            currentSaturation = (isEnabled) ? 0 : -1;
                            currentColorMatrixFilterTween = null;
                        }
                    }) as Tween;
                }
            }
        }
    }
}
