package com.canaan.lib.abstract
{
	public class AbstractJSONVo extends AbstractVo
	{
		protected var _json:Object;
		
		public function AbstractJSONVo()
		{
			super();
		}
		
		protected function decode():void {
			
		}

		public function get json():Object {
			return _json;
		}

		public function set json(value:Object):void {
			if (value != null) {
				_json = value;
				decode();
			}
		}
		
		public function set jsonString(value:String):void {
			if (value != null) {
				_json = JSON.parse(value);
				decode();
			}
		}
	}
}