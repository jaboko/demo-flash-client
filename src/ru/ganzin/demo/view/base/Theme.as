/**
 * Created by Dmitriy Ganzin on 04.03.15.
 */
package ru.ganzin.demo.view.base
{
    import feathers.themes.MetalWorksDesktopTheme;

    public class Theme extends MetalWorksDesktopTheme
    {
        override protected function initializeScale():void
        {
            super.scale = 1.5;
        }
    }
}
