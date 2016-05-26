package com.canaan.lib.events
{
	import com.canaan.lib.net.ServerRequest;
	import com.canaan.lib.net.ServerResult;
	
	import flash.events.Event;

	public class SocketEvent extends Event
	{
		public static const CONNECT:String = "connect";
		public static const CLOSE:String = "close";
		public static const IO_ERROR:String = "ioError";
		public static const SECURITY_ERROR:String = "securityError";
		public static const START_CONNECT:String = "startConnect";
		public static const SEND:String = "send";
		public static const RECEIVED:String = "received";
		public static const COMPLETE:String = "complete";
		public static const SERVER_ERROR:String = "serverError";
		
		private var _socketName:String;
		private var _result:ServerResult;
		private var _request:ServerRequest;
		
		public function SocketEvent(type:String, socketName:String, result:ServerResult = null, request:ServerRequest = null)
		{
			super(type);
			_socketName = socketName;
			_result = result;
			_request = request;
		}
		
		public function get socketName():String {
			return _socketName;
		}
		
		public function get result():ServerResult {
			return _result;
		}
		
		public function get request():ServerRequest {
			return _request;
		}
	}
}