package com.canaan.mapEditor.view
{
	import com.canaan.lib.core.Method;
	import com.canaan.mapEditor.core.DataCenter;
	import com.canaan.mapEditor.core.GameResPath;
	import com.canaan.mapEditor.ui.SettingDialogUI;
	import com.canaan.mapEditor.view.common.Alert;
	
	import flash.events.Event;
	import flash.filesystem.File;
	
	public class SettingDialog extends SettingDialogUI
	{
		public function SettingDialog()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			
			btnSetClient.clickHandler = new Method(onSetClient);
			btnSetServer.clickHandler = new Method(onSetServer);
			btnAccept.clickHandler = new Method(onAccept);
			btnClose.clickHandler = new Method(onClose);
			
			txtClient.text = GameResPath.clientPath;
			txtServer.text = GameResPath.serverPath;
		}
		
		private function onSetClient():void {
			var file:File = File.applicationDirectory;
			file.browseForDirectory("选择客户端目录");
			file.addEventListener(Event.SELECT, onSetClientSelect);
		}
		
		private function onSetServer():void {
			var file:File = File.applicationDirectory;
			file.browseForDirectory("选择服务器目录");
			file.addEventListener(Event.SELECT, onSetServerSelect);
		}
		
		private function onSetClientSelect(event:Event):void {
			var file:File = event.target as File;
			file.removeEventListener(Event.SELECT, onSetClientSelect);
			var appFile:File = new File(File.applicationDirectory.nativePath);
			txtClient.text = appFile.getRelativePath(file, true);
		}
		
		private function onSetServerSelect(event:Event):void {
			var file:File = event.target as File;
			file.removeEventListener(Event.SELECT, onSetServerSelect);
			var appFile:File = new File(File.applicationDirectory.nativePath);
			txtServer.text = appFile.getRelativePath(file, true);
		}
		
		private function onAccept():void {
			if (txtClient.text == "") {
				Alert.show("输出目录不能为空！");
				return;
			}
			GameResPath.clientPath = txtClient.text;
			GameResPath.serverPath = txtServer.text;
			GameResPath.initializeConfig();
			if (MapEditor.intance.loadConfig()) {
				DataCenter.saveSetting();
				close();
				Alert.show("保存成功！");
			}
		}
		
		private function onClose():void {
			if (DataCenter.hasConfig() == false) {
				Alert.show("当前设置下未发现配置文件，请重新设置");
				return;
			}
			close();
		}
	}
}