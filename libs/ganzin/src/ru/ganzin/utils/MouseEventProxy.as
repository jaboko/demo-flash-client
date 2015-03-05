/**
 * User: Dmitriy Ganzin
 * Date: 20.01.11
 * Time: 23:40
 */
package ru.ganzin.utils
{
    import flash.display.InteractiveObject;
    import flash.events.MouseEvent;

    public class MouseEventProxy extends MouseEvent
	{
		private var event:MouseEvent;

		public function MouseEventProxy(event:MouseEvent)
		{
			this.event = MouseEvent(event.clone());
			this.type = event.type;
			this.stageX = event.stageX;
			this.stageY = event.stageY;
			super(type);
		}

		private var _type:String;

		public function set type(value:String):void
		{
			_type = value;
		}

		override public function get type():String
		{
			return (_type) ? _type : super.type;
		}

		override public function toString():String
		{
			return event.toString();
		}

		override public function get localX():Number
		{
			return event.localX;
		}

		override public function set localX(value:Number):void
		{
			event.localX = value;
		}

		override public function get localY():Number
		{
			return event.localY;
		}

		override public function set localY(value:Number):void
		{
			event.localY = value;
		}

		override public function get relatedObject():InteractiveObject
		{
			return event.relatedObject;
		}

		override public function set relatedObject(value:InteractiveObject):void
		{
			event.relatedObject = value;
		}

		override public function get ctrlKey():Boolean
		{
			return event.ctrlKey;
		}

		override public function set ctrlKey(value:Boolean):void
		{
			event.ctrlKey = value;
		}

		override public function get altKey():Boolean
		{
			return event.altKey;
		}

		override public function set altKey(value:Boolean):void
		{
			event.altKey = value;
		}

		override public function get shiftKey():Boolean
		{
			return event.shiftKey;
		}

		override public function set shiftKey(value:Boolean):void
		{
			event.shiftKey = value;
		}

		override public function get buttonDown():Boolean
		{
			return event.buttonDown;
		}

		override public function set buttonDown(value:Boolean):void
		{
			event.buttonDown = value;
		}

		override public function get delta():int
		{
			return event.delta;
		}

		override public function set delta(value:int):void
		{
			event.delta = value;
		}

		private var _stageX:Number;

		public function set stageX(value:Number):void
		{
			_stageX = value;
		}

		override public function get stageX():Number
		{
			return (isNaN(_stageX)) ? event.stageX : _stageX;
		}

		private var _stageY:Number;

		public function set stageY(value:Number):void
		{
			_stageY = value;
		}

		override public function get stageY():Number
		{
			return (isNaN(_stageY)) ? event.stageY : _stageY;
		}

		override public function updateAfterEvent():void
		{
			event.updateAfterEvent();
		}

		[Version("10")]
		override public function get isRelatedObjectInaccessible():Boolean
		{
			return event.isRelatedObjectInaccessible;
		}

		[Version("10")]
		override public function set isRelatedObjectInaccessible(value:Boolean):void
		{
			event.isRelatedObjectInaccessible = value;
		}

		override public function get bubbles():Boolean
		{
			return event.bubbles;
		}

		override public function get cancelable():Boolean
		{
			return event.cancelable;
		}

		override public function get target():Object
		{
			return event.target;
		}

		override public function get currentTarget():Object
		{
			return event.currentTarget;
		}

		override public function get eventPhase():uint
		{
			return event.eventPhase;
		}

		override public function stopPropagation():void
		{
			event.stopPropagation();
		}

		override public function stopImmediatePropagation():void
		{
			event.stopImmediatePropagation();
		}

		override public function preventDefault():void
		{
			event.preventDefault();
		}

		override public function isDefaultPrevented():Boolean
		{
			return event.isDefaultPrevented();
		}
	}
}
