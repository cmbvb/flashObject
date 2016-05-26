package com.canaan.lib.core
{
	public class TextConfig
	{
		private static var cfgRoot:Object = new Object();
		
		public function TextConfig()
		{
		}
		
		public static function initialize(configObj:Object):void {
			if (!configObj) {
				return;
			}
			cfgRoot = configObj;
		}
		
		public static function getTextString(configId:String):String {
			return cfgRoot[configId];
		}
		
		public static function setTextString(configId:String, textString:String):void {
			cfgRoot[configId] = textString;
		}
	}
}