/**
 * User: Dmitriy Ganzin
 * Date: 07.06.11
 * Time: 18:25
 */
package ru.ganzin.utils.lifecycle
{
    import flash.events.Event;
    import flash.utils.Dictionary;

    import org.as3commons.lang.ObjectUtils;

    import ru.ganzin.apron2.SimpleSprite;
    import ru.ganzin.utils.CallLaterManager;

    public class SpriteClipLifeCycle extends SimpleSprite implements ILifeCycleObject
	{
		public static const ALL_PROPERTIES:String = "Invalidation_ALL_PROPERTIES";

		private var _callLaterManager:CallLaterManager;

        protected var disposed:Boolean;

		protected function get callLaterManager():CallLaterManager
		{
			if (!_callLaterManager) _callLaterManager = new CallLaterManager();
			return _callLaterManager;
		}

		public function SpriteClipLifeCycle()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
		}

        private var _lifeCycleSignalsSet:LifeCycleSignalsSet = new LifeCycleSignalsSet();
        public function get lifeCycleSignalsSet():LifeCycleSignalsSet
        {
            return _lifeCycleSignalsSet;
        }

        private var drawUid:String;

        private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			init();

            drawUid = callLaterManager.add($draw);
		}

		public function dispose():void
		{
            if (disposed) return;
            disposed = true;

            if (updateUid) callLaterManager.remove(updateUid);
            if (drawUid) callLaterManager.remove(drawUid);

			cleanUp();

            if (lifeCycleSignalsSet.disposed.numListeners > 0)
                lifeCycleSignalsSet.disposed.dispatch();

            lifeCycleSignalsSet.dispose();
		}

		protected var _invalidProperties : Dictionary = new Dictionary();
		private var updateUid:String;

		public function invalidate(property:String = null):void
		{
			if (!_invalidProperties) _invalidProperties = new Dictionary();
			if (!property) property = ALL_PROPERTIES;
			_invalidProperties[property] = 1;

			callLaterManager.add($update, [], CallLaterManager.CLEAR_ALL_PREV_ACTION);
		}

		public function isInvalid(property:String = null):Boolean
		{
			if (!_invalidProperties) return false;
            if (property == null) return ObjectUtils.getNumProperties(property) > 0;
			if (_invalidProperties[ALL_PROPERTIES]) return true;
			return _invalidProperties[property];
		}

		public function validateNow():void
		{
			if (updateUid) callLaterManager.remove(updateUid);
			$update();
		}

		protected function init():void
		{

		}

        private function $draw():void
        {
            draw();

            if (lifeCycleSignalsSet.created.numListeners > 0)
                lifeCycleSignalsSet.created.dispatch();
        }

		protected function draw():void
		{

		}

		private function $update():void
		{
			update();
			_invalidProperties = new Dictionary();

            if (lifeCycleSignalsSet.validated.numListeners > 0)
                lifeCycleSignalsSet.validated.dispatch();
		}

		protected function update():void
		{

		}

		protected function cleanUp():void
		{

		}

		public function get $width():Number
		{
			return super.width;
		}

		public function get $height():Number
		{
			return super.width;
		}
    }
}