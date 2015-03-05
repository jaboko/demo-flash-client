/**
 * Created by IntelliJ IDEA.
 * User: Dimka-Lenovo
 * Date: 07.11.11
 * Time: 18:22
 */
package ru.ganzin.signal
{
    import flash.utils.Dictionary;

    import org.osflash.signals.ISignal;

    import ru.ganzin.apron2.SimpleClass;

    public class SignalsSupport extends SimpleClass
    {
        private var signalsHandlersMap:Dictionary = new Dictionary();

        public function add(signal:ISignal, handler:Function):void
        {
            signal.add(handler);
            toMap(signal, handler);
        }

        public function addOnce(signal:ISignal, handler:Function):void
        {
            signal.addOnce(handler);
            toMap(signal, handler);
        }

        public function remove(signal:ISignal, handler:Function):void
        {
            signal.remove(handler);
            fromMap(signal, handler);
        }

        public function removeAllBySignal(signal:ISignal):void
        {
            var list:Array = signalsHandlersMap[signal];
            if (!list) return;

            for each (var handler:* in list)
                signal.remove(handler);

            delete signalsHandlersMap[signal];
        }

        public function removeAll():void
        {
            for (var key:* in signalsHandlersMap)
                removeAllBySignal(key);
        }

        override public function dispose():void
        {
            for (var key:* in signalsHandlersMap)
                removeAllBySignal(key);

            signalsHandlersMap = null;

            super.dispose();
        }

        private function toMap(signal:ISignal, handler:Function):void
        {
            var list:Array = signalsHandlersMap[signal];
            if (!list) list = signalsHandlersMap[signal] = [];
            list.push(handler);
        }

        private function fromMap(signal:ISignal, handler:Function):void
        {
            var list:Array = signalsHandlersMap[signal];
            if (!list) return;

            var idx:int = list.indexOf(handler);
            if (idx != -1) list[idx] = null;
        }
    }
}
