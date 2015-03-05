/**
 * Created by jaboko on 27.09.14.
 */
package ru.ganzin.robotlegs.extensions.watcher
{
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.api.IExtension;

    import ru.ganzin.robotlegs.extensions.watcher.impl.InjectorListener;

    public class WatcherExtension implements IExtension
    {
        public function extend(context:IContext):void
        {
            const listener:InjectorListener = new InjectorListener(context.injector);
            context.afterDestroying(listener.destroy);
        }
    }
}
