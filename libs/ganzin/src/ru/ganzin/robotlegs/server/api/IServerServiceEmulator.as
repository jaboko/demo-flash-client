/**
 * Created by IntelliJ IDEA.
 * User: Dimka-Lenovo
 * Date: 08.03.12
 * Time: 18:38
 */
package ru.ganzin.robotlegs.server.api
{
    public interface IServerServiceEmulator
	{
		function emulateReceivePacket(packet:IPacket):void;
	}
}
