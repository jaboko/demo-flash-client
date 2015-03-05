/**
 * Created by IntelliJ IDEA.
 * User: Dimka-Lenovo
 * Date: 20.02.12
 * Time: 15:48
 */
package ru.ganzin.utils.lifecycle
{
    import ru.ganzin.apron2.interfaces.IDisposable;

    public interface ILifeCycleObject extends IDisposable
    {
        function get lifeCycleSignalsSet():LifeCycleSignalsSet;

        function invalidate(property:String = null):void;

        function isInvalid(property:String = null):Boolean;

        function validateNow():void;
    }
}
