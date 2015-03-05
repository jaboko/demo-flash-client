/**
 * User: Dmitriy Ganzin
 * Date: 07.06.11
 * Time: 18:25
 */
package ru.ganzin.utils.lifecycle
{
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.utils.Dictionary;

    import org.as3commons.lang.ObjectUtils;

    import ru.ganzin.utils.CallLaterManager;

    public class MovieClipLifeCycle extends MovieClip
	{
		public static const ALL_PROPERTIES:String = "Invalidation_ALL_PROPERTIES";

		private var _callLaterManager:CallLaterManager;
		protected function get callLaterManager():CallLaterManager
		{
			if (!_callLaterManager) _callLaterManager = new CallLaterManager();
			return _callLaterManager;
		}

		public function MovieClipLifeCycle()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
		}

		private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			init();

			callLaterManager.add(draw);
		}

		public function dispose():void
		{
			cleanUp();
		}

		protected var _invalidProperties : Dictionary = new Dictionary();

		public function invalidate(property:String = null):void
		{
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

		protected function init():void
		{

		}

		protected function draw():void
		{

		}

		private function $update():void
		{
			update();
			_invalidProperties = new Dictionary();
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