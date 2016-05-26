package com.canaan.lib.core
{
	import flash.utils.Dictionary;

	public class VersionData
	{
		public static var versions:Dictionary = new Dictionary();
		
		public function VersionData()
		{
			super();
		}
		
		public static function setVersionData(versionStr:String):void {
			var list:Array = versionStr.split("\r\n");
			for each (var line:String in list) {
				var indexOf:int = line.indexOf("=");
				if (indexOf != -1) {
					var mKey:String = line.substring(0, indexOf);
					var rtrim:String = line.substring(indexOf + 1);
					versions[mKey] = rtrim;
				} 
			}
		}
		
		public static function getVersion(url:String):String {
			return versions[url];
		}
		
		public static function setVersion(url:String, version:String):void {
			versions[url] = version;
		}
	}
}