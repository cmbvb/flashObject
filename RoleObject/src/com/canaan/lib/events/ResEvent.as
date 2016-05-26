package com.canaan.lib.events
{
	import flash.events.Event;

	public class ResEvent extends Event
	{
		public static const START_LOAD:String = "startLoad";
		public static const COMPLETE:String = "complete";
		public static const PROGRESS:String = "progress";
		
		private var _data:Object;
		
		public function ResEvent(type:String, data:Object = null)
		{
			super(type);
			_data = data;
		}
		
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

	}
}