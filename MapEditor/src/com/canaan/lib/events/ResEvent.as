package com.canaan.lib.events
{
	import flash.events.Event;

	public class ResEvent extends Event
	{
		public static const START_LOAD:String = "startLoad";
		public static const COMPLETE:String = "complete";
		public static const PROGRESS:String = "progress";
		
		public function ResEvent(type:String)
		{
			super(type);
		}
	}
}