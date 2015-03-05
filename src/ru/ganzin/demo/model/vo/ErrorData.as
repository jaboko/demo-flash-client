/**
 * Created by Dmitriy Ganzin on 04.03.15.
 */
package ru.ganzin.demo.model.vo
{
    import ru.ganzin.apron2.data.DataContainer;

    public class ErrorData extends DataContainer
    {
        public function get message():String
        {
            return getValue("message");
        }

        public function get mappedErrors():Object
        {
            return getValue("mappedErrors");
        }

    }
}
