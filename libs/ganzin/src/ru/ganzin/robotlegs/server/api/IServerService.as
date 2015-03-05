package ru.ganzin.robotlegs.server.api
{
    import org.osflash.signals.ISignal;

    import ru.ganzin.robotlegs.server.signals.ServerSignalsSet;

    public interface IServerService
	{
        /**
         * Зарегистрировать класс пакета обработки данных сервера
         *
         * @param clazz Класс пакета должен наследоваться от IPacket
         */
		function registerResultPacket(clazz:Class):void;

        /**
         * Удалить регистрацию класса пакета
         *
         * @param clazz Класс пакета должен наследоваться от IPacket
         */
		function unregisterResultPacket(clazz:Class):void;

        /**
         * Отправить пакет на сервер
         *
         * @param packet Отправляемый пакет
         *
         * @return Сигнал ответа
         */
		function sendPacket(packet:IPacket):ISignal;

        /**
         * Залочить группу сообщений по подписчику
         */
        function lockGroup(subscriber:String):void;

        /**
         * Разблокировать группу сообщений по подписчику
         */
        function unlockGroup(subscriber:String):void;

        /**
         * Залочина ли группа
         */
        function groupIsLocked(subscriber:String):Boolean;

        /**
         * Сигналы сервиса
         */
        function get signalsSet():ServerSignalsSet;
	}
}
