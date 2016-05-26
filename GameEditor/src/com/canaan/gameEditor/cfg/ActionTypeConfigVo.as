package com.canaan.gameEditor.cfg
{
	import com.canaan.lib.abstract.AbstractVo;
	
	public class ActionTypeConfigVo extends AbstractVo
	{
		public static const TITLES:Array = ["id", "name"];
		
		private var _id:int;
		private var _name:String;
		
		public function ActionTypeConfigVo()
		{
			super();
		}
		
		public function get cfgData():Object {
			var data:Object = {};
			data["id"] = _id;
			data["name"] = _name;
			return data;
		}
		
		public function get showText():String {
			return _id + "(" + _name + ")";
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function set id(value:int):void
		{
			_id = value;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
	}
}