/**
 * User: Dmitriy Ganzin
 * Date: 11.02.11
 * Time: 16:47
 */
package ru.ganzin.utils
{
    import flash.display.DisplayObject;

    import org.as3commons.lang.ClassUtils;

    public class VisibilityUtils
	{
		public static function isDisplayObjectVisible(obj:DisplayObject):Boolean
		{
			if (!obj.visible) return false;
			return checkDisplayObjectVisible(obj);
		}

		private static function checkDisplayObjectVisible(obj:DisplayObject):Boolean
		{
			if (obj.parent && !obj.parent.visible) return false;
			if (obj.parent != null && !isApplication(obj.parent))
				return checkDisplayObjectVisible(obj.parent);
			else
				return true;
		}

		private static function isApplication(value:DisplayObject):Boolean
		{
            var fullyQualifiedName:String = ClassUtils.getFullyQualifiedName(ClassUtils.forInstance(value), true);
            return fullyQualifiedName == "spark.components.Application" || fullyQualifiedName == "mx.core.Application";
		}
	}
}
