/**
 * User: Dmitriy Ganzin
 * Date: 07.06.11
 * Time: 18:25
 */
package ru.ganzin.utils.lifecycle
{
    import flash.utils.Dictionary;

    import org.as3commons.lang.ObjectUtils;

    import ru.ganzin.apron2.SimpleClass;
    import ru.ganzin.apron2.interfaces.IDisposable;
    import ru.ganzin.utils.CallLaterManager;

    public class BaseClassLifeCycle extends SimpleClass implements IDisposable
	{
		public static const ALL_PROPERTIES:String = "Invalidation_ALL_PROPERTIES";

		private static var _callLaterManager:CallLaterManager;
		protected function get callLaterManager():CallLaterManager
		{
			if (!_callLaterManager) _callLaterManager = new CallLaterManager();
			return _callLaterManager;
		}

		public function BaseClassLifeCycle()
		{
			callLaterManager.add(init);
			callLaterManager.add(draw, [], 0, 1);
		}


		override public function dispose():void
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
	}
}