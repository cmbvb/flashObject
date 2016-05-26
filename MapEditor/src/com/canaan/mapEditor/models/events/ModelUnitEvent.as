package com.canaan.mapEditor.models.events
{
	import flash.events.Event;
	
	public class ModelUnitEvent extends Event
	{
		public static const UPDATE_UNIT:String = "updateUnit";
		
		private var _data:Object;
		
		public function ModelUnitEvent(type:String, data:Object = null)
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