package com.canaan.programEditor.data
{
	import com.canaan.lib.abstract.AbstractVo;
	
	public class EnumVo extends AbstractVo
	{
		private var _name:String;
		private var _fields:Array = [];
		
		public function EnumVo()
		{
			super();
		}
		
		public function get csFileName():String {
			return _name + ".cs";
		}
		
		public function get asFileName():String {
			return _name + ".as";
		}
		
		public function sortFields():void {
			_fields.sortOn("value", Array.NUMERIC);
		}
		
		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get fields():Array
		{
			return _fields;
		}

		public function set fields(value:Array):void
		{
			_fields = value;
		}
	}
}