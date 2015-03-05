/**
 * Created by Dmitriy Ganzin on 04.03.15.
 */
package ru.ganzin.demo.view.screens
{
    import feathers.controls.ImageLoader;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.VerticalLayout;

    import ru.ganzin.demo.view.base.ScreenBase;

    import starling.animation.Transitions;
    import starling.animation.Tween;
    import starling.core.Starling;
    import starling.display.Image;
    import starling.filters.ColorMatrixFilter;
    import starling.textures.Texture;
    import starling.utils.deg2rad;

    public class BusyScreen extends ScreenBase
    {
        [Embed(source="/assets/gear37.png")]
        public static const gear:Class;

        override protected function initialize():void
        {
            super.initialize();

            var layout:VerticalLayout = new VerticalLayout();
            layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
            layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
            this.layout = layout;

            var image:Image = new Image(Texture.fromEmbeddedAsset(gear));
            image.alignPivot();

            var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter();
            colorMatrixFilter.invert();
            image.filter = colorMatrixFilter;

            addChild(image);

            var tween:Tween = new Tween(image, 2, Transitions.LINEAR);
            tween.repeatCount = 0;
            tween.animate("rotation", deg2rad(360));
            Starling.juggler.add(tween);
        }
    }
}
