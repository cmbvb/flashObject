package com.canaan.lib.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class DragEvent extends Event
	{
		public static const DRAG_START:String = "dragStart";
		public static const DRAG_COMPLETE:String = "dragComplete";
		public static const DRAG_DROP:String = "dragDrop";
		
		public static const DRAG_MOVE:String = "dragMove";
		
		public var data:Object;
		public var dragInitiator:DisplayObject;
		
		public function DragEvent(type:String, dragInitiator:DisplayObject, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.dragInitiator = dragInitiator;
			this.data = data;
		}
	}
}