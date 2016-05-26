package com.canaan.lib.core
{
	import com.canaan.lib.managers.StageManager;
	
	import flash.display.Stage;
	import flash.utils.Dictionary;
	
	public class Config
	{
		private static var config:Dictionary = new Dictionary();
		
		public static function setConfig(name:String, value:*):void {
			config[name] = value;
		}
		
		public static function getConfig(name:String):* {
			var result:* = null;
			var stage:Stage = StageManager.getInstance().stage;
			if (stage) {
				if (stage.loaderInfo) {
					result = stage.loaderInfo.parameters[name];
				} else if (stage.parent && stage.parent.loaderInfo) {
					result = stage.parent.loaderInfo.parameters[name];
				} else {
					result = Application.app.loaderInfo.parameters[name];
				}
				if (result != null && result != "") {
					return result;
				}
			}
			if (config.hasOwnProperty(name)) {
				return config[name];
			}
			return "";
		}
	}
}