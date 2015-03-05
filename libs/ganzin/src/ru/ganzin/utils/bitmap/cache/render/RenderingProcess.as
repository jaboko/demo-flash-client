package ru.ganzin.utils.bitmap.cache.render
{
    import flash.utils.getTimer;

    import ru.ganzin.apron2.apron_internal;
    import ru.ganzin.apron2.managers.process.Process;
    import ru.ganzin.apron2.managers.process.ProcessState;
    import ru.ganzin.utils.bitmap.cache.CacheOptions;
    import ru.ganzin.utils.bitmap.cache.cacher_internal;

    public class RenderingProcess extends Process
	{
		private static const INIT_STEP:uint = 0
		private static const RENDERING_STEP:uint = 1;
		
		use namespace apron_internal;
		use namespace cacher_internal;
		
		cacher_internal var item:IRenderItem;
		
		private var processStep:uint = INIT_STEP;
		
		public function RenderingProcess(item:IRenderItem, priority:int=-1, eventName:String=null)
		{
			super(null, priority, 0, eventName);
			
			this.item = item;
		}
		
		override public function run():uint
		{
			try
			{
				var renderMC:RenderMovieClip = item as RenderMovieClip;
				var options:CacheOptions;
				if (renderMC) options = renderMC.cacher.getOptions(renderMC.sprite);
				
				switch(processStep)
				{
					case INIT_STEP:
						
						if (renderMC) logger.debug("Начат рендеринг для спрайта "+renderMC.sprite+" "+getTimer());
						processStep = RENDERING_STEP;
						
					break;
					
					case RENDERING_STEP:
						
						for(var i:int = 0; i < options.renderFramesOnTick; i++)
							if (!item.completed) item.render();
						
					break;
				}
	
				if (item.completed)
				{
					if (renderMC) logger.debug("Закончен рендеринг для спрайта "+renderMC.sprite+" "+getTimer());
					return ProcessState.COMPLETED;
				}
				else if (options && options.sequence) return ProcessState.HOLD;
			}
			catch(e:Error)
			{
				logger.warn(e);
			}
			
			return 0;
		}
			
		override public function equals(process:Process):Boolean
		{
			if (process is RenderingProcess && process.id == id && 
				process.eventName == eventName && (process as RenderingProcess).item == item) return true;
			return false;
		}
	}
}