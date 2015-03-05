package ru.ganzin.utils.bitmap.cache.render
{
    import flash.events.IEventDispatcher;

    public interface IRenderItem extends IEventDispatcher
	{
		function get completed():Boolean;
		function render():void;
	}
}