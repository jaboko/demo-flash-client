/**
 * User: Dmitriy Ganzin
 * Date: 07.07.11
 * Time: 14:19
 */
package ru.ganzin.utils
{
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.utils.Dictionary;

    public class TextFieldVerticalAligner
    {
        public static const TOP:String = "top";
        public static const BOTTOM:String = "bottom";
        public static const MIDDLE:String = "middle";

        private static var textFields:Dictionary = new Dictionary(true);

        public static function resetTextFieldInfo(tf:TextField):void
        {
            if (textFields[tf])
            {
                tf.autoSize = TextFieldAutoSize.NONE;

                var textFieldInfo:TextFieldInfo = textFields[tf];
                tf.x = textFieldInfo.x;
                tf.y = textFieldInfo.y;
                tf.width = textFieldInfo.width;
                tf.height = textFieldInfo.height;

                delete textFields[tf];
            }
        }

        public static function alignTextField(tf:TextField, alignType:String = null, resetWidthAfter:Boolean = true):void
        {
            var textFieldInfo:TextFieldInfo;
            var uid:TextField

            if (tf in textFields)
            {
                textFieldInfo = textFields[tf];

                tf.autoSize = TextFieldAutoSize.NONE;
                tf.x = textFieldInfo.x;
                tf.y = textFieldInfo.y;
                tf.width = textFieldInfo.width;
                tf.height = textFieldInfo.height;

                if (alignType != null && alignType != textFieldInfo.alignType) delete textFields[tf];
            }

            if (!alignType) alignType = TOP;

            if (!textFieldInfo)
            {
                textFieldInfo = new TextFieldInfo(tf.x, tf.y, tf.width, tf.height, alignType);
                textFields[tf] = textFieldInfo;
            }

            tf.x = textFieldInfo.x;
            tf.y = textFieldInfo.y;
			tf.width = textFieldInfo.width;
            tf.height = textFieldInfo.height;
			tf.autoSize = TextFieldAutoSize.LEFT;

            if (alignType == TOP) tf.y = textFieldInfo.y;
            else if (alignType == MIDDLE) tf.y = textFieldInfo.y + (textFieldInfo.height - tf.height) / 2;
            else if (alignType == BOTTOM) tf.y = textFieldInfo.y + textFieldInfo.height - tf.height;

			tf.autoSize = TextFieldAutoSize.NONE;
			tf.x = textFieldInfo.x;
			tf.width = textFieldInfo.width;
        }
    }

}

class TextFieldInfo
{
    public var x:Number;
    public var y:Number;
    public var width:Number;
    public var height:Number;
    public var alignType:String;

    public function TextFieldInfo(x:Number, y:Number, width:Number, height:Number, alignType:String)
    {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.alignType = alignType;
    }
}