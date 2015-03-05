/**
 * Created by Dmitriy Ganzin on 03.03.15.
 */
package ru.ganzin.demo.service.auth.packets
{
    import ru.ganzin.robotlegs.server.packets.Packet;

    public class SignInPacket extends Packet
    {
        public function SignInPacket(username:String, password:String)
        {
            super("auth/login");

            put("username", username);
            put("password", password);
        }
    }
}
