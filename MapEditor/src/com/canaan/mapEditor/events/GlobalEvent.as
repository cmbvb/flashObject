package com.canaan.mapEditor.events
{
	import flash.events.Event;
	
	public class GlobalEvent extends Event
	{
		public static const UPDATE_CONFIG:String = "updateConfig";
		public static const UPDATE_MAP_POS:String = "updateMapPos";
		public static const UPDATE_MAP_SIZE:String = "updateMapSize";
		public static const UPDATE_MAP_OBJECT:String = "updateMapObject";
		public static const UPDATE_MAP_OBJECTS:String = "updateMapObjects";
		public static const UPDATE_UNIT_POS:String = "updateUnitPos";
		public static const ON_MOUSE_SELECT:String = "onMouseSelect";
		
		private var _data:Object;
		
		public function GlobalEvent(type:String, data:Object = null)
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