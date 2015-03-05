/**
 * Created by Dmitriy Ganzin on 04.03.15.
 */
package ru.ganzin.demo.model
{
    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;

    import ru.ganzin.demo.model.vo.AuthData;

    import ru.ganzin.demo.model.vo.ErrorData;
    import ru.ganzin.demo.model.vo.ProfileData;

    public class AuthModel
    {
        public var lastError:ErrorData;

        public const stateChanged:ISignal = new Signal(int);
        private var _state:int = -1;
        public function get state():int
        {
            return _state;
        }
        public function set state(value:int):void
        {
            _state = value;
            stateChanged.dispatch(value);
        }

        private var _profile:ProfileData;
        public function get profile():ProfileData
        {
            return _profile;
        }

        public function set profile(value:ProfileData):void
        {
            _profile = value;
        }
    }
}
