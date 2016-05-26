package com.canaan.programEditor.data
{
	import com.canaan.lib.abstract.AbstractVo;
	
	public class ProtocolPackageVo extends AbstractVo
	{
		private var _name:String;
		private var _protocols:Array = [];
		
		public function ProtocolPackageVo()
		{
			super();
		}
		
		public function sortProtocols():void {
			_protocols.sortOn("number#", Array.NUMERIC);
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get protocols():Array
		{
			return _protocols;
		}

		public function set protocols(value:Array):void
		{
			_protocols = value;
		}
	}
}