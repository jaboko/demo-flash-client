package ru.ganzin.robotlegs.server.packets
{
    import flash.utils.Dictionary;

    import ru.ganzin.apron2.data.IDataContainer;
    import ru.ganzin.apron2.data.MappedDataContainer;
    import ru.ganzin.apron2.utils.ObjectUtil;
    import ru.ganzin.robotlegs.server.api.IPacket;

    public class Packet extends MappedDataContainer implements IPacket
	{
        private var _action:String;

		//-------------------------------------------------
		//	Constructor
		//-------------------------------------------------

		public function Packet(action:String = null, subscriber:String = null)
		{
            _action = action;
            if (subscriber) put("subscriber", subscriber);
		}

		//-------------------------------------------------
		//	Properties
		//-------------------------------------------------

		public function get action():String
		{
			return _action;
		}

		public function get subscriber():String
		{
			return getValue("subscriber");
		}

		public function set subscriber(value:String):void
		{
			return put("subscriber", value);
		}

		public function get groupSubscriber():String
		{
			return getValue("groupSubscriber") || getValue("group-subscriber");
		}

		public function set groupSubscriber(value:String):void
		{
			return put("groupSubscriber", value);
		}

        public function makeCommand(...params):String
        {
            return params.join("/");
        }

		override public function getData():*
		{
			return $getData(super.getData());
		}

		private function $getData(data:*):*
		{
			if (ObjectUtil.isPrimitiveType(data) || data is Array) return data;

			if (data is IDataContainer) data = IDataContainer(data).getData();

			var retData:Dictionary = new Dictionary();
            var list:Array;
            var o:Object;
			for (var key:String in data)
				if (data[key] is IDataContainer)
				{
					retData[key] = $getData(IDataContainer(data[key]).getData());
				}
				else if (data[key] is Array)
				{
					list = [];
					for each (o in data[key])
						list.push($getData(o));

					retData[key] = list;
				}
				else if (!ObjectUtil.isPrimitiveType(data[key]))
				{
					o = {};
					for (var field:String in data[key])
						o[field] = $getData(data[key][field]);

					retData[key] = o;
				}
				else retData[key] = data[key];

			return retData;
		}
	}
}
