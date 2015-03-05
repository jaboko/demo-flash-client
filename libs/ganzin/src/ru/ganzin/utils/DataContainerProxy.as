/**
 * User: Dmitriy Ganzin
 * Date: 12.10.10
 * Time: 15:21
 */
package ru.ganzin.utils
{
    import flash.events.IEventDispatcher;

    import ru.ganzin.apron2.SimpleClass;
    import ru.ganzin.apron2.data.IDataContainer;
    import ru.ganzin.apron2.events.PropertyChangeEvent;

    public class DataContainerProxy extends SimpleClass implements IDataContainer
	{
		protected var data:IDataContainer;

		private var callLaterManager:CallLaterManager = new CallLaterManager();

		public function DataContainerProxy(data:IDataContainer)
		{
			this.data = data;
			IEventDispatcher(data).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, propertyChangeHandler, false, 0, true);
			$dataChanged();
		}

		public function setData(value:*):void
		{
			data.setData(value);
		}

		public function getData():*
		{
			return data.getData();
		}

		private function propertyChangeHandler(event:PropertyChangeEvent = null):void
		{
			callLaterManager.add($dataChanged, [], CallLaterManager.CLEAR_ALL_PREV_ACTION);
		}

		private function $dataChanged():void
		{
			dataChanged();
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
		}

		protected function dataChanged():void
		{

		}
	}
}
