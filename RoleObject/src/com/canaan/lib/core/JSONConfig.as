package com.canaan.lib.core
{
	import com.canaan.lib.abstract.AbstractJSONVo;
	
	import flash.utils.Dictionary;
	
	public class JSONConfig
	{
		private static var cfgRoot:Object = new Object();
		
		private static var configs:Dictionary = new Dictionary();
		
		public function JSONConfig()
		{
		}
		
		public static function initialize(configObj:Object):void {
			if (!configObj) {
				return;
			}
			cfgRoot = configObj;
		}
		
		public static function getJSONString(configId:String):String {
			return cfgRoot[configId];
		}
		
		public static function getConfig(configId:String):Dictionary {
			return configs[configId];
		}
		
		public static function getConfigVo(configId:String, voId:String):AbstractJSONVo {
			var vo:AbstractJSONVo;
			var config:Dictionary = getConfig(configId);
			if (config != null) {
				vo = config[voId];
			}
			return vo;
		}
		
		public static function setJSONString(configId:String, jsonString:String):void {
			cfgRoot[configId] = jsonString;
		}
		
		public static function setConfig(configId:String, config:Dictionary):void {
			configs[configId] = config;
		}
		
		public static function setConfigVo(configId:String, voId:String, vo:AbstractJSONVo):void {
			if (configs[configId] == null) {
				configs[configId] = new Dictionary();
			}
			configs[configId][voId] = vo;
		}
	}
}


