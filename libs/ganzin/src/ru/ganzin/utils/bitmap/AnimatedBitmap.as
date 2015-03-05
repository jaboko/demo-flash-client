package ru.ganzin.utils.bitmap
{
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.geom.ColorTransform;
    import flash.utils.Dictionary;

    import org.as3commons.logging.api.ILogger;
    import org.as3commons.logging.api.getNamedLogger;
    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;
    import org.osflash.signals.natives.base.SignalTimer;

    import ru.ganzin.apron2.events.EventListenersManager;
    import ru.ganzin.apron2.events.IRemovableEventDispatcher;
    import ru.ganzin.apron2.interfaces.IDisposable;

    public class AnimatedBitmap extends SmoothBitmap implements IRemovableEventDispatcher, IDisposable
    {
        private static var count:uint = 0;
        count++;

        public static var fps:uint = 30;

        private var logger:ILogger;
        private var timer:SignalTimer;

        public var debug:Boolean = false;
        public var currentFrame:uint = 1;
        public var isPlaying:Boolean = false;
        public var frames:Array = new Array();

        public var endSignal:ISignal = new Signal();

        //-------------------------------------------------
        //	Constructor
        //-------------------------------------------------

        private var _pixelSnapping:String;

        private var _smoothing:Boolean;

        public function AnimatedBitmap(pixelSnapping:String = "auto", fps:uint = 0, frames:Array = null)
        {
            super(null, pixelSnapping);

            _pixelSnapping = pixelSnapping;
            _smoothing = smoothing;

            eventLM = new EventListenersManager(this, super.addEventListener, super.removeEventListener);

            logger = getNamedLogger("AnimatedBitmap(" + count + ")");

            this.fps = fps;

            if (frames) this.frames = frames;
        }

        //-------------------------------------------------
        //	Properties
        //-------------------------------------------------

        public function get totalFrames():uint
        {
            return frames.length;
        }

        private var _fps:int = -1;

        public function get fps():uint
        {
            return _fps;
        }

        public function set fps(value:uint):void
        {
            if (value == _fps) return;
            _fps = value;
            updateFrameHandler(true);
        }

        //-------------------------------------------------
        //	Medhods
        //-------------------------------------------------

        public function clone():AnimatedBitmap
        {
            var ab:AnimatedBitmap = new AnimatedBitmap(pixelSnapping, fps);
            $clone(ab);
            return ab;
        }

        protected function $clone(ab:AnimatedBitmap):AnimatedBitmap
        {
            var ct:ColorTransform = this.transform.colorTransform;
            ab.transform.colorTransform = ct;
            ab.transform.matrix = this.transform.matrix.clone();
            ab.filters = this.filters.concat();
            ab.fps = fps;
            ab.frames = frames.concat();
            ab.debug = debug;
            ab.currentFrame = currentFrame;
            ab.isPlaying = isPlaying;

            if (ab.isPlaying) ab.play();

            return ab;
        }

        public function addFrame(bd:BitmapData, frame:int = 0):void
        {
            if (debug) logger.debug("Добавлен кадр " + ((frame) ? frame : frames.length + 1));

            if (frame)
            {
                frames[frame - 1] = bd;
                if (frame == currentFrame) changeFrame(frame);
            }
            else frame = frames.push(bd) + 1;

            if (frame == currentFrame) changeFrame(frame);
        }

        public function removeAllFrames():void
        {
            if (debug) logger.debug("Удалены все кадры");

            bitmapData = null;
            frames = new Array();
        }

        public function play():void
        {
            if (debug) logger.debug("play()");

            isPlaying = true;
            changeFrame(currentFrame);
            updateFrameHandler();
        }

        public function stop():void
        {
            if (debug) logger.debug("stop()");

            gotoAndStop(currentFrame);
        }

        public function gotoAndStop(frame:Number):void
        {
            if (debug) logger.debug("gotoAndStop(" + frame + ")");

            isPlaying = false;
            changeFrame(frame);
            updateFrameHandler();
        }

        public function gotoAndPlay(frame:Number):void
        {
            if (debug) logger.debug("gotoAndPlay(" + frame + ")");

            changeFrame(frame);
            play();
        }

        private function changeFrame(frame:uint):void
        {
            if (debug) logger.debug("changeFrame(" + frame + ")");

            currentFrame = frame;
            var nextBitmapData:BitmapData = frames[currentFrame - 1];
            if (nextBitmapData)
            {
                bitmapData = nextBitmapData;
            }
        }

        private function updateFrameHandler(changeFps:Boolean = false):void
        {
            removeEventListener(Event.ENTER_FRAME, enterFrameHandler);

            if (fps == 0 && isPlaying) addEventListener(Event.ENTER_FRAME, enterFrameHandler);
            else if (fps != 0)
            {
                if (changeFps)
                {
                    if (timer) timer.signals.timer.remove(enterFrameHandler);
                    timer = getTimer(1000 / fps);
                }

                if (isPlaying)
                {
                    timer.signals.timer.add(enterFrameHandler);
                }
                else
                {
                    timer.signals.timer.remove(enterFrameHandler);
                }
            }
        }

        public function dispose():void
        {
            stop();

            if (timer) timer.signals.timer.remove(enterFrameHandler);
            timer = null;

            removeAllEventListeners();
            frames = [];
            bitmapData = null;
            logger = null;

            endSignal.removeAll();
        }

        //-------------------------------------------------
        //	Events Handlers
        //-------------------------------------------------

        private function enterFrameHandler(e:Event):void
        {
            currentFrame++;
            if (currentFrame > totalFrames)
            {
                if (endSignal.numListeners) endSignal.dispatch();
                currentFrame = 1;
            }
            changeFrame(currentFrame);
        }

        private var eventLM:EventListenersManager;

        override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
        {
            eventLM.removeEventListener(type, listener, useCapture);
        }

        override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
        {
            eventLM.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }

        public function removeAllEventListeners():void
        {
            eventLM.removeAllEventListeners();
        }

        public function removeEventsForListener(listener:Function):void
        {
            eventLM.removeEventsForListener(listener);
        }

        public function removeEventsForType(type:String):void
        {
            eventLM.removeEventsForType(type);
        }

        private static var timerMap:Dictionary = new Dictionary();

        private static function getTimer(delay:uint):SignalTimer
        {
            if (!timerMap[delay]) 
            {
                var t:SignalTimer = new SignalTimer(delay);
                t.start();
                timerMap[delay] = t;
            }
            return timerMap[delay];
        }
    }
}