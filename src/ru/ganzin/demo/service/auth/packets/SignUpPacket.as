/**
 * Created by Dmitriy Ganzin on 03.03.15.
 */
package ru.ganzin.demo.service.auth.packets
{
    import ru.ganzin.robotlegs.server.packets.Packet;

    public class SignUpPacket extends Packet
    {
        public function SignUpPacket(username:String, password:String)
        {
            super("auth/create");

            put("username", username);
            put("password", password);
        }
    }
}
