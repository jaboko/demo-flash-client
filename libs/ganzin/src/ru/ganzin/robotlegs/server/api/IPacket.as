package ru.ganzin.robotlegs.server.api
{
    import ru.ganzin.apron2.data.IDataContainer;

    /**
     * Пакет для данных сервера
     */
	public interface IPacket extends IDataContainer
	{
        /**
         * Название комманды
         */
		function get action():String;

        /**
         * Название подписчика
         */
		function get subscriber():String;
		function set subscriber(value:String):void;

        /**
         * Название группы подписчика
         */
		function get groupSubscriber():String;
		function set groupSubscriber(value:String):void;
	}
}
