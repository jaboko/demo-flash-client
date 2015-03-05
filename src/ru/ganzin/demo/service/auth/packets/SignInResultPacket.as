/**
 * Created by jaboko on 25.09.14.
 */
package ru.ganzin.demo.service.auth.packets
{
    import ru.ganzin.demo.model.vo.ProfileData;

    public class SignInResultPacket extends BaseResultPacket
    {
        public function SignInResultPacket()
        {
            super("auth/login");
            mapKey("profile", ProfileData);
        }

        public function get profile():ProfileData
        {
            return getValue("profile");
        }

    }
}
