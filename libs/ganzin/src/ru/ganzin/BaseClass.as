/**
 * Created by jaboko on 27.09.14.
 */
package ru.ganzin
{
    import org.as3commons.lang.ClassUtils;

    import ru.ganzin.apron2.apron_internal;
    import ru.ganzin.apron2.events.EventDispatcher2;

    use namespace apron_internal;

    public class BaseClass extends EventDispatcher2
    {
        private var _cachedClassName:String;

        public function getClassName():String
        {
            if (_cachedClassName) return _cachedClassName;
            return _cachedClassName = ClassUtils.getName(getClass());
        }

        private var _cachedFullClassName:String;

        public function getFullyClassName():String
        {
            if (_cachedFullClassName) return _cachedFullClassName;
            return _cachedFullClassName = ClassUtils.getFullyQualifiedName(getClass(), true);
        }

        private var _cachedClass:Class;

        public function getClass():Class
        {
            if (_cachedClass) return _cachedClass;
            return _cachedClass = ClassUtils.forInstance(this);
        }
    }
}
