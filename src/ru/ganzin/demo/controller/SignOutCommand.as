/**
 * Created by Dmitriy Ganzin on 04.03.15.
 */
package ru.ganzin.demo.controller
{
    import robotlegs.bender.bundles.mvcs.Command;

    import ru.ganzin.demo.Constants;
    import ru.ganzin.demo.model.AuthModel;
    import ru.ganzin.demo.model.vo.AuthData;
    import ru.ganzin.demo.service.auth.packets.SignOutPacket;
    import ru.ganzin.demo.service.auth.packets.SignOutResultPacket;
    import ru.ganzin.demo.signals.requests.ShowScreenSignal;
    import ru.ganzin.robotlegs.server.api.IServerService;

    public class SignOutCommand extends Command
    {
        [Inject]
        public var authService:IServerService;

        [Inject]
        public var authModel:AuthModel;

        [Inject]
        public var showScreenSignal:ShowScreenSignal;

        override public function execute():void
        {
            showScreenSignal.dispatch(Constants.screens.BUSY);

            authService.sendPacket(new SignOutPacket())
                    .addOnce(resultPacketHandler);
        }

        private function resultPacketHandler(result:SignOutResultPacket):void
        {
            if (result.status == 1) {
                authModel.profile = null;
                authModel.state = Constants.auth.IS_NOT_LOGINNED_STATE;
            }
        }
    }
}
