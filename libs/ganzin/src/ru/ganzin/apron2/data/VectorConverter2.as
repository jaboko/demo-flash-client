/**
 * Created by jaboko on 17.09.14.
 */
package ru.ganzin.apron2.data
{
    public class VectorConverter2 implements IDataConverter
    {
        private var _vectorClass:Class;
        private var mapHelper:MappedDataContainer;

        public function VectorConverter2(vectorClass:*, valueConverter:* = null)
        {
            _vectorClass = vectorClass;

            if (valueConverter)
            {
                mapHelper = new MappedDataContainer();
                mapHelper.mapKey("value", valueConverter);
            }
        }

        public function convert(data:*):*
        {
            var vector:* = new _vectorClass();

            for each (var o:* in data)
            {
                if (mapHelper)
                {
                    mapHelper.put("value", o);
                    o = mapHelper.getValue("value");
                }

                vector.push(o);
            }

            return vector;
        }
    }
}
