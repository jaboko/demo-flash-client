/**
 * User: Dmitriy Ganzin
 * Date: 16.11.10
 * Time: 19:02
 */
package ru.ganzin.robotlegs.server.packets
{
    public class ResultPacket extends Packet
	{
		public function ResultPacket(action:String)
		{
			super(action);
		}

		public function get status():int
		{
			return getValue("status");
		}
	}
}
