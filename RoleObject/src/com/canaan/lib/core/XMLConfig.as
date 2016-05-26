package com.canaan.lib.core
{
	import com.canaan.lib.abstract.AbstractXMLVo;
	
	import flash.utils.Dictionary;

	public class XMLConfig
	{
		private static var cfgRoot:Object = new Object();
		
		private static var configs:Dictionary = new Dictionary();
		
		public function XMLConfig()
		{
		}
		
		public static function initialize(configObj:Object):void {
			if (!configObj) {
				return;
			}
			cfgRoot = configObj;
		}
		
		public static function getXMLString(configId:String):String {
			return cfgRoot[configId];
		}
		
		public static function getConfig(configId:String):Dictionary {
			return configs[configId];
		}
		
		public static function getConfigVo(configId:String, voId:String):AbstractXMLVo {
			var vo:AbstractXMLVo;
			var config:Dictionary = getConfig(configId);
			if (config != null) {
				vo = config[voId];
			}
			return vo;
		}
		
		public static function setXMLString(configId:String, xmlString:String):void {
			cfgRoot[configId] = xmlString;
		}
		
		public static function setConfig(configId:String, config:Dictionary):void {
			configs[configId] = config;
		}
		
		public static function setConfigVo(configId:String, voId:String, vo:AbstractXMLVo):void {
			if (configs[configId] == null) {
				configs[configId] = new Dictionary();
			}
			configs[configId][voId] = vo;
		}
	}
}