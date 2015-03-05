package ru.ganzin.utils.bitmap
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;

    public class SmoothBitmap extends Bitmap
	{
		public function SmoothBitmap(bitmapData:BitmapData = null, pixelSnapping:String = 'auto')
		{
			super(bitmapData, pixelSnapping, true);
		}
		
		override public function get smoothing():Boolean
		{
			return super.smoothing;
		}
		
		override public function set smoothing(value:Boolean):void
		{
			super.smoothing = true;
		}
		
		override public function get bitmapData():BitmapData
		{
			return super.bitmapData;
		}
		
		override public function set bitmapData(value:BitmapData):void
		{
//			if (bitmapData && bitmapData != value)
//			{
//				var isExistingDataDisposed:Boolean = false;
//				try
//				{
//					bitmapData.width;
//				}
//				catch (e:Error)
//				{
//					isExistingDataDisposed = true;
//				}
//
//				if (!isExistingDataDisposed)
//					trace('WARNING: You are replacing bitmapData in ' + this + ' but did not explicitly dispose its existing bitmapData');
//
//			}
			
			super.bitmapData = value;
			smoothing = true;
		}
	}
}
