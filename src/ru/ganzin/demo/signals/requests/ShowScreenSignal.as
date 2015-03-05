/**
 * Created by Dmitriy Ganzin on 04.03.15.
 */
package ru.ganzin.demo.signals.requests
{
    import org.osflash.signals.Signal;

    public class ShowScreenSignal extends Signal
    {
        public function ShowScreenSignal()
        {
            super(String);
        }
    }
}
