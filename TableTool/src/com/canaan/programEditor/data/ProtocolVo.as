package com.canaan.programEditor.data
{
	import com.canaan.lib.abstract.AbstractVo;
	import com.canaan.lib.utils.StringUtil;
	
	public class ProtocolVo extends AbstractVo
	{
		private var _id:int;
		private var _name:String;
		private var _desc:String;
		private var _content:String;
		
		public function ProtocolVo()
		{
			super();
		}
		
		public function get canCreateCSProcesser():Boolean {
			return StringUtil.equalEnd("_req", _name.toLowerCase());
		}
		
		public function get csFileName():String {
			return _name + ".cs";
		}
		
		public function get csProcesserName():String {
			return _name + "_proc.cs";
		}
		
		public function get csHandlerName():String {
			return "handle_" + _name;
		}
		
		public function get asFileName():String {
			return _name + ".as";
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

		public function get desc():String
		{
			return _desc;
		}

		public function set desc(value:String):void
		{
			_desc = value;
		}

		public function get content():String
		{
			return _content;
		}

		public function set content(value:String):void
		{
			_content = value;
		}
	}
}