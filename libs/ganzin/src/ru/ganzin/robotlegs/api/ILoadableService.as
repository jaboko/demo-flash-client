package ru.ganzin.robotlegs.api
{
	import org.osflash.signals.Signal;

    /**
     * Сервис который может что-то загружать. Имеет согналы complete, error, progress.
     */

	public interface ILoadableService
	{
        /**
         * Сигнал вызываемый после завершения загрузки.
         */

		function get complete():Signal;

        /**
         * Сигнал вызываемый при ошибки в загрузке.
         */

		function get error():Signal;

        /**
         * Сигнал вызываемый при прогрессе загрузки.
         */

		function get progress():Signal;

        /**
         * Начать загрузку
         */

		function load():void;
	}
}