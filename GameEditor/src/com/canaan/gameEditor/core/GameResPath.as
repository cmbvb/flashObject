package com.canaan.gameEditor.core
{
	import com.canaan.lib.core.ResItem;
	
	import flash.filesystem.File;

	public class GameResPath
	{
		public static var outputPath:String;
		public static var tablePath:String;
		
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
		public static var cfg_lib:String;											// swift目录
		public static var cfg_data:String;											// config目录
		public static var cfg_table:String;											// table目录
		public static var cfg_action:String;										// 动作根目录
		public static var cfg_actionImages:String;									// 动作图片目录
		public static var cfg_actionSwf:String;										// 动作swf目录
		public static var cfg_actionXML:String;										// 动作配置目录
		public static var cfg_audio:String;											// 音频根目录
		public static var cfg_audioSource:String;									// 音频源目录
		public static var cfg_audioXML:String;										// 音频配置目录
		
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
		public static var file_cfg_lib:String;										// swift目录
		public static var file_cfg_data:String;										// config目录
		public static var file_cfg_table:String;									// table目录
		public static var file_cfg_action:String;									// 动作根目录
		public static var file_cfg_actionImages:String;								// 动作图片目录
		public static var file_cfg_actionSwf:String;								// 动作swf目录
		public static var file_cfg_actionXML:String;								// 动作配置目录
		public static var file_cfg_audio:String;									// 音频根目录
		public static var file_cfg_audioSource:String;								// 音频源目录
		public static var file_cfg_audioXML:String;									// 音频配置目录
		
		// setting文件
		public static var file_cfg_data_setting:String;
		public static var file_cfg_data_role:String;
		public static var file_cfg_data_action:String;
		public static var file_cfg_data_sound:String;
		public static var file_cfg_data_skill:String;
		public static var file_cfg_data_roleType:String;
		public static var file_cfg_data_actionType:String;
		
		// table文件
		public static var file_cfg_table_role:String;
		public static var file_cfg_table_action:String;
		public static var file_cfg_table_sound:String;
		public static var file_cfg_table_skill:String;
		
		public static var file_output_root:String;									// 输出根目录
		public static var file_output_assets:String;								// 输出资源目录
		public static var file_output_audio:String;									// 输出音频目录
		public static var file_output_action:String;								// 输出动作目录
		
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
			cfg_lib = cfg_root + "lib/";
			cfg_data = cfg_root + "data/";
			cfg_table = cfg_root + "table/";
			cfg_action = cfg_root + "action/";
			cfg_actionImages = cfg_action + "actionImages/";
			cfg_actionSwf = cfg_action + "actionSwf/";
			cfg_actionXML = cfg_action + "actionXML/";
			cfg_audio = cfg_root + "audio/";
			cfg_audioSource = cfg_audio + "audioSource/";
			cfg_audioXML = cfg_audio + "audioXML/";
			
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
			file_cfg_lib = file_cfg_root + "lib\\";
			file_cfg_data = file_cfg_root + "data\\";
			file_cfg_table = file_cfg_root + "table\\";
			file_cfg_action = file_cfg_root + "action\\";
			file_cfg_actionImages = file_cfg_action + "actionImages\\";
			file_cfg_actionSwf = file_cfg_action + "actionSwf\\";
			file_cfg_actionXML = file_cfg_action + "actionXML\\";
			file_cfg_audio = file_cfg_root + "audio\\";
			file_cfg_audioSource = file_cfg_audio + "audioSource\\";
			file_cfg_audioXML = file_cfg_audio + "audioXML\\";
			
			file_cfg_data_setting = file_cfg_data + "setting.xml";
			file_cfg_data_role = file_cfg_data + "role.txt";
			file_cfg_data_action = file_cfg_data + "action.txt";
			file_cfg_data_sound = file_cfg_data + "sound.txt";
			file_cfg_data_skill = file_cfg_data + "skill.txt";
			file_cfg_data_roleType = file_cfg_data + "roleType.txt";
			file_cfg_data_actionType = file_cfg_data + "actionType.txt";
			
			file_cfg_table_role = file_cfg_table + "RoleResTemple.txt";
			file_cfg_table_action = file_cfg_table + "ActionResTemple.txt";
			file_cfg_table_sound = file_cfg_table + "SoundResTemple.txt";
			file_cfg_table_skill = file_cfg_table + "SkillResTemple.txt";
			
			PRELOAD_FILES = new <ResItem>[
				new ResItem(cfg_uiswf + "comp.swf", "comp")
			];
		}
		
		public static function initializeOutput():void {
			file_output_assets = new File(File.applicationDirectory.nativePath).resolvePath(outputPath + "\\res\\zh_CN\\assets\\").nativePath + "\\";
			file_output_audio = file_output_assets + "audio\\";
			file_output_action = file_output_assets + "action\\";
		}
	}
}