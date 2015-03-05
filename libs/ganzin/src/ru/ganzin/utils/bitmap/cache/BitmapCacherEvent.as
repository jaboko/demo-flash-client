package ru.ganzin.utils.bitmap.cache
{
    import flash.events.Event;

    public class BitmapCacherEvent extends Event
	{
		public static const BEFORE_RENDER:String = "beforeRender";
		public static const AFTER_RENDER:String = "afterRender";

		private var _data:*;
		
		public function BitmapCacherEvent(type:String, data:* = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_data = data;
		}
		
		public function get data():*
		{
			return _data;
		}

	}
}