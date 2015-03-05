package ru.ganzin.utils.bitmap.cache
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.PixelSnapping;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    import ru.ganzin.apron2.SimpleClass;

    use namespace cacher_internal;

    public class SpriteBitmapCacher extends SimpleClass
	{
		public static const BITMAP_SPRITE_NAME:String = "__cached_bitmap__";
		public static const ANIMATION_BITMAP_SPRITE_NAME:String = "__cached_bitmap_animation__";
		public static const UNVISIBLE_HIDING_TYPE:String = "visibleHidingType";
		public static const NOT_HIDING_TYPE:String = "notHidingType";
		
		public var debug:Boolean = false;
		
		private var _defaultHidingType:String;
		private var _defaultScale:Point;
		
		protected var renderExclusionMap:Dictionary;
		protected var spritesMap:Dictionary;
		protected var bitmapsMap:Dictionary;
		protected var contentsMap:Dictionary;
		
		//-------------------------------------------------
		//	Constructor
		//-------------------------------------------------
		
		public function SpriteBitmapCacher(defaultHidingType:String = UNVISIBLE_HIDING_TYPE, scale:* = null)
		{
			renderExclusionMap = new Dictionary(true);
			spritesMap = new Dictionary(true);
			bitmapsMap = new Dictionary(true);
			contentsMap = new Dictionary(true);
			
			_defaultHidingType = defaultHidingType;
			
			if (scale)
			{
				if (scale is Point) _defaultScale = (scale as Point).clone();
				else _defaultScale = new Point(Number(scale),Number(scale));
			}
			else _defaultScale = new Point(1,1);
		}
		
		//-------------------------------------------------
		//	Properties
		//-------------------------------------------------
		
		public function get defaultScale():Point
		{
			return 	_defaultScale.clone();
		}
		public function set defaultScale(value:Point):void
		{
			_defaultScale = value.clone();
			redrawAll();
		}
		
		public function get defaultHidingType():String
		{
			return _defaultHidingType;
		}
		
		private var _showDebugRect:Boolean = false;
		public function get showDebugRect():Boolean
		{
			return _showDebugRect;
		}
		public function set showDebugRect(value:Boolean):void
		{
			_showDebugRect = value;
			redrawAll();
		}
		
		public function get isEmpty():Boolean
		{
			for each (var o:* in spritesMap) return false;
			return true;
		}
		
		//-------------------------------------------------
		//	Medhods
		//-------------------------------------------------
		
		cacher_internal function getOptions(sprite:DisplayObjectContainer):CacheOptions
		{
			return spritesMap[sprite];
		}

		cacher_internal function getSprite(bitmap:Bitmap):DisplayObjectContainer
		{
			for (var key:* in bitmapsMap)
				if (bitmapsMap[key] == bitmap) return key;
			return null;
		}
		
		public function containSprite(sprite:DisplayObjectContainer):Boolean
		{
			return spritesMap[sprite] != null;
		}
		
		public function addSprite(sprite:DisplayObjectContainer, scale:Point = null, rectInflate:Point = null,
                                  smoothing:Boolean = false, hidingType:String = null, isExternal:Boolean = false):void
		{
			if (debug) logger.debug("addSprite("+[sprite,scale,rectInflate,smoothing,hidingType]+")");
			
			var options:CacheOptions = spritesMap[sprite] = 
				new CacheOptions((hidingType)?hidingType:_defaultHidingType, scale, rectInflate, smoothing);
            options.isExternal = isExternal;
			
			if (options.hidingType != NOT_HIDING_TYPE) makeSpriteContent(sprite);
			drawBitmap(sprite);
		}
		
		public function getBitmap(sprite:DisplayObjectContainer):Bitmap
		{
			return bitmapsMap[sprite];
		}
		
		public function addRenderExclusion(sprite:DisplayObject):void
		{
			if (debug) logger.debug("addRenderExclusion("+sprite+")");
			
			renderExclusionMap[sprite] = 1;
		}
		
		public function removeRenderExclusion(sprite:DisplayObject):void
		{
			if (debug) logger.debug("removeRenderExclusion("+sprite+")");
			
			delete renderExclusionMap[sprite];
		}
		
		public function removeSprite(sprite:DisplayObjectContainer):void
		{
			if (debug) logger.debug("removeSprite("+sprite+")");
			
			var options:CacheOptions = spritesMap[sprite] as CacheOptions;
			
			if (!options) return;
			
			showSpriteContent(sprite);
			
			var bmp:DisplayObject = sprite.getChildByName(BITMAP_SPRITE_NAME);
			if (bmp) bmp.parent.removeChild(bmp);
			
			delete spritesMap[sprite];
			delete contentsMap[sprite];
			delete bitmapsMap[sprite];
		}
		
		public function removeAllSprites():void
		{
			if (debug) logger.debug("removeAllSprites()");
			
			for (var sprite:* in spritesMap)
				removeSprite(sprite);
		}
		
		public function redrawSprite(sprite:DisplayObjectContainer, bitmap:Bitmap = null):void
		{
			if (debug) logger.debug("redrawSprite("+sprite+")");
			
			drawBitmap(sprite, bitmap);
		}

		public function redrawAll():void
		{
			if (debug) logger.debug("redrawAll()");
			
			for (var sprite:* in spritesMap)
				drawBitmap(sprite as DisplayObjectContainer);
		}
		
		//-------------------------------------------------
		//	Private Medhods
		//-------------------------------------------------
		
		protected function drawBitmap(value:DisplayObjectContainer, bitmap:Bitmap = null):void
		{
			if (debug) logger.debug("drawBitmap("+value+")");
			
			var options:CacheOptions = spritesMap[value] as CacheOptions;
			
			if (!options) return;
			
			if (hasEventListener(SpriteBitmapCacherEvent.BEFORE_SPRITE_RENDER))
				dispatchEvent(new SpriteBitmapCacherEvent(SpriteBitmapCacherEvent.BEFORE_SPRITE_RENDER,value));			
			
			$drawBitmapFromSprite(value, options, bitmap);
			
			if (hasEventListener(SpriteBitmapCacherEvent.AFTER_SPRITE_RENDER))
				dispatchEvent(new SpriteBitmapCacherEvent(SpriteBitmapCacherEvent.AFTER_SPRITE_RENDER,value));
		}
		
		private function $drawBitmapFromSprite(sprite:DisplayObjectContainer, options:CacheOptions, bitmap:Bitmap = null):void
		{
			var bmp:Bitmap = sprite.getChildByName(BITMAP_SPRITE_NAME) as Bitmap;
			if (bitmap) bmp = bitmap;

			var bd:BitmapData;
			var sp:DisplayObject;
			var rect:Rectangle = sprite.getBounds(sprite);
			rect.inflatePoint(options.rectInflate);
			
			if (!bmp)
			{
				bmp = new Bitmap(bd, options.pixelSnapping || PixelSnapping.ALWAYS, options.smoothing);
				bmp.name = BITMAP_SPRITE_NAME;
			}
			else
			{
				if (!options.isExternal) bmp.parent.removeChild(bmp);
			}

			if (!bmp.bitmapData) bmp.bitmapData = new BitmapData(rect.width*options.scale.x+2, rect.height*options.scale.y+2, true, 0x00FF00);
			bd = bmp.bitmapData;
			
			bitmapsMap[sprite] = bmp;
			
			showSpriteContent(sprite, options);
			$$drawBitmap(sprite, bd, rect, options);
			hideSpriteContent(sprite, options);
			
			if (!options.isExternal)
			{
				bmp.scaleX = 1/options.scale.x;
				bmp.scaleY = 1/options.scale.y;
				bmp.x = rect.x;// + sprite.x;
				bmp.y = rect.y;// + sprite.y;
				
				sprite.addChildAt(bmp,0);
			}
		}
		
		private var cachedMatrix:Dictionary = new Dictionary();
		
		protected function $$drawBitmap(sprite:DisplayObject, bd:BitmapData, rect:Rectangle, options:CacheOptions = null):void
		{
			if (debug) trace("Отрисовывается кадр. ", sprite, rect);
			
			if (!options) options = spritesMap[sprite];
			var scale:Point = options.scale;
			
			var key:String = [rect.width, rect.height, scale.x, scale.y].join("_");
			var mtx:Matrix;
			if (cachedMatrix[key]) mtx = cachedMatrix[key];
			else
			{			
				mtx = new Matrix();
				mtx.scale(scale.x, scale.y);
				mtx.translate(-rect.x*scale.x, -rect.y*scale.y);
						
				cachedMatrix[key] = mtx;
			}
			
			bd.fillRect(bd.rect, 0);
			bd.draw(sprite, mtx, null, null, null, options.smoothing);
			
			if (_showDebugRect)
			{
				var sp:Sprite = new Sprite();
				sp.graphics.lineStyle(5,0xFF0000);
				sp.graphics.drawRect(0,0,bd.width,bd.height);
				bd.draw(sp);
			}
		}
		
		protected function makeSpriteContent(sprite:DisplayObjectContainer):void
		{
			var list:Array = [];
			
			var sp:DisplayObject;
			for(var i:int = 0; i < sprite.numChildren; i++)
			{
				sp = sprite.getChildAt(i);
				if (sp.visible)
				{
					list.push(sp);
				}
			}
			
			contentsMap[sprite] = list;
		}
		
		protected function hideSpriteContent(sprite:DisplayObjectContainer, options:CacheOptions = null):void
		{
			if (!options) options = spritesMap[sprite] as CacheOptions;
			
			var sp:DisplayObject;
			
			switch(options.hidingType)
			{
				case NOT_HIDING_TYPE: return;
				case UNVISIBLE_HIDING_TYPE:
					for each (sp in contentsMap[sprite])
					{
						sp.visible = false;
					}
				break;
			}
		}
		
		protected function showSpriteContent(sprite:DisplayObjectContainer, options:CacheOptions = null):void
		{
			if (!options) options = spritesMap[sprite] as CacheOptions;
			
			var sp:DisplayObject;
			
			switch(options.hidingType)
			{
				case NOT_HIDING_TYPE: return;
				case UNVISIBLE_HIDING_TYPE:
					for each (sp in contentsMap[sprite])
					{
						sp.visible = true;
					}
				break;
			}
		}
		
		//-------------------------------------------------
		//	namespace cacher_internal
		//-------------------------------------------------
		
		cacher_internal function drawBitmap(sprite:DisplayObject, bd:BitmapData, rect:Rectangle, options:CacheOptions = null):void
		{
			$$drawBitmap(sprite, bd, rect, options);
		}
		
		cacher_internal function hideSpriteContent(sprite:DisplayObjectContainer, options:CacheOptions = null):void
		{
			hideSpriteContent(sprite, options);
		}
		
		cacher_internal function showSpriteContent(sprite:DisplayObjectContainer, options:CacheOptions = null):void
		{
			showSpriteContent(sprite, options);
		}
	}
}
