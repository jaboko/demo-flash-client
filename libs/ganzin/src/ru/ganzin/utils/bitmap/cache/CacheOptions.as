package ru.ganzin.utils.bitmap.cache
{
    import flash.geom.Point;

    import org.osflash.signals.Signal;

    import ru.ganzin.apron2.collections.IMap;

    public class CacheOptions
	{
		public var smoothing:Boolean;
		public var pixelSnapping:String;
		public var hidingType:String;
		public var scale:Point;
		public var isMovieClip:Boolean;
		public var isExternal:Boolean;
		public var rectInflate:Point;
		public var deferredRender:Boolean;
		public var sequence:Boolean;
		
		public var preRenderFramesCount:uint = 0;
		public var renderFramesOnTick:uint = 1;
		public var skipFramesOnFrame:uint = 0;
		public var framesRelationsMap:IMap;
        public var completeSignal:Signal;
		
		public function CacheOptions(hidingType:String = null, scale:Point = null, rectInflate:Point = null, 
				smoothing:Boolean = false, isMovieClip:Boolean = false, deferredRender:Boolean = true, sequence:Boolean = false)
		{
			this.smoothing = smoothing;
			this.hidingType = hidingType;
			this.scale = (scale)?scale:new Point(1,1);
			this.rectInflate = (rectInflate)?rectInflate:new Point(1,1);
			this.isMovieClip = isMovieClip;
			this.deferredRender = deferredRender;
			this.sequence = sequence;
		}
	}
}