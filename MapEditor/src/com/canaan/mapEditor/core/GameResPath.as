package com.canaan.mapEditor.core
{
	import com.canaan.lib.core.ResItem;
	
	import flash.filesystem.File;

	public class GameResPath
	{
		public static var clientPath:String;
		public static var serverPath:String;
		
		public static var cfg_root:String;											// 配置文件根目录
		public static var cfg_uiswf:String;											// UI资源文件
		public static var cfg_data:String;											// config目录
		public static var map_root:String;											// 地图文件根目录
		
		public static var file_cfg_root:String;										// 配置文件根目录
		public static var file_cfg_uiswf:String;									// UI资源文件
		public static var file_cfg_data:String;										// config目录
		public static var file_map_root:String;										// 地图文件根目录
		
		// 客户端配置
		public static var client_assets:String;										// 资源目录
		public static var client_config:String;										// 配置表目录
		public static var client_map:String;										// map目录
		public static var client_action:String;										// 动作目录
		
		public static var file_client_path:String;									// 客户端文件目录
		public static var file_server_path:String;									// 服务器文件目录
		public static var file_client_assets:String;								// 资源目录
		public static var file_client_config:String;								// 配置表目录
		public static var file_client_map:String;									// map目录
		public static var file_client_action:String;								// 动作目录
		
		// setting配置文件
		public static var file_cfg_data_setting:String;
		
		public static var PRELOAD_FILES:Vector.<ResItem>;
		
		public function GameResPath()
		{
		}
		
		public static function initialize():void {
			cfg_root = "cfg/";
			cfg_uiswf = cfg_root + "uiswf/";
			cfg_data = cfg_root + "data/";
			map_root = "map/";
			
			file_cfg_root = File.applicationDirectory.nativePath + "\\cfg\\";
			file_cfg_uiswf = file_cfg_root + "uiswf\\";
			file_cfg_data = file_cfg_root + "data\\";
			file_map_root = File.applicationDirectory.nativePath + "\\map\\";
			
			file_cfg_data_setting = file_cfg_data + "setting.xml";
			
			PRELOAD_FILES = new <ResItem>[
				new ResItem(cfg_uiswf + "comp.swf", "comp")
			];
		}
		
		public static function initializeConfig():void {
			client_assets = clientPath + "/res/zh_CN/assets/";
			client_config = client_assets + "config/";
			client_map = client_assets + "map/";
			client_action = client_assets + "action/";
			
			file_client_path = new File(File.applicationDirectory.nativePath).resolvePath(clientPath).nativePath + "\\res\\zh_CN\\";
			file_server_path = new File(File.applicationDirectory.nativePath).resolvePath(serverPath).nativePath + "\\";
			file_client_assets = file_client_path + "assets\\";
			file_client_config = file_client_assets + "config\\";
			file_client_map = file_client_assets + "map\\";
			file_client_action = file_client_assets + "action";
			
			BMPActionLoader.actionRoot = file_client_action;
		}
	}
}