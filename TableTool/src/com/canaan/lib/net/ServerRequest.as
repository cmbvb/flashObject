package com.canaan.lib.net
{
	public class ServerRequest
	{
		private var _protocol:*;
		private var _data:Object;
		private var _requestData:Object = {};
		
		public function ServerRequest(protocol:* = 0, data:Object = null)
		{
			reset(protocol, data);
		}
		
		public function reset(protocol:*, data:Object = null):void {
			_protocol = protocol;
			_data = data;
			_requestData.protocol = _protocol;
			_requestData.data = data;
		}
		
		public function get protocol():* {
			return _protocol;
		}
		
		public function get data():Object {
			return _data;
		}
		
		public function get requestData():Object {
			return _requestData;
		}
	}
}