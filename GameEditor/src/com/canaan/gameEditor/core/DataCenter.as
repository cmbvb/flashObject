package com.canaan.gameEditor.core
{
	import com.canaan.gameEditor.cfg.ActionResConfigVo;
	import com.canaan.gameEditor.cfg.ActionTypeConfigVo;
	import com.canaan.gameEditor.cfg.RoleResConfigVo;
	import com.canaan.gameEditor.cfg.RoleTypeConfigVo;
	import com.canaan.gameEditor.cfg.SkillResConfigVo;
	import com.canaan.gameEditor.cfg.SoundResConfigVo;
	import com.canaan.gameEditor.contants.TypeRoleAction;
	import com.canaan.gameEditor.contants.TypeRoleType;
	import com.canaan.gameEditor.contants.TypeSound;
	import com.canaan.gameEditor.utils.TableUtil;
	import com.canaan.lib.core.SysConfig;
	import com.canaan.lib.utils.XLSUtil;
	
	import flash.filesystem.File;
	import flash.utils.Dictionary;

	public class DataCenter
	{
		public function DataCenter()
		{
		}
		
		public static function initialize():void {
			readSetting();
			readAllTableCfgs();
		}
		
		public static function release():void {
			// 发布action
			var actionPath:String = GameResPath.outputPath + "\\res\\zh_CN\\assets\\action";
			var actionFile:File = new File(File.applicationDirectory.nativePath).resolvePath(actionPath);
//			FileHelper.copyChildren(GameResPath.file_action, actionFile.nativePath);
			// 发布音频
			var audioPath:String = GameResPath.outputPath + "\\res\\zh_CN\\assets\\audio";
			var audioFile:File = new File(File.applicationDirectory.nativePath).resolvePath(audioPath);
//			FileHelper.copyChildren(GameResPath.file_audio, audioFile.nativePath);
			// 发布表
			var tableFile:File = new File(File.applicationDirectory.nativePath).resolvePath(GameResPath.tablePath);
			FileHelper.copyChildren(GameResPath.file_cfg_table, tableFile.nativePath);
		}
		
		public static function readSetting():void {
			var xmlSetting:XML = FileHelper.readXML(GameResPath.file_cfg_data_setting);
			if (xmlSetting == null) {
				GameResPath.outputPath = "output";
				GameResPath.tablePath = "table";
				saveSetting();
			} else {
				GameResPath.outputPath = xmlSetting.outputFolder.@path.toString();
				GameResPath.tablePath = xmlSetting.tableFolder.@path.toString();
			}
			GameResPath.initializeOutput();
		}
		
		public static function saveSetting():void {
			var xmlSetting:XML = <setting/>;
			xmlSetting.appendChild(<outputFolder path={GameResPath.outputPath}/>);
			xmlSetting.appendChild(<tableFolder path={GameResPath.tablePath}/>);
			FileHelper.saveXML(GameResPath.file_cfg_data_setting, xmlSetting);
		}
		
		public static function readAllTableCfgs():void {
			SysConfig.setVoPackage("com.canaan.gameEditor.cfg.");
			
			// 角色表
			var xlsRole:String = FileHelper.readText(GameResPath.file_cfg_data_role);
			if (xlsRole == null) {
				saveRoleTableCfg();
				xlsRole = FileHelper.readText(GameResPath.file_cfg_data_role);
			}
			// 角色类型表
			var xlsRoleType:String = FileHelper.readText(GameResPath.file_cfg_data_roleType);
			if (xlsRoleType == null) {
				addRoleConfig(TypeRoleType.ROLE, "人物");
				addRoleConfig(TypeRoleType.NPC, "NPC");
				addRoleConfig(TypeRoleType.MONSTER, "怪物");
				addRoleConfig(TypeRoleType.WEAPON, "武器");
				addRoleConfig(TypeRoleType.WING, "翅膀");
				addRoleConfig(TypeRoleType.SHIELD, "盾牌");
				addRoleConfig(TypeRoleType.SKILL_RELEASE, "技能自身特效");
				addRoleConfig(TypeRoleType.SKILL_DIRECTION, "技能8方向特效");
				addRoleConfig(TypeRoleType.SKILL_MISSILE, "技能飞行特效");
				addRoleConfig(TypeRoleType.SKILL_MISSILE_HIT, "技能撞击特效");
				addRoleConfig(TypeRoleType.BUFF, "BUFF");
				saveRoleTypeTableCfg();
				xlsRoleType = FileHelper.readText(GameResPath.file_cfg_data_roleType);
			}
			// 动作类型表
			var xlsActionType:String = FileHelper.readText(GameResPath.file_cfg_data_actionType);
			if (xlsActionType == null) {
				addActionConfig(TypeRoleAction.IDLE, "待机");
				addActionConfig(TypeRoleAction.WALK, "走路");
				addActionConfig(TypeRoleAction.RUN, "跑步");
				addActionConfig(TypeRoleAction.ATTACK, "攻击");
				addActionConfig(TypeRoleAction.SKILL, "施法");
				addActionConfig(TypeRoleAction.BE_ATTACK, "受伤");
				addActionConfig(TypeRoleAction.DEAD, "死亡");
				addActionConfig(TypeRoleAction.PREPARE, "备战");
				addActionConfig(TypeRoleAction.COLLECT, "采集");
				addActionConfig(TypeRoleAction.MEDITATION, "打坐");
				addActionConfig(TypeRoleAction.CRIT, "暴击");
				saveActionTypeTableCfg();
				xlsActionType = FileHelper.readText(GameResPath.file_cfg_data_actionType);
			}
			// 动作表
			var xlsAction:String = FileHelper.readText(GameResPath.file_cfg_data_action);
			if (xlsAction == null) {
				saveActionTableCfg();
				xlsAction = FileHelper.readText(GameResPath.file_cfg_data_action);
			}
			// 声音表
			var xlsSound:String = FileHelper.readText(GameResPath.file_cfg_data_sound);
			if (xlsSound == null) {
				saveSoundTableCfg();
				xlsSound = FileHelper.readText(GameResPath.file_cfg_data_sound);
			}
			// 技能表
			var xlsSkill:String = FileHelper.readText(GameResPath.file_cfg_data_skill);
			if (xlsSkill == null) {
				saveSkillTableCfg();
				xlsSkill = FileHelper.readText(GameResPath.file_cfg_data_skill);
			}
			
			var configObj:Object = {};
			configObj[GameRes.TBL_ROLE_RES] = XLSUtil.XLSToObject(xlsRole);
			configObj[GameRes.TBL_ROLE_TYPE] = XLSUtil.XLSToObject(xlsRoleType);
			configObj[GameRes.TBL_ACTION_TYPE] = XLSUtil.XLSToObject(xlsActionType);
			configObj[GameRes.TBL_ACTION_RES] = XLSUtil.XLSToObject(xlsAction);
			configObj[GameRes.TBL_SOUND_RES] = XLSUtil.XLSToObject(xlsSound);
			configObj[GameRes.TBL_SKILL_RES] = XLSUtil.XLSToObject(xlsSkill);
			SysConfig.initialize(configObj);
		}
		
		public static function saveTable(tableId:String, titles:Array, path:String):void {
			var array:Array = [];
			var configs:Dictionary = SysConfig.getConfig(tableId);
			for each (var config:Object in configs) {
				array.push(config.cfgData);
			}
			var XLSString:String = XLSUtil.ArrayToXLS(titles, array);
			FileHelper.saveText(path, XLSString);
		}
		
		public static function saveOutputTable(tableId:String, desc:Array, titles:Array, types:Array, path:String):void {
			var array:Array = [];
			var configs:Dictionary = SysConfig.getConfig(tableId);
			for each (var config:Object in configs) {
				array.push(config.cfgData);
			}
			var XLSString:String = TableUtil.ArrayToXLS(desc, titles, types, array);
			FileHelper.saveText(path, XLSString);
		}
		
		private static function addRoleConfig(id:int, name:String):void {
			var config:RoleTypeConfigVo = new RoleTypeConfigVo();
			config.id = id;
			config.name = name;
			SysConfig.addConfigVo(GameRes.TBL_ROLE_TYPE, id, config);
		}
		
		private static function addActionConfig(id:int, name:String):void {
			var config:ActionTypeConfigVo = new ActionTypeConfigVo();
			config.id = id;
			config.name = name;
			SysConfig.addConfigVo(GameRes.TBL_ACTION_TYPE, id, config);
		}
		
		public static function saveRoleTableCfg():void {
			saveTable(GameRes.TBL_ROLE_RES, RoleResConfigVo.TITLES, GameResPath.file_cfg_data_role);
			saveOutputTable(GameRes.TBL_ROLE_RES, RoleResConfigVo.OUTPUT_DESC, RoleResConfigVo.OUTPUT_TITLES, RoleResConfigVo.OUTPUT_TYPE, GameResPath.file_cfg_table_role);
		}
		
		public static function saveRoleTypeTableCfg():void {
			saveTable(GameRes.TBL_ROLE_TYPE, RoleTypeConfigVo.TITLES, GameResPath.file_cfg_data_roleType);
		}
		
		public static function saveActionTableCfg():void {
			saveTable(GameRes.TBL_ACTION_RES, ActionResConfigVo.TITLES, GameResPath.file_cfg_data_action);
			saveOutputTable(GameRes.TBL_ACTION_RES, ActionResConfigVo.OUTPUT_DESC, ActionResConfigVo.OUTPUT_TITLES, ActionResConfigVo.OUTPUT_TYPE, GameResPath.file_cfg_table_action);
		}
		
		public static function saveActionTypeTableCfg():void {
			saveTable(GameRes.TBL_ACTION_TYPE, ActionTypeConfigVo.TITLES, GameResPath.file_cfg_data_actionType);
		}
		
		public static function saveSoundTableCfg():void {
			saveTable(GameRes.TBL_SOUND_RES, SoundResConfigVo.TITLES, GameResPath.file_cfg_data_sound);
			saveOutputTable(GameRes.TBL_SOUND_RES, SoundResConfigVo.OUTPUT_DESC, SoundResConfigVo.OUTPUT_TITLES, SoundResConfigVo.OUTPUT_TYPE, GameResPath.file_cfg_table_sound);
		}
		
		public static function saveSkillTableCfg():void {
			saveTable(GameRes.TBL_SKILL_RES, SkillResConfigVo.TITLES, GameResPath.file_cfg_data_skill);
			saveOutputTable(GameRes.TBL_SKILL_RES, SkillResConfigVo.OUTPUT_DESC, SkillResConfigVo.OUTPUT_TITLES, SkillResConfigVo.OUTPUT_TYPE, GameResPath.file_cfg_table_skill);
		}
		
		/**
		 * 删除音频资源
		 * @param soundId
		 * 
		 */		
		public static function deleteSound(soundId:int):void {
			var soundConfig:SoundResConfigVo = SysConfig.getConfigVo(GameRes.TBL_SOUND_RES, soundId) as SoundResConfigVo;
			if (soundConfig != null) {
				SysConfig.removeConfigVo(GameRes.TBL_SOUND_RES, soundId);
				FileHelper.deleteFile(GameResPath.file_cfg_audioSource + soundConfig.fileName);
				if (soundConfig.type == TypeSound.MUSIC) {
					FileHelper.deleteFile(GameResPath.file_output_audio + "music\\" + soundConfig.id + ".mp3");
				} else {
					FileHelper.deleteFile(GameResPath.file_cfg_audioXML + soundConfig.fileName + ".xml");
					FileHelper.deleteFile(GameResPath.file_output_audio + "effect\\" + soundConfig.id + ".swf");
				}
			}
			saveSoundTableCfg();
		}
		
		/**
		 * 删除角色资源
		 * @param roleId
		 * 
		 */		
		public static function deleteRole(roleId:int):void {
			var roleConfig:RoleResConfigVo = SysConfig.getConfigVo(GameRes.TBL_ROLE_RES, roleId) as RoleResConfigVo;
			if (roleConfig != null) {
				for each (var actionConfig:ActionResConfigVo in roleConfig.actionConfigs) {
					SysConfig.removeConfigVo(GameRes.TBL_ACTION_RES, actionConfig.id);
				}
				SysConfig.removeConfigVo(GameRes.TBL_ROLE_RES, roleId);
				FileHelper.deleteFile(GameResPath.file_cfg_actionImages + roleConfig.id);
				FileHelper.deleteFile(GameResPath.file_cfg_actionSwf + roleConfig.id);
				FileHelper.deleteFile(GameResPath.file_cfg_actionXML + roleConfig.id);
				FileHelper.deleteFile(GameResPath.file_action + roleConfig.type + "\\" + roleConfig.id);
				FileHelper.deleteFile(GameResPath.file_output_action + roleConfig.type + "\\" + roleConfig.id);
			}
			saveRoleTableCfg();
			saveActionTableCfg();
		}
		
		/**
		 * 删除角色类型
		 * @param typeId
		 * 
		 */		
		public static function deleteRoleType(typeId:int):void {
			SysConfig.removeConfigVo(GameRes.TBL_ROLE_TYPE, typeId);
			saveRoleTypeTableCfg();
		}
		
		/**
		 * 删除动作类型
		 * @param typeId
		 * 
		 */
		public static function deleteActionType(typeId:int):void {
			SysConfig.removeConfigVo(GameRes.TBL_ACTION_TYPE, typeId);
			saveActionTypeTableCfg();
		}
		
		/**
		 * 删除技能
		 * @param skillId
		 * 
		 */		
		public static function deleteSkill(skillId:int):void {
			SysConfig.removeConfigVo(GameRes.TBL_SKILL_RES, skillId);
			saveSkillTableCfg();
		}
	}
}