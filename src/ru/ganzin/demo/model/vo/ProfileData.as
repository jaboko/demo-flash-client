/**
 * Created by Dmitriy Ganzin on 05.03.15.
 */
package ru.ganzin.demo.model.vo
{
    import ru.ganzin.apron2.data.DataContainer;

    public class ProfileData extends DataContainer
    {
        public function get username():String
        {
            return getValue("username");
        }
    }
}
