package ru.ganzin.reflect
{
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Type;

	public class TypeUtils
	{
		public function getMethodsWithMetadata(type:Type, name:String):MethodsList
		{
			var list:MethodsList = new MethodsList();
			for each (var method:Method in type.methods)
				if (method.hasMetadata(name)) list.items.push(method);
			return list;
		}
	}
}
