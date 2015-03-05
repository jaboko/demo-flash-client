/**
 * Created by jaboko on 17.09.14.
 */
package ru.ganzin.apron2.data
{
    import org.as3commons.lang.Enum;

    public class EnumDataConverter implements IDataConverter
    {
        private var _clazz:Class;

        public function EnumDataConverter(clazz:Class)
        {
            _clazz = clazz;
        }

        public function convert(data:*):*
        {
            return Enum.getEnum(_clazz, String(data));
        }
    }
}
