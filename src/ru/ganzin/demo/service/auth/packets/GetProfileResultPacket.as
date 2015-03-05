/**
 * Created by jaboko on 25.09.14.
 */
package ru.ganzin.demo.service.auth.packets
{
    import ru.ganzin.demo.model.vo.ProfileData;

    public class GetProfileResultPacket extends BaseResultPacket
    {
        public function GetProfileResultPacket()
        {
            super("auth/profile");
            mapKey("profile", ProfileData);
        }

        public function get profile():ProfileData
        {
            return getValue("profile");
        }

    }
}
