/**
 * User: Dmitriy Ganzin
 * Date: 30.03.11
 * Time: 12:14
 */
package ru.ganzin.utils
{
    import flash.filters.BitmapFilter;

    import ru.ganzin.apron2.utils.ObjectUtil;

    public class FiltersUtils
    {
        public static function addFilter(sprite:*, filter:*, dublicate:Boolean = false):void
        {
            if (!(sprite["filters"] && sprite["filters"] is Array)) return;

            var filters:Array = sprite.filters.concat();
            var i:uint = filters.length;
            while (i--)
                if (filter == filters[i] || (filter is Class && filters[i] is filter) || (filter is BitmapFilter && equalFilter(filters[i], filter)))
                    if (!dublicate) return;

            filters.push(filter);
            sprite.filters = filters;
        }

        public static function removeFilter(sprite:*, filter:*, removeAll:Boolean = false):void
        {
            if (!(sprite["filters"] && sprite["filters"] is Array)) return;

            var filters:Array = sprite.filters;
            var i:uint = filters.length; //default (in case it was removed)
            while (i--)
                if (filter == filters[i] || (filter is Class && filters[i] is filter) || (filter is BitmapFilter && equalFilter(filters[i], filter)))
                {
                    filters.splice(i, 1);
                    if (!removeAll) break;
                }

            if (filters.length > 0) sprite.filters = filters.concat();
            else sprite.filters = [];
        }

        public static function equalFilter(filterA:BitmapFilter, filterB:BitmapFilter):Boolean
        {
            return ObjectUtil.equals(filterA, filterB);
        }
    }
}
