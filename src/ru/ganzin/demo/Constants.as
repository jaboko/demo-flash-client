/**
 * Created by Dmitriy Ganzin on 04.03.15.
 */
package ru.ganzin.demo
{
    public class Constants
    {
        private static var _screens:ScreenConstants;
        private static var _auth:AuthConstants;

        public static function get auth():AuthConstants
        {
            return _auth || (_auth = new AuthConstants());
        }

        public static function get screens():ScreenConstants
        {
            return _screens || (_screens = new ScreenConstants());
        }
    }
}

class ScreenConstants
{
    public const BUSY:String = "busyScreen";
    public const SIGN_IN:String = "signInScreen";
    public const PROFILE:String = "profileScreen";
}

class AuthConstants
{
    public const IS_NOT_LOGINNED_STATE:int = 0;
    public const LOGINNED_STATE:int = 1;
    public const LOGIN_ERROR_STATE:int = 2;
    public const REGISTRATION_ERROR_STATE:int = 3;
}