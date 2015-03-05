package ru.ganzin.utils.bitmap.cache
{
    import flash.display.DisplayObjectContainer;

    public class SpriteBitmapCacherEvent extends BitmapCacherEvent
	{
		public static const BEFORE_SPRITE_RENDER:String = "beforeSpriteRender";
		public static const AFTER_SPRITE_RENDER:String = "afterSpriteRender";
				
		public function SpriteBitmapCacherEvent(type:String, sprite:DisplayObjectContainer, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, sprite, bubbles, cancelable);
		}
		
		public function get sprite():DisplayObjectContainer
		{
			return data as DisplayObjectContainer;
		}

	}
}