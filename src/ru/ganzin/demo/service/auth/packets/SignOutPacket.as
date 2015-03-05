/**
 * Created by Dmitriy Ganzin on 03.03.15.
 */
package ru.ganzin.demo.service.auth.packets
{
    import ru.ganzin.robotlegs.server.packets.Packet;

    public class SignOutPacket extends Packet
    {
        public function SignOutPacket()
        {
            super("auth/logout");
        }
    }
}
