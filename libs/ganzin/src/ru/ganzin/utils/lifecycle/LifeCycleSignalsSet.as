/**
 * Created by IntelliJ IDEA.
 * User: Dimka-Lenovo
 * Date: 20.02.12
 * Time: 15:54
 */
package ru.ganzin.utils.lifecycle
{
    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;

    import ru.ganzin.apron2.interfaces.IDisposable;

    public class LifeCycleSignalsSet implements IDisposable
    {
        private var _created:ISignal = new Signal();
        private var _disposed:ISignal = new Signal();
        private var _validated:ISignal = new Signal();

        public function get created():ISignal
        {
            return _created;
        }

        public function get disposed():ISignal
        {
            return _disposed;
        }

        public function get validated():ISignal
        {
            return _validated;
        }

        public function dispose():void
        {
            created.removeAll();
            disposed.removeAll();
            validated.removeAll();
        }
    }
}
