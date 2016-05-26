package com.canaan.lib.events
{
	import flash.events.Event;

	public class SceneEvent extends Event
	{
		public static const ENTER_SCENE:String = "enterScene";
		public static const EXIT_SCENE:String = "exitScene";
		
		public function SceneEvent(type:String)
		{
			super(type);
		}
	}
}