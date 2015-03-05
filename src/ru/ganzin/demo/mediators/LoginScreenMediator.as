/**
 * Created by Dmitriy Ganzin on 04.03.15.
 */
package ru.ganzin.demo.mediators
{
    import ru.ganzin.demo.Constants;
    import ru.ganzin.demo.mediators.base.BaseMediator;
    import ru.ganzin.demo.model.AuthModel;
    import ru.ganzin.demo.model.vo.AuthData;
    import ru.ganzin.demo.signals.requests.SignInRequestSignal;
    import ru.ganzin.demo.signals.requests.SignUpRequestSignal;
    import ru.ganzin.demo.view.screens.LoginScreen;

    import starling.events.Event;

    public class LoginScreenMediator extends BaseMediator
    {
        [Inject]
        public var view:LoginScreen;

        [Inject]
        public var authModel:AuthModel;

        [Inject]
        public var signInRequestSignal:SignInRequestSignal;

        [Inject]
        public var signUpRequestSignal:SignUpRequestSignal;

        override public function initialize():void
        {
            super.initialize();

            if (authModel.state == Constants.auth.LOGIN_ERROR_STATE ||
                authModel.state == Constants.auth.REGISTRATION_ERROR_STATE)
            {
                view.showError(authModel.lastError);
            }

            view.signInButton.addEventListener(Event.TRIGGERED, signInButton_triggeredHandler);
            view.signUpButton.addEventListener(Event.TRIGGERED, signUpButton_triggeredHandler);
        }

        private function signInButton_triggeredHandler(event:Event):void
        {
            if (view.validateData())
                signInRequestSignal.dispatch(new AuthData(view.usernameTextInput.text, view.passwordTextInput.text));
        }

        private function signUpButton_triggeredHandler(event:Event):void
        {
            if (view.validateData())
                signUpRequestSignal.dispatch(new AuthData(view.usernameTextInput.text, view.passwordTextInput.text));
        }
    }
}
