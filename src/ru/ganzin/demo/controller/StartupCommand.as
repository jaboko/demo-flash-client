/**
 * Created by Dmitriy Ganzin on 03.03.15.
 */
package ru.ganzin.demo.controller
{
    import robotlegs.bender.bundles.mvcs.Command;

    import ru.ganzin.demo.Constants;
    import ru.ganzin.demo.model.AuthModel;
    import ru.ganzin.demo.service.auth.packets.GetProfilePacket;
    import ru.ganzin.demo.service.auth.packets.GetProfileResultPacket;
    import ru.ganzin.demo.signals.requests.ShowScreenSignal;
    import ru.ganzin.robotlegs.server.api.IServerService;

    public class StartupCommand extends Command
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

            authService.sendPacket(new GetProfilePacket())
                    .addOnce(getProfilePacketHandler);
        }

        private function getProfilePacketHandler(result:GetProfileResultPacket):void
        {
            if (result.status == 1)
            {
                authModel.profile = result.profile;
                authModel.state = Constants.auth.LOGINNED_STATE;
            }
            else authModel.state = Constants.auth.IS_NOT_LOGINNED_STATE;
        }
    }
}
