/**
 * Created by Dmitriy Ganzin on 03.03.15.
 */
package ru.ganzin.demo.service.auth.packets
{
    import ru.ganzin.robotlegs.server.packets.Packet;

    public class GetProfilePacket extends Packet
    {
        public function GetProfilePacket()
        {
            super("auth/profile");
        }
    }
}
