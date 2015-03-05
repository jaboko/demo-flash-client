/**
 * User: Dmitriy Ganzin
 */
package ru.ganzin.apron2.data
{
    import ru.ganzin.apron2.math.Array2D;

    public class Array2DConverter implements IDataConverter
    {
        private var valueConverter:*;
        private var mapHelper:MappedDataContainer;

        public function Array2DConverter(valueConverter:* = null)
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
            if (data is Array)
            {
                var arr:Array = data;
                var rows:int = 0
                var cols:int = Math.max(arr.length);

                for (var i:int = 0; i < data.length; i++)
                        rows = Math.max(rows, data[i].length);

                var o:*;
                var arr2D:Array2D = new Array2D(rows, cols, function (x:int, y:int):*
                {
                    o = arr[y][x];
                    if (mapHelper)
                    {
                        mapHelper.put("value", o);
                        o = mapHelper.getValue("value");
                    }

                    return o;
                });

                return arr2D;
            }

            return null;
        }
    }
}