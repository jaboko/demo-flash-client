/**
 * Created by Dmitriy Ganzin on 04.03.15.
 */
package ru.ganzin.demo.model.vo
{
    public class AuthData
    {
        private var _username:String;
        private var _password:String;

        public function AuthData(username:String, password:String)
        {
            this._username = username;
            this._password = password;
        }

        public function get username():String
        {
            return _username;
        }

        public function get password():String
        {
            return _password;
        }
    }
}
