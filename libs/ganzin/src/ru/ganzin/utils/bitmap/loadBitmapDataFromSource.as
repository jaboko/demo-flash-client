/**
 * Created by jaboko on 05.09.14.
 */
package ru.ganzin.utils.bitmap
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;

    public function loadBitmapDataFromSource(source:*):BitmapData
    {
        if (source is Class) source = new source;
        if (source is Bitmap) return Bitmap(source).bitmapData;
        if (source is BitmapData) return source;
        return source;
    }
}
