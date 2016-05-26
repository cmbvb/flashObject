package com.canaan.lib.core
{
	import com.canaan.lib.abstract.AbstractVo;
	import com.canaan.lib.utils.ObjectUtil;
	
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	public class SysConfig
	{
		private static const CONFIG_SUFFIX:String = "ConfigVo";
		
		private static var voPackage:String;
		private static var configs:Dictionary = new Dictionary();
		
		public function SysConfig()
		{
			
		}
		
		public static function initialize(configObj:Object):void {
			if (!voPackage) {
				throw new Error("Has not set voPackage!");
			}
			var configId:String;
			var voClassName:String;
			var voId:String;
			var value:Object;
			for (configId in configObj) {
				voClassName = voPackage + configId + CONFIG_SUFFIX;
				if (ApplicationDomain.currentDomain.hasDefinition(voClassName)) {
					var config:Dictionary = configs[configId] || new Dictionary();
					value = configObj[configId];
					for (voId in value) {
						config[voId] = createConfigVo(voClassName, value[voId]);
					}
					configs[configId] = config;
				}
			}
		}
		
		public static function setVoPackage(path:String):void {
			voPackage = path;
		}
		
		public static function getConfig(configId:String):Dictionary {
			if (configs[configId] == null) {
				configs[configId] = new Dictionary();
			}
			return configs[configId];
		}
		
		public static function getConfigVo(configId:String, voId:*):AbstractVo {
			var vo:AbstractVo;
			var config:Dictionary = getConfig(configId);
			if (config != null) {
				vo = config[voId];
			}
			return vo;
		}
		
		private static function createConfigVo(voClassName:String, value:Object):AbstractVo {
			var vo:AbstractVo;
			var voClass:Class = ApplicationDomain.currentDomain.getDefinition(voClassName) as Class;
			if (voClassName != null) {
				vo = new voClass() as AbstractVo;
				ObjectUtil.fill(vo, value);
			}
			return vo;
		}
		
		public static function addConfigVo(configId:String, voId:*, vo:AbstractVo):void {
			var config:Dictionary = getConfig(configId);
			if (config != null) {
				config[voId] = vo;
			}
		}
		
		public static function removeConfigVo(configId:String, voId:*):void {
			var config:Dictionary = getConfig(configId);
			if (config != null) {
				delete config[voId];
			}
		}
	}
}