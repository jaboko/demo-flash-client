/**
 * Created by jaboko on 25.09.14.
 */
package ru.ganzin.demo.service.auth
{
    import mx.rpc.http.AbstractOperation;
    import mx.rpc.http.SerializationFilter;
    import mx.utils.URLUtil;

    import ru.ganzin.robotlegs.server.api.IPacket;

    public class PacketSerializationFilter extends SerializationFilter
    {
        private var _serverService:AuthHTTPServerService;
        private var currentPacket:IPacket;

        public function PacketSerializationFilter(serverService:AuthHTTPServerService)
        {
            _serverService = serverService;
        }

        override public function serializeURL(operation:AbstractOperation, obj:Object, url:String):String
        {
            return URLUtil.getFullURL(operation.rootURL, IPacket(obj).action);
        }

        override public function serializeBody(operation:AbstractOperation, obj:Object):Object
        {
            currentPacket = obj as IPacket;
            return IPacket(obj).getData();
        }

        override public function deserializeResult(operation:AbstractOperation, result:Object):Object
        {
            return _serverService.$parseResponseData(currentPacket, JSON.parse(String(result)));
        }
    }
}