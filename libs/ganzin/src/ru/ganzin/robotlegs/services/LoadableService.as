/**
 * Created by jaboko on 21.08.14.
 */
package ru.ganzin.robotlegs.services
{
    import org.osflash.signals.Signal;

    import ru.ganzin.robotlegs.*;
    import ru.ganzin.robotlegs.api.ILoadableService;

    public class LoadableService extends Service implements ILoadableService
    {
        private var _progress:Signal = new Signal(uint);
        private var _complete:Signal = new Signal();
        private var _error:Signal = new Signal(Error);

        public function get progress():Signal
        {
            return _progress;
        }

        public function get complete():Signal
        {
            return _complete;
        }

        public function get error():Signal
        {
            return _error;
        }

        public function load():void
        {
            complete.dispatch();
        }
    }
}
