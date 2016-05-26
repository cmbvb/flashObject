package com.canaan.programEditor.data
{
	import com.canaan.lib.abstract.AbstractVo;
	
	public class EnumFieldVo extends AbstractVo
	{
		private var _value:int;
		private var _name:String;
		private var _desc:String;
		
		public function EnumFieldVo()
		{
			super();
		}

		public function get value():int
		{
			return _value;
		}

		public function set value(value:int):void
		{
			_value = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get desc():String
		{
			return _desc;
		}

		public function set desc(value:String):void
		{
			_desc = value;
		}
	}
}