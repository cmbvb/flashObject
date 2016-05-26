package com.canaan.mapEditor.models.events
{
	import flash.events.Event;
	
	public class ModelMapEvent extends Event
	{
		public static const UPDATE_MAP_DATA:String = "updateMapData";
		public static const CHANGE_GRID_MODE:String = "changeGridMode";
		
		private var _data:Object;
		
		public function ModelMapEvent(type:String, data:Object = null)
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