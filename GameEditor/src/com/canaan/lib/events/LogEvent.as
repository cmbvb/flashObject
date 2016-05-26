package com.canaan.lib.events
{
	import flash.events.Event;

	public class LogEvent extends Event
	{
		public static const LOG:String = "log";
		
		private var _value:Object;
		private var _owner:String;
		private var _logLevel:int;
		private var _logString:String;
		
		public function LogEvent(type:String, value:Object, owner:String, logLevel:int, logString:String)
		{
			super(type);
			_value = value;
			_owner = owner;
			_logLevel = logLevel;
			_logString = logString;
		}
		
		public function get value():Object {
			return _value;
		}
		
		public function get owner():String {
			return _owner;
		}
		
		public function get logLevel():int {
			return _logLevel;
		}
		
		public function get logString():String {
			return _logString;
		}
	}
}