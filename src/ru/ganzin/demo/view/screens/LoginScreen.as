/**
 * Created by jaboko on 02.03.15.
 */
package ru.ganzin.demo.view.screens
{
    import feathers.controls.Button;
    import feathers.controls.Callout;
    import feathers.controls.Label;
    import feathers.controls.LayoutGroup;
    import feathers.controls.TextInput;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.VerticalLayout;

    import flash.text.engine.ElementFormat;

    import ru.ganzin.demo.model.vo.ErrorData;
    import ru.ganzin.demo.view.base.ScreenBase;

    public class LoginScreen extends ScreenBase
    {
        public var usernameTextInput:TextInput = new TextInput();
        public var passwordTextInput:TextInput = new TextInput();
        public var signInButton:Button = new Button();
        public var signUpButton:Button = new Button();
        public var errorMessage:Label = new Label();

        override protected function initialize():void
        {
            super.initialize();

            var layout:VerticalLayout = new VerticalLayout();
            layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_CENTER;
            layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
            layout.gap = 10;
            this.layout = layout;

            var g1:LayoutGroup = new LayoutGroup();
            var g1l:VerticalLayout = new VerticalLayout();
            g1l.gap = 5;
            g1.layout = g1l;
            addChild(g1);

            usernameTextInput.prompt = "Username";
            g1.addChild(usernameTextInput);

            passwordTextInput.prompt = "Password";
            passwordTextInput.displayAsPassword = true;
            g1.addChild(passwordTextInput);

            var g2:LayoutGroup = new LayoutGroup();
            var l2:HorizontalLayout = new HorizontalLayout();
            l2.gap = 5;
            g2.layout = l2;
            addChild(g2);

            signInButton.label = "Sign In";
            g2.addChild(signInButton);

            signUpButton.label = "Sign Out";
            g2.addChild(signUpButton);

            addChild(errorMessage);

            var ef:ElementFormat = errorMessage.textRendererProperties.elementFormat.clone();
            ef.color = 0xFF0000;
            errorMessage.textRendererProperties.elementFormat = ef;
        }

        public function validateData():Boolean
        {
            var ret:Boolean = true;

            var unTest:RegExp = /^[a-zA-Z0-9]{4,16}+$/;
            if (!unTest.test(usernameTextInput.text))
            {
                var label:Label = new Label();
                label.text = "The user name must consist of 4-16 letters or numbers";
                Callout.show(label, usernameTextInput, Callout.DIRECTION_UP, false);

                ret = false;
            }

            if (passwordTextInput.text.length == 0)
            {
                var label:Label = new Label();
                label.text = "Password should not be empty";
                Callout.show(label, passwordTextInput, Callout.ARROW_POSITION_RIGHT, false);

                ret = false;
            }

            return ret;
        }

        public function showError(error:ErrorData):void
        {
            errorMessage.text = "Username or password incorrect";
        }
    }
}
