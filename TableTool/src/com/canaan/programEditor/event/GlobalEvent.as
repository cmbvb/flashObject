package com.canaan.programEditor.event
{
	import flash.events.Event;
	
	public class GlobalEvent extends Event
	{
		public static const REFRESH_PATH:String = "refreshPath";
		
		public static const ENUM_VIEW_REFRESH_LIST:String = "enumViewRefreshList";
		public static const ENUM_FIELDS_REFRESH_LIST:String = "enumFieldsRefreshList";
		
		public static const PROTOCOL_VIEW_REFRESH_LIST:String = "protocolViewRefreshList";
		
		private var _data:Object;
		
		public function GlobalEvent(type:String, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
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