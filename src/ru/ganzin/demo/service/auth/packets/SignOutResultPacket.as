/**
 * Created by jaboko on 25.09.14.
 */
package ru.ganzin.demo.service.auth.packets
{
    public class SignOutResultPacket extends BaseResultPacket
    {
        public function SignOutResultPacket()
        {
            super("auth/logout");
        }
    }
}
