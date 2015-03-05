/**
 * Created by Dmitriy Ganzin on 03.03.15.
 */
package ru.ganzin.demo.service.auth.packets
{
    import ru.ganzin.demo.model.vo.ErrorData;
    import ru.ganzin.robotlegs.server.packets.ResultPacket;

    public class BaseResultPacket extends ResultPacket
    {
        public function BaseResultPacket(action:String)
        {
            super(action);
            mapKey("error", ErrorData);
        }

        public function get error():ErrorData
        {
            return getValue("error");
        }
    }
}
