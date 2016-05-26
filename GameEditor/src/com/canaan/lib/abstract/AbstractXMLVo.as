package com.canaan.lib.abstract
{
	public class AbstractXMLVo extends AbstractVo
	{
		protected var _xml:XML;
		
		public function AbstractXMLVo(xml:XML)
		{
			super();
			_xml = xml;
			decode();
		}
		
		protected function decode():void {
			
		}
		
		public function get xml():XML {
			return _xml;
		}

		public function set xml(value:XML):void {
			_xml = value;
		}
	}
}