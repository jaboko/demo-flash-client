package ru.ganzin.robotlegs.server.events
{
    import flash.events.Event;

    public class ServerServiceEvent extends Event
    {
        public static const REGISTER_RESPONSE_PACKET:String = "registerResponsePacket";
        public static const UNREGISTER_RESPONSE_PACKET:String = "unregisterResponsePacket";

        public var packetClass:Class;

        public function ServerServiceEvent(type:String, packetClass:Class)
        {
            super(type);
            this.packetClass = packetClass;
        }
    }
}
