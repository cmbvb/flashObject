package com.canaan.lib.core
{
	public class SysSetting
	{
		public static var setting:Object;
		
		public function SysSetting()
		{
		}
		
		public static function initialize(settingObj:Object):void {
			setting = settingObj;
		}
		
		public static function getSetting(name:String):Object {
			return setting[name];
		}
	}
}