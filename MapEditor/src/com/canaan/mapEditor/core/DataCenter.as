package com.canaan.mapEditor.core
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.core.TableConfig;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.mapEditor.events.GlobalEvent;
	import com.canaan.mapEditor.view.SettingDialog;
	import com.canaan.mapEditor.view.common.Alert;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class DataCenter
	{
		public function DataCenter()
		{
			
		}
		
		public static function initialize():void {
			readSetting();
			if (!FileHelper.isExist(GameResPath.file_map_root)) {
				FileHelper.createDirectory(GameResPath.file_map_root);
			}
		}
		
		public static function readSetting():void {
			var xmlSetting:XML = FileHelper.readXML(GameResPath.file_cfg_data_setting);
			if (xmlSetting == null) {
				GameResPath.clientPath = "client";
				GameResPath.serverPath = "server";
				saveSetting();
			} else {
				GameResPath.clientPath = xmlSetting.clientFolder.@path.toString();
				GameResPath.serverPath = xmlSetting.serverFolder.@path.toString();
			}
			GameResPath.initializeConfig();
		}
		
		public static function saveSetting():void {
			var xmlSetting:XML = <setting/>;
			xmlSetting.appendChild(<clientFolder path={GameResPath.clientPath}/>);
			xmlSetting.appendChild(<serverFolder path={GameResPath.serverPath}/>);
			FileHelper.saveXML(GameResPath.file_cfg_data_setting, xmlSetting);
		}
		
		public static function loadConfig():Boolean {
			var configUrl:String = GameResPath.client_config + "config.byte";
			var configFile:File = new File(File.applicationDirectory.nativePath).resolvePath(configUrl);
			var byte:ByteArray = FileHelper.read(configFile.nativePath);
			if (byte == null) {
				Alert.show("当前设置下未发现配置文件，请重新设置", 1, new Method(function():void {
					var settingDialog:SettingDialog = new SettingDialog();
					settingDialog.popup(true, false);
				}));
				return false;
			}
			byte.uncompress();
			var content:* = byte.readObject();
			TableConfig.initialize(content.config);
			EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.UPDATE_CONFIG));
			return true;
		}
		
		public static function hasConfig():Boolean {
			var configUrl:String = GameResPath.client_config + "config.byte";
			var configFile:File = new File(File.applicationDirectory.nativePath).resolvePath(configUrl);
			return configFile.exists;
		}
	}
}