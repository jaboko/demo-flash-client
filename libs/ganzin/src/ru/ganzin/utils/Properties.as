package ru.ganzin.utils
{
    import org.as3commons.collections.LinkedMap;

    import ru.ganzin.apron2.utils.StringUtil;

    /**
	 * @version 1.0
	 *
	 * Container for properties with replaceable numerical tokens - {1}, {2}, {3},... {n}
	 */

	public class Properties extends LinkedMap
	{
		/**
		 * Get a property String
		 * @param    name    Name of the property to retrive
		 * @param    ...args    Replace any tokens {n} with these values
		 * @return
		 */
		public function getProperty(name:String, ...args):String
		{
			var value:* = itemFor(name);
			if (value != null && (value == "" || value.length == 0)) value = null;
			else value = StringUtil.substitute(value,  args);
			return value;
		}

		public function setProperty(name:String, value:String):void
		{
			if (hasKey(name)) replaceFor(name,  value);
			else add(name,  value);
		}

		public function removeProperty(name:String):void
		{
			removeKey(name);
		}

		private function getPropertyIndex(name:String):int
		{
			return keysToArray().indexOf(name);
		}
	}
}