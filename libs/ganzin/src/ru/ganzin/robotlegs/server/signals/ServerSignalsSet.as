/**
 * Created by IntelliJ IDEA.
 * User: Dimka-Lenovo
 * Date: 02.03.12
 * Time: 15:28
 */
package ru.ganzin.robotlegs.server.signals
{
    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;

    import ru.ganzin.robotlegs.server.api.IPacket;

    /**
     * Сет сигналов для класса ServerService
     *
     * @see com.gexsoft.snatch.core.service.ServerService
     */
	public class ServerSignalsSet
	{
		private var _groupUnlocked:ISignal = new Signal(String);

        /**
         * Сигнал вызываемый при разлочке группы
         * Аргументы слушателя: String
         */
		public function get groupUnlocked():ISignal
		{
			return _groupUnlocked;
		}

		private var _beforePacketSend:ISignal = new Signal(IPacket);

        /**
         * Сигнал вызываемый перед отправкой пакета
         * Аргументы слушателя: IPacket
         */
		public function get beforePacketSend():ISignal
		{
			return _beforePacketSend;
		}

		private var _afterPacketSend:ISignal = new Signal(IPacket);

        /**
         * Сигнал вызываемый после отправки пакета
         * Аргументы слушателя: IPacket
         */
		public function get afterPacketSend():ISignal
		{
			return _afterPacketSend;
		}

		private var _beforeResponseDataParsing:ISignal = new Signal(Object);

        /**
         * Сигнал вызываемый перед парсингом данных полученных от сервера
         * Аргументы слушателя: Object
         */
		public function get beforeResponseDataParsing():ISignal
		{
			return _beforeResponseDataParsing;
		}

		private var _afterResponsePacket:ISignal = new Signal(IPacket);

        /**
         * Сигнал вызываемый после получения пакета от сервера
         * Аргументы слушателя: IPacket
         */
		public function get afterResponsePacket():ISignal
		{
			return _afterResponsePacket;
		}

		private var _responseLockedPacket:ISignal = new Signal(IPacket);

        /**
         * Сигнал вызываемый после получения пакета который в ходит в список заблокированных
         * Аргументы слушателя: IPacket
         */
		public function get responseLockedPacket():ISignal
		{
			return _responseLockedPacket;
		}
	}
}
