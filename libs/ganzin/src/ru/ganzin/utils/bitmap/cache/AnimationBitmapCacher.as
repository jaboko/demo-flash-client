package ru.ganzin.utils.bitmap.cache
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.geom.Rectangle;

    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;

    import ru.ganzin.apron2.collections.HashMap;
    import ru.ganzin.apron2.collections.IMap;
    import ru.ganzin.apron2.managers.process.Process;
    import ru.ganzin.apron2.managers.process.ProcessManager;
    import ru.ganzin.apron2.managers.process.ProcessManagerEvent;
    import ru.ganzin.utils.bitmap.AnimatedBitmap;
    import ru.ganzin.utils.bitmap.cache.render.RenderMovieClip;
    import ru.ganzin.utils.bitmap.cache.render.RenderingProcess;

    public class AnimationBitmapCacher extends SpriteBitmapCacher
	{
		private var deferredRenderProcessesMap:HashMap = new HashMap();
		private var pm:ProcessManager;
		private var sequencePm:ProcessManager;
		
		public function AnimationBitmapCacher(defaultHidingType:String = UNVISIBLE_HIDING_TYPE, scale:* = null)
		{
			super(defaultHidingType, scale);
			
			pm = new ProcessManager();
			pm.addEventListener(ProcessManagerEvent.PROCESS_COMPLETED, processCompletedHandler,false,0,true);
			
			sequencePm = new ProcessManager();
			sequencePm.addEventListener(ProcessManagerEvent.PROCESS_COMPLETED, processCompletedHandler,false,0,true);
		}

//		public function addMovieClip(sprite:MovieClip, scale:Point = null, rectInflate:Point = null, 
//										smoothing:Boolean = false, deferredRender:Boolean = true, sequence:Boolean = false):void
//		{
//			var options:CacheOptions = spritesMap[sprite] = 
//				new CacheOptions(UNVISIBLE_HIDING_TYPE, scale, rectInflate, smoothing, true, deferredRender, sequence);
//			
//			makeSpriteContent(sprite);
//			drawBitmap(sprite);
//		}
		
		public function addMovieClip(sprite:MovieClip, options:CacheOptions, animation:AnimatedBitmap = null):ISignal
		{
			options.isMovieClip = true;
			if (animation) options.isExternal = true;
			if (!options.hidingType) options.hidingType = defaultHidingType;
            options.completeSignal = new Signal();
			
			spritesMap[sprite] = options;
			
			if (options.hidingType != NOT_HIDING_TYPE) makeSpriteContent(sprite);
			
			drawBitmap(sprite, animation);

            return options.completeSignal;
		}
		
		public function isMovieClipRenderingCompleted(sprite:MovieClip):Boolean
		{
			var options:CacheOptions = spritesMap[sprite] as CacheOptions;
			if (!options) return false;
			else if (options.deferredRender && !deferredRenderProcessesMap[sprite]) return true;
			return false;
		}
		 	
		override public function removeSprite(sprite:DisplayObjectContainer) : void
		{
			var options:CacheOptions = spritesMap[sprite] as CacheOptions;
			
			if (options.isMovieClip)
			{
				removeDeferredRenderProcess(sprite);
				
				if (!options.isExternal)
				{
					var animBmp:AnimatedBitmap = sprite.getChildByName(ANIMATION_BITMAP_SPRITE_NAME) as AnimatedBitmap;
					
					if (animBmp.isPlaying) (sprite as MovieClip).gotoAndPlay(animBmp.currentFrame);
					else (sprite as MovieClip).gotoAndStop(animBmp.currentFrame);
					
					animBmp.parent.removeChild(animBmp);
				}
			}
			
			super.removeSprite(sprite);
		}
		
		public function getAnimatedBitmap(sprite:DisplayObjectContainer):AnimatedBitmap
		{
			return getBitmap(sprite) as AnimatedBitmap;
		}
		
		cacher_internal function getMovieClip(bitmap:AnimatedBitmap):MovieClip
		{
			return cacher_internal::getSprite(bitmap) as MovieClip;
		}
		
		override protected function drawBitmap(value:DisplayObjectContainer, bitmap:Bitmap = null) : void
		{
			var options:CacheOptions = spritesMap[value] as CacheOptions;
			
			if (!options) return;
			if (options.isMovieClip)
			{
				if (hasEventListener(SpriteBitmapCacherEvent.BEFORE_SPRITE_RENDER))
					dispatchEvent(new SpriteBitmapCacherEvent(SpriteBitmapCacherEvent.BEFORE_SPRITE_RENDER,value));
				
				$drawBitmapFromMovieClip(value as MovieClip, options, bitmap as AnimatedBitmap);
				
				if (hasEventListener(SpriteBitmapCacherEvent.AFTER_SPRITE_RENDER))
					dispatchEvent(new SpriteBitmapCacherEvent(SpriteBitmapCacherEvent.AFTER_SPRITE_RENDER,value));
			}
			else super.drawBitmap(value, bitmap);
		}
		
		cacher_internal function remakeContentSprites(sprite:DisplayObjectContainer):void
		{
			var list:Array = contentsMap[sprite];
			
			var sp:DisplayObject;
			var anim:Bitmap = getBitmap(sprite);
			for(var i:int = 0; i < sprite.numChildren; i++)
			{
				sp = sprite.getChildAt(i);
				if (sp && sp != anim && sp.visible && list.indexOf(sp) == -1)
					list.push(sp);
			}
		}
		
		private function $drawBitmapFromMovieClip(sprite:MovieClip, options:CacheOptions, animation:AnimatedBitmap = null):void
		{
			var bd:BitmapData;
			var rect:Rectangle = new Rectangle();
			var currentFrame:uint = sprite.currentFrame;
			var playing:Boolean = false;
			
			// Проигрывается или остановлено
			if (sprite.currentFrame > 1 && sprite.currentFrame < sprite.totalFrames) playing = true;
			
			// Производим замеры клипа
			for(var i:int = 0; i < sprite.totalFrames; i++)
			{
				sprite.gotoAndStop(i);
				rect = rect.union(sprite.getBounds(sprite));
			}
			
			rect.inflatePoint(options.rectInflate);
			
			// Размеры битмапов
			var width:int = rect.width*options.scale.x*1.2;
			var height:int = rect.height*options.scale.y*1.2;

			if (debug) logger.warn("Размер битмапа w:{0} h:{1}",[width,height]);

			options.framesRelationsMap = makeFrameRelationsMap(sprite, options);
			
			var p:RenderingProcess;
			
			// Клип находится в отложенном рендеринге
			if (options.deferredRender && deferredRenderProcessesMap.containsKey(sprite))
			{
				p = deferredRenderProcessesMap.getValue(sprite);
				var rmci:RenderMovieClip = p.cacher_internal::item as RenderMovieClip;
				
				// Проверяем битмар анимации на соответствие размерам
				bd = rmci.animation.bitmapData;
				if (bd && bd.rect.width == width && bd.rect.height == height)
				{
					rmci.restart(rmci.animation.currentFrame);
					return;
				}
				else removeDeferredRenderProcess(sprite);
			}
			
			// Инициализация анимации
			var animInfo:Object = {};
			var animBmp:AnimatedBitmap = makeAnimation(sprite, options, animation, animInfo);
			if (animInfo.hasOwnProperty("currentFrame")) currentFrame = animInfo["currentFrame"];
			if (animInfo.hasOwnProperty("playing")) playing = animInfo["playing"];
			bitmapsMap[sprite] = animBmp;
			
			var renderCompleted:Boolean = false;
			
			if (options.deferredRender)
			{
				if (debug) logger.debug("Добавлена анимация на отложенный рендеринг "+sprite.name);
				
				p = new RenderingProcess(new RenderMovieClip(this, sprite, animBmp, rect, currentFrame));
				if (options.sequence) sequencePm.addProcess(p);
				else
				{
					pm.addProcess(p);
					for(i = 0; i < options.preRenderFramesCount; i++) p.run();
				}
				
				deferredRenderProcessesMap.put(sprite,p);
			}
			else
			{
				// Показываем скрытые элементы
				showSpriteContent(sprite, options);
				
				for(i = 0; i < sprite.totalFrames; i++)
				{
					sprite.gotoAndStop(i);
					bd = new BitmapData(width, height, true, 0);
					$$drawBitmap(sprite, bd, rect, options);
					animBmp.addFrame(bd, i);
				}
				
				// Скрывыем спрятаные элементы анимации
				hideSpriteContent(sprite, options);
				
				sprite.gotoAndStop(currentFrame);
				
				renderCompleted = true;
			}
			
			if (!options.isExternal)
			{
				sprite.addChildAt(animBmp,0);
				animBmp.scaleX = 1/options.scale.x;
				animBmp.scaleY = 1/options.scale.y;
				animBmp.x = rect.x;
				animBmp.y = rect.y;
			}

			if (playing) animBmp.gotoAndPlay(currentFrame);
			else animBmp.gotoAndStop(currentFrame);

			if (renderCompleted) dispatchEvent(new AnimationCacherEvent(AnimationCacherEvent.RENDER_COMPLETED, sprite));
		}
		
		private function makeFrameRelationsMap(sprite:MovieClip, options:CacheOptions):IMap
		{
			// Делаем карту отношей кадров в спрайте к кадрам анимации
			var map:IMap = new HashMap();
			var skipFrames:uint = options.skipFramesOnFrame;
			var currentAnimationsFrame:uint = 1;
			for(var i:uint = 1; i <= sprite.totalFrames; i++)
			{
				if (i != 1 && ((i-1) % (skipFrames+1)) == 0) currentAnimationsFrame++;
				map.put(i,currentAnimationsFrame);
			}
			return map;
		}
		
		private function makeAnimation(sprite:MovieClip, options:CacheOptions, animation:AnimatedBitmap, retInfo:Object):AnimatedBitmap
		{
			var animBmp:AnimatedBitmap = sprite.getChildByName(ANIMATION_BITMAP_SPRITE_NAME) as AnimatedBitmap;
			if (animation) animBmp = animation;
						
			if (!animBmp)
			{
				// Создаём растровую анимацию
				animBmp = new AnimatedBitmap(options.pixelSnapping);
				animBmp.name = ANIMATION_BITMAP_SPRITE_NAME;
			}
			else
			{
				// Запоминаем позицию в анимации
				retInfo["currentFrame"] = animBmp.currentFrame;
				retInfo["playing"] = animBmp.isPlaying;
				
				if (!options.isExternal) animBmp.parent.removeChild(animBmp);
				
				// Если изменилось количество кадров в спрайте,
				// то очищаем анимацию от кадров и создаём пустышки 
				if (animBmp.totalFrames != sprite.totalFrames)
				{
					animBmp.removeAllFrames();
					
					var skipFrames:uint = options.skipFramesOnFrame;
					for(var i:uint = 1; i <= sprite.totalFrames; i++)
					{
						if (((i-1) % (skipFrames+1)) == 0) 
							animBmp.addFrame(null);
					}
				}
			}
			
			return animBmp;
		}

		private function removeDeferredRenderProcess(value:*):void
		{
			var key:*;
			if (value is MovieClip && deferredRenderProcessesMap.containsKey(value)) key = value;
			else if (deferredRenderProcessesMap.containsValue(value)) key = deferredRenderProcessesMap.getKey(value);
			
			if (key)
			{
				var p:Process = deferredRenderProcessesMap.getValue(key);
				pm.removeProcess(p);
				sequencePm.removeProcess(p);
				deferredRenderProcessesMap.remove(key);
			}
		}
		
		private function processCompletedHandler(e:ProcessManagerEvent):void
		{
			var rp:RenderingProcess = e.process as RenderingProcess;
			if (rp)
			{
				var item:RenderMovieClip = rp.cacher_internal::item as RenderMovieClip;
				if (item) 
                {
                    dispatchEvent(new AnimationCacherEvent(AnimationCacherEvent.RENDER_COMPLETED, item.sprite));
                    if (item.options.completeSignal) item.options.completeSignal.dispatch();
                }
			}
			
			removeDeferredRenderProcess(e.process);
		}
	}
}