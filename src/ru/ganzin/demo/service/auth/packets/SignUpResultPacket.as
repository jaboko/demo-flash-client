/**
 * Created by jaboko on 25.09.14.
 */
package ru.ganzin.demo.service.auth.packets
{
    import ru.ganzin.demo.model.vo.ProfileData;

    public class SignUpResultPacket extends BaseResultPacket
    {
        public function SignUpResultPacket()
        {
            super("auth/create");
            mapKey("profile", ProfileData);
        }

        public function get profile():ProfileData
        {
            return getValue("profile");
        }
    }
}
