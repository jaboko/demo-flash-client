/**
 * Created by jaboko on 02.03.15.
 */
package ru.ganzin.demo.view.screens
{
    import feathers.controls.Button;
    import feathers.controls.Label;
    import feathers.controls.LayoutGroup;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.VerticalLayout;

    import ru.ganzin.demo.view.base.ScreenBase;

    public class ProfileScreen extends ScreenBase
    {
        public var usernameTextField:Label = new Label();
        public var signOutButton:Button = new Button();

        override protected function initialize():void
        {
            super.initialize();

            var layout:VerticalLayout = new VerticalLayout();
            layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
            layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
            layout.gap = 10;
            this.layout = layout;

            var g1:LayoutGroup = new LayoutGroup();
            var gl1:HorizontalLayout = new HorizontalLayout();
            gl1.gap = 5;
            g1.layout = gl1;
            addChild(g1);

            var usernameLabel:Label = new Label();
            usernameLabel.text = "Username:";
            g1.addChild(usernameLabel);
            g1.addChild(usernameTextField);

            signOutButton.label = "Sign Out";
            addChild(signOutButton);
        }
    }
}
