package ru.ganzin.utils.bitmap.cache
{
	public class AnimationCacherEvent extends BitmapCacherEvent
	{
		public static const RENDER_STARTED:String = "renderStarted";
		public static const RENDER_COMPLETED:String = "renderCompleted";
		
		public function AnimationCacherEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}