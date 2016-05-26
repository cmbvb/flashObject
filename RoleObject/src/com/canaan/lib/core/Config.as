package com.canaan.lib.core
{
	import flash.display.Stage;
	import flash.utils.Dictionary;
	
	public class Config
	{
		private static var config:Dictionary = new Dictionary();
		
		public static function initialize(stage:Stage):void {
			if (stage) {
				if (stage.loaderInfo) {
					for (var name:String in stage.loaderInfo.parameters) {
						setConfig(name, stage.loaderInfo.parameters[name]);
					}
				}
			}
		}
		
		public static function setConfig(name:String, value:*):void {
			config[name] = value;
		}
		
		public static function getConfig(name:String):* {
			if (config.hasOwnProperty(name)) {
				return config[name];
			}
			return "";
		}
	}
}