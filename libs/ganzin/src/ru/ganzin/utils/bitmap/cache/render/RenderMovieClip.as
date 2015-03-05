package ru.ganzin.utils.bitmap.cache.render
{
    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    import ru.ganzin.apron2.SimpleClass;
    import ru.ganzin.utils.bitmap.AnimatedBitmap;
    import ru.ganzin.utils.bitmap.cache.AnimationBitmapCacher;
    import ru.ganzin.utils.bitmap.cache.CacheOptions;
    import ru.ganzin.utils.bitmap.cache.SpriteBitmapCacher;
    import ru.ganzin.utils.bitmap.cache.cacher_internal;

    public class RenderMovieClip extends SimpleClass implements IRenderItem
	{
		use namespace cacher_internal;

		public var cacher:AnimationBitmapCacher;
		public var sprite:MovieClip;
		public var animation:AnimatedBitmap;
		public var rect:Rectangle;
		public var startFrame:uint;

		public var renderFramesCount:uint = 0;

		public var options:CacheOptions;

		public function RenderMovieClip(cacher:AnimationBitmapCacher, sprite:MovieClip, anim:AnimatedBitmap, rect:Rectangle, startFrame:uint)
		{
			this.cacher = cacher;
			this.sprite = sprite;
			this.animation = anim;
			this.rect = rect;
			this.currentSpriteFrame = startFrame;
			this.startFrame = startFrame;

			options = cacher.getOptions(sprite);
		}

		private var _currentSpriteFrame:uint;
		public function set currentSpriteFrame(value:uint):void
		{
			if (value > sprite.totalFrames)
			{
				logger.error("Ошибка в установке currentSpriteFrame. Такого кадра не сущесвует.");
			}
			_currentSpriteFrame = value;
		}
		public function get currentSpriteFrame():uint
		{
			return _currentSpriteFrame;
		}

		private var _currentAnimationFrame:uint;
		public function get currentAnimationFrame():uint
		{
			return _currentAnimationFrame;
		}

		public function get completed():Boolean
		{
			if (renderFramesCount >= animation.totalFrames) return true;
			else return false;
		}

		public function restart(startFrame:int = -1):void
		{
			if (startFrame != -1) this.startFrame = startFrame;
			currentSpriteFrame = startFrame;
			renderFramesCount = 0;
		}

		public function render():void
		{
			var scale:Point = options.scale;
			var renderingFrame:uint = currentSpriteFrame;
			_currentAnimationFrame = options.framesRelationsMap.getValue(_currentSpriteFrame);

			sprite.gotoAndStop(renderingFrame);

			// Показываем скрытые элементы
			if (!options.isExternal) animation.visible = false;
			cacher.showSpriteContent(sprite, options);

			var bd:BitmapData = new BitmapData(rect.width*scale.x, rect.height*scale.y, true, 0);
			cacher.drawBitmap(sprite, bd, rect, options);
			animation.addFrame(bd, currentAnimationFrame);

			// Скрывыем спрятаные элементы анимации
			if (!options.isExternal) animation.visible = true;
			if (options.hidingType != SpriteBitmapCacher.NOT_HIDING_TYPE) cacher.remakeContentSprites(sprite);
			cacher.hideSpriteContent(sprite, options);

			updateNextFrames();
			renderFramesCount++;
		}

		private function updateNextFrames():void
		{
			var sf:uint = options.skipFramesOnFrame+1;

			while(sf--)
			{
				if (_currentSpriteFrame == sprite.totalFrames) _currentSpriteFrame = 1;
				else _currentSpriteFrame++;
			}
		}

	}
}