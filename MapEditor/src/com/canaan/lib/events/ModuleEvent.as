package com.canaan.lib.events
{
	import flash.events.Event;

	public class ModuleEvent extends Event
	{
		public static const ADDED_TO_SCENE:String = "addedToScene";
		public static const REMOVE_FROM_SCENE:String = "removeFromScene";
		
		public function ModuleEvent(type:String)
		{
			super(type);
		}
	}
}