package ru.ganzin.robotlegs
{
    import ru.ganzin.utils.CallLaterManager;

    /**
     * Базовый класс для создания сервисов.
     */
    public class Service extends Actor
    {
        /**
         * Менеджер отложенных вызовов.
         *
         * @see ru.ganzin.utils.CallLaterManager
         */
        private var _callLaterManager:CallLaterManager;
        protected function get callLaterManager():CallLaterManager
        {
            if (!_callLaterManager) _callLaterManager = new CallLaterManager();
            return _callLaterManager;
        }
    }
}
