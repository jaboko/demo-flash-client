/**
 * Created by Dmitriy Ganzin on 04.03.15.
 */
package ru.ganzin.demo.mediators
{
    import ru.ganzin.demo.mediators.base.BaseMediator;
    import ru.ganzin.demo.model.AuthModel;
    import ru.ganzin.demo.signals.requests.SignInRequestSignal;
    import ru.ganzin.demo.signals.requests.SignOutRequestSignal;
    import ru.ganzin.demo.view.screens.ProfileScreen;

    import starling.events.Event;

    public class ProfileScreenMediator extends BaseMediator
    {
        [Inject]
        public var view:ProfileScreen;

        [Inject]
        public var authModel:AuthModel;

        [Inject]
        public var signOutRequestSignal:SignOutRequestSignal;

        override public function initialize():void
        {
            super.initialize();

            view.usernameTextField.text = authModel.profile.username;
            view.signOutButton.addEventListener(Event.TRIGGERED, signOutButton_triggeredHandler);
        }

        private function signOutButton_triggeredHandler(event:Event):void
        {
            signOutRequestSignal.dispatch();
        }
    }
}
