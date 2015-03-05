/**
 * Created by IntelliJ IDEA.
 * User: Dimka-Lenovo
 * Date: 06.10.12
 * Time: 18:05
 */
package ru.ganzin.utils
{
    import org.as3commons.collections.Map;
    import org.as3commons.collections.framework.IMap;

    import ru.ganzin.apron2.data.IDataConverter;
    import ru.ganzin.apron2.data.MappedDataContainer;

    public class MapConverter implements IDataConverter
    {
        private var valueConverter:*;
        private var mapHelper:MappedDataContainer;

        public function MapConverter(valueConverter:* = null)
        {
            this.valueConverter = valueConverter;

            if (valueConverter)
            {
                mapHelper = new MappedDataContainer();
                mapHelper.mapKey("value", valueConverter);
            }
        }

        public function convert(data:*):*
        {
            if (data)
            {
                var ret:IMap = new Map();

                for (var key:* in data)
                    {
                        var value:* = data[key];

                        if (mapHelper)
                        {
                            mapHelper.put("value", value);
                            value = mapHelper.getValue("value");
                        }

                        ret.add(key, value);
                    }

                return ret;
            }

            return null;
        }
    }
}
