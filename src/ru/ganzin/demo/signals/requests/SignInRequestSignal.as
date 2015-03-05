/**
 * Created by Dmitriy Ganzin on 04.03.15.
 */
package ru.ganzin.demo.signals.requests
{
    import org.osflash.signals.Signal;

    import ru.ganzin.demo.model.vo.AuthData;

    public class SignInRequestSignal extends Signal
    {
        public function SignInRequestSignal()
        {
            super(AuthData);
        }
    }
}
