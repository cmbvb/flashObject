package com.canaan.lib.core
{
	import com.canaan.lib.managers.MouseManager;
	import com.canaan.lib.managers.ResManager;
	import com.canaan.lib.managers.StageManager;
	
	import flash.display.Sprite;

	public class Application
	{
		public static var app:Sprite;
		public static var config:Object;
		
		public function Application()
		{
			throw new Error("Application can not be initialize!");
		}
		
		public static function initialize(app:Sprite):void {
			Application.app = app;
			StageManager.getInstance().initialize(app.stage);
			MouseManager.getInstance().initialize();
		}
		
		public static function loadConfig(callback:Method):void {
			var configUrl:String = Config.getConfig("configRoot") + "config.byte";
			ResManager.getInstance().add(configUrl, "config", "config", new Method(loadConfigComplete, [callback]));
			ResManager.getInstance().load();
		}
		
		private static function loadConfigComplete(callback:Method, content:Object):void {
			Application.config = content;
			TableConfig.initialize(content.config);
			JSONConfig.initialize(content.json);
			XMLConfig.initialize(content.xml);
			TextConfig.initialize(content.text);
			
			callback.apply();
		}
	}
}