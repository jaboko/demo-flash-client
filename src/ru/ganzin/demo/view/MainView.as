/**
 * Created by jaboko on 27.02.15.
 */
package ru.ganzin.demo.view
{
    import feathers.controls.StackScreenNavigator;
    import feathers.controls.StackScreenNavigatorItem;
    import feathers.motion.Slide;

    import ru.ganzin.demo.Constants;

    import ru.ganzin.demo.view.base.Theme;
    import ru.ganzin.demo.view.screens.BusyScreen;
    import ru.ganzin.demo.view.screens.LoginScreen;
    import ru.ganzin.demo.view.screens.ProfileScreen;

    import starling.events.Event;

    public class MainView extends StackScreenNavigator
    {
        public function MainView()
        {
            super();
        }

        override protected function initialize():void
        {
            super.initialize();

            new Theme();

            this.width = this.stage.stageWidth;
            this.height = this.stage.stageHeight;

            var busyScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(BusyScreen);
            this.addScreen(Constants.screens.BUSY, busyScreenItem);

            var signInScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(LoginScreen);
            signInScreenItem.setScreenIDForPushEvent(Event.COMPLETE, Constants.screens.PROFILE);
            this.addScreen(Constants.screens.SIGN_IN, signInScreenItem);

            var profileScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem(ProfileScreen);
            this.addScreen(Constants.screens.PROFILE, profileScreenItem);

            this.pushTransition = Slide.createSlideLeftTransition();
            this.popTransition = Slide.createSlideRightTransition();
        }
    }
}
