/**
 * Created by IntelliJ IDEA.
 * User: Dimka-Lenovo
 * Date: 07.02.12
 * Time: 15:39
 */
package ru.ganzin.utils.flags
{
    import flash.utils.Dictionary;

    public class FlagsUtil
    {
        private static var flags:Dictionary = new Dictionary();

        public static function getNextFlag(uid:String = "default"):uint
        {
            if (!(uid in flags)) flags[uid] = 0;
            var value:uint = flags[uid];
            return Math.pow(2, flags[uid] = ++value);
        }

        public static function hasFlag(value:uint, flag:uint):Boolean
        {
            return ((value & flag) == flag);
        }
    }
}
