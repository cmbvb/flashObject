package com.canaan.lib.debug
{
	import com.canaan.lib.events.LogEvent;
	import com.canaan.lib.utils.DateUtil;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	[Event(name="log", type="com.canaan.lib.events.LogEvent")]
	
	public class Log extends EventDispatcher
	{
		public static const INFO:int = 0;
		public static const WARN:int = 1;
		public static const ERROR:int = 2;
		public static const FATAL:int = 3;
		
		public static const LEVEL_CONFIG:Object = {
			0:"INFO",
			1:"WARN",
			2:"ERROR",
			3:"FATAL"
		}
		private static var canInstantiate:Boolean = false;
		private static var instance:Log;
		
		private var logDict:Dictionary = new Dictionary();
		private var _enabled:Boolean = true;
		private var _printable:Boolean = true;

		public function Log()
		{
			if (!canInstantiate) {
				throw new Error("Can not instantiate, use getInstance() instead.");
			}
		}
		
		public static function getInstance():Log {
			if (instance == null) {
				canInstantiate = true;
				instance = new Log();
				canInstantiate = false;
			}
			return instance;
		}
		
		public function initialLog(owner:String = "System", logLevel:int = 0):void {
			if (logDict[owner] == null) {
				var logItem:LogItem = new LogItem(owner, logLevel);
				logDict[owner] = logItem;
			}
		}

		public function info(value:*, owner:String = "System"):void {
			log(owner, INFO, value);
		}
		
		public function warn(value:*, owner:String = "System"):void {
			log(owner, WARN, value);
		}
		
		public function error(value:*, owner:String = "System"):void {
			log(owner, ERROR, value);
		}
		
		public function fatal(value:*, owner:String = "System"):void {
			log(owner, FATAL, value);
		}
		
		private function log(owner:String, logLevel:int, value:*):void {
			if (!_enabled) {
				return;
			}
			
			if (logDict[owner] == null) {
				initialLog(owner, INFO);
			}
				
			var logItem:LogItem = logDict[owner];
			
			if (logLevel >= logItem.logLevel) {
				var logString:String = formatLogString(owner, logLevel, value);
				var event:LogEvent = new LogEvent(LogEvent.LOG, value, owner, logLevel, logString);
				dispatchEvent(event);
				if (_printable) {
					trace(logString);
				}
			}
		}
		
		private function formatLogString(owner:String, logLevel:int, value:*):String {
			var logString:String = "[LOG] " + DateUtil.formatDateFromSeconds(new Date().time * 0.001) + " ";
			logString += "[owner:\"" + owner + "\" ";
			logString += "level:\"" + LEVEL_CONFIG[logLevel] + "\"] - ";
			logString += value.toString();
			return logString;
		}
		
		public function set enabled(value:Boolean):void {
			_enabled = value;
		}
		
		public function get enabled():Boolean {
			return _enabled;
		}
		
		public function set printable(value:Boolean):void {
			_printable = value;
		}
		
		public function get printable():Boolean {
			return _printable;
		}
	}
}

internal class LogItem
{
	public var owner:String;
	public var logLevel:int;
	
	public function LogItem(owner:String, logLevel:int)
	{
		this.owner = owner;
		this.logLevel = logLevel;
	}
}