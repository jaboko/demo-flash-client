/**
 * Created by IntelliJ IDEA.
 * User: Dimka-Lenovo
 * Date: 09.03.12
 * Time: 13:22
 */
package ru.ganzin.robotlegs.server.error
{
    public class PacketProcessingError extends Error
    {
        public static const CANCEL_SENDING:String = "cancelSending";

        private var _type:String;

        public function PacketProcessingError(type:String)
        {
            _type = type;
        }

        public function get type():String
        {
            return _type;
        }
    }
}
