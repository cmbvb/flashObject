package com.canaan.lib.abstract
{
	public class AbstractXMLVo extends AbstractVo
	{
		protected var _xml:XML;
		
		public function AbstractXMLVo()
		{
			super();
		}
		
		protected function decode():void {
			
		}
		
		public function get xml():XML {
			return _xml;
		}

		public function set xml(value:XML):void {
			if (value) {
				_xml = value;
				decode();
			}
		}
	}
}