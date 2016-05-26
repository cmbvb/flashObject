package com.canaan.lib.core
{
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	public class TableConfig
	{
		public static var ARRAY_SEPARATOR:String = ",";
		private static const CONFIG_SUFFIX:String = "ConfigVo";
		
		private static var tablePackage:String;
		private static var configs:Dictionary = new Dictionary();
		
		public function TableConfig()
		{
			
		}
		
		public static function initialize(configObj:Object):void {
			if (!configObj) {
				return;
			}
			tablePackage = Config.getConfig("tablePackage").toString();
			if (!tablePackage) {
				throw new Error("Has not set tablePackage!");
			}
			var configId:String;
			var voClassName:String;
			var voId:String;
			var value:Object;
			var types:Object;
			var data:Object;
			for (configId in configObj) {
				voClassName = tablePackage + "." + configId + CONFIG_SUFFIX;
				if (ApplicationDomain.currentDomain.hasDefinition(voClassName)) {
					var config:Dictionary = configs[configId] || new Dictionary();
					value = configObj[configId];
					types = value.types;
					data = value.data;
					for (voId in data) {
						config[voId] = createConfigVo(voClassName, types, data[voId]);
					}
					configs[configId] = config;
				}
			}
		}
		
		public static function getConfig(configId:String):Dictionary {
			return configs[configId];
		}
		
		public static function setConfig(configId:String, config:Dictionary):void {
			configs[configId] = configs;
		}
		
		public static function getConfigVo(configId:String, voId:*):Object {
			var vo:Object;
			var config:Dictionary = getConfig(configId);
			if (config != null) {
				vo = config[voId];
			}
			return vo;
		}
		
		public static function setConfigVo(configId:String, voId:*, vo:Object):void {
			var config:Dictionary = getConfig(configId);
			if (config != null) {
				config[voId] = vo;
			}
		}
		
		public static function removeConfigVo(configId:String, voId:*):void {
			var config:Dictionary = getConfig(configId);
			delete config[voId];
		}
		
		private static function createConfigVo(voClassName:String, types:Object, value:Object):Object {
			var vo:Object;
			var voClass:Class = ApplicationDomain.currentDomain.getDefinition(voClassName) as Class;
			if (voClassName != null) {
				vo = new voClass() as Object;
				var val:*;
				for (var key:Object in value) {
					if (vo.hasOwnProperty(key)) {
						val = value[key];
						switch (types[key]) {
							case "int":
								vo[key] = int(val);
								break;
							case "Number":
								vo[key] = isNaN(Number(val)) ? 0 : Number(val);
								break;
							case "Boolean":
								vo[key] = Boolean(val);
								break;
							case "String":
								vo[key] = val.toString();
								break;
							case "Array":
								vo[key] = val.toString() != "" ? val.toString().split(ARRAY_SEPARATOR) : [];
								break;
						}
					}
				}
			}
			return vo;
		}
	}
}