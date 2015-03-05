/**
 * Created by Dmitriy Ganzin on 04.03.15.
 */
package ru.ganzin.demo.controller
{
    import robotlegs.bender.bundles.mvcs.Command;

    import ru.ganzin.demo.Constants;
    import ru.ganzin.demo.model.AuthModel;
    import ru.ganzin.demo.model.vo.AuthData;
    import ru.ganzin.demo.service.auth.packets.SignUpPacket;
    import ru.ganzin.demo.service.auth.packets.SignUpResultPacket;
    import ru.ganzin.demo.signals.requests.ShowScreenSignal;
    import ru.ganzin.robotlegs.server.api.IServerService;

    public class SignUpCommand extends Command
    {
        [Inject]
        public var authService:IServerService;

        [Inject]
        public var authModel:AuthModel;

        [Inject]
        public var showScreenSignal:ShowScreenSignal;

        [Inject]
        public var authData:AuthData;

        override public function execute():void
        {
            showScreenSignal.dispatch(Constants.screens.BUSY);

            authService.sendPacket(new SignUpPacket(authData.username, authData.password))
                    .addOnce(resultPacketHandler);
        }

        private function resultPacketHandler(result:SignUpResultPacket):void
        {
            if (result.status == 1)
            {
                authModel.profile = result.profile;
                authModel.state = Constants.auth.LOGINNED_STATE;
            }
            else
            {
                authModel.lastError = result.error;
                authModel.state = Constants.auth.REGISTRATION_ERROR_STATE;
            }
        }
    }
}
