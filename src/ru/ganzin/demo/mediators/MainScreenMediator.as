/**
 * Created by Dmitriy Ganzin on 04.03.15.
 */
package ru.ganzin.demo.mediators
{
    import org.as3commons.reflect.Constant;

    import ru.ganzin.demo.Constants;
    import ru.ganzin.demo.mediators.base.BaseMediator;
    import ru.ganzin.demo.model.AuthModel;
    import ru.ganzin.demo.signals.requests.ShowScreenSignal;
    import ru.ganzin.demo.view.MainView;

    public class MainScreenMediator extends BaseMediator
    {
        [Inject]
        public var view:MainView;

        [Inject]
        public var authModel:AuthModel;

        [Inject]
        public var showScreenSignal:ShowScreenSignal;

        override public function initialize():void
        {
            super.initialize();

            showScreenSignal.add(showScreenSignalHandler);
            signalsSupport.add(authModel.stateChanged, authStateChangeHandler);
        }

        private function showScreenSignalHandler(screenId:String):void
        {
            view.pushScreen(screenId);
        }

        private function authStateChangeHandler(state:int):void
        {
            if (state == Constants.auth.LOGINNED_STATE)
                view.pushScreen(Constants.screens.PROFILE);
            else if (state == Constants.auth.IS_NOT_LOGINNED_STATE || state == Constants.auth.LOGIN_ERROR_STATE
             || state == Constants.auth.REGISTRATION_ERROR_STATE)
                view.pushScreen(Constants.screens.SIGN_IN);
            else
                view.pushScreen(Constants.screens.BUSY);
        }
    }
}
