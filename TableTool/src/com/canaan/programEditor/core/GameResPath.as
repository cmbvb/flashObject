package com.canaan.programEditor.core
{
	import com.canaan.lib.core.ResItem;
	
	import flash.filesystem.File;

	public class GameResPath
	{
		public static var root:String;												// 资源根目录
		public static var assets:String;											// 资源目录
		public static var config:String;											// 配置表目录
		public static var audio:String;												// 音频目录
		public static var externalImage:String;										// 动态图片目录
		public static var swf:String;												// swf目录
		public static var map:String;												// map目录
		public static var action:String;											// 角色动作目录
		
		public static var cfg_root:String;											// 配置文件根目录
		public static var cfg_uiswf:String;											// UI资源文件
		public static var cfg_data:String;											// config目录
		
		public static var file_root:String;											// 资源根目录
		public static var file_assets:String;										// 资源目录
		public static var file_config:String;										// 配置表目录
		public static var file_audio:String;										// 音频目录
		public static var file_externalImage:String;								// 动态图片目录
		public static var file_swf:String;											// swf目录
		public static var file_map:String;											// map目录
		public static var file_action:String;										// 角色动作目录
		
		public static var file_cfg_root:String;										// 配置文件根目录
		public static var file_cfg_uiswf:String;									// UI资源文件
		public static var file_cfg_data:String;										// config目录
		
		public static var file_cfg_data_setting:String;
		public static var file_cfg_data_enums:String;
		public static var file_cfg_data_protocols:String;
		
		public static var PRELOAD_FILES:Vector.<ResItem>;
		
		public function GameResPath()
		{
		}
		
		public static function initialize():void {
			root = "output";
			assets = root + "/res/zh_CN/assets/";
			config = assets + "config/";
			audio = assets + "audio/";
			externalImage = assets + "externalImage/";
			swf = assets + "swf/";
			map = assets + "map/";
			action = assets + "action/";
			
			cfg_root = "cfg/";
			cfg_uiswf = cfg_root + "uiswf/";
			cfg_data = cfg_root + "data/";
			
			file_root = File.applicationDirectory.nativePath + "\\output";
			file_assets = file_root + "\\res\\zh_CN\\assets\\";
			file_config = file_assets + "config\\";
			file_audio = file_assets + "audio\\";
			file_externalImage = file_assets + "externalImage\\";
			file_swf = file_assets + "swf\\";
			file_map = file_assets + "map\\";
			file_action = file_assets + "action\\";
			
			file_cfg_root = File.applicationDirectory.nativePath + "\\cfg\\";
			file_cfg_uiswf = file_cfg_root + "uiswf\\";
			file_cfg_data = file_cfg_root + "data\\";
			
			file_cfg_data_setting = file_cfg_data + "setting.xml";
			file_cfg_data_enums = file_cfg_data + "enums.xml";
			file_cfg_data_protocols = file_cfg_data + "protocols.xml";
			
			PRELOAD_FILES = new <ResItem>[
				new ResItem(cfg_uiswf + "comp.swf", "comp")
			];
		}
	}
}