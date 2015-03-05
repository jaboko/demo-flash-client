package ru.ganzin.demo.service.auth
{
    import mx.rpc.AsyncToken;
    import mx.rpc.Responder;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.http.HTTPService;

    import robotlegs.bender.extensions.contextView.ContextView;

    import ru.ganzin.apron2.utils.ApplicationUtil;
    import ru.ganzin.robotlegs.server.ServerService;
    import ru.ganzin.robotlegs.server.api.IPacket;

    public class AuthHTTPServerService extends ServerService
    {
        [Inject]
        public var contextView:ContextView;

        /******************************************************/
        /* Implemented methods */
        /******************************************************/

        override protected function sendPacketToServer(packet:IPacket):void
        {
            var serverUrl:String = "http://localhost:3000/api/";
            try
            {
                var flashVars:Object = contextView.view.stage.loaderInfo.parameters;
                serverUrl = flashVars["server"];
            }
            catch(e:Error)
            {
                logger.warn(e);
            }

            logger.info("Server url [{0}]", [serverUrl]);

            var client:HTTPService = new HTTPService(serverUrl);
            client.method = "POST";
            client.serializationFilter = new PacketSerializationFilter(this);

            var token:AsyncToken = client.send(packet);
            token.addResponder(new Responder(asyncTokenResult, asyncTokenFault));
        }

        /******************************************************/
        /* Private methods */
        /******************************************************/

        private function asyncTokenResult(event:ResultEvent):void
        {
            responseHandler(event.result);
        }

        private function asyncTokenFault(event:FaultEvent):void
        {
            logger.warn(event.toString());
        }

        internal function $parseResponseData(requestPacket:IPacket, data:*):IPacket
        {
            var packet:IPacket = parseResponseData(requestPacket.action, data);
            packet.subscriber = requestPacket.subscriber;
            return packet;
        }

        override protected function parseResponseData(action:String, data:*):IPacket
        {
            if (data)
            {
                var packetClass:Class = responcePacketsMap[action];
                if (packetClass)
                {
                    var packet:IPacket = (new packetClass()) as IPacket;
                    packet.setData(data);
                    return packet;
                }
                else
                {
                    logger.warn("Класс для пакета({0}) не найден.", [action]);
                }
            }
            else
            {
                logger.warn("В пакете нет данных.");
            }

            return null;
        }
    }
}
