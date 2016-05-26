package com.canaan.gameEditor.view
{
	import com.canaan.gameEditor.core.DataCenter;
	import com.canaan.gameEditor.core.GameResPath;
	import com.canaan.gameEditor.ui.SettingDialogUI;
	import com.canaan.gameEditor.view.common.Alert;
	import com.canaan.lib.core.Method;
	
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
			
			btnSetOutput.clickHandler = new Method(onSetOutput);
			btnSetTable.clickHandler = new Method(onSetTable);
			btnAccept.clickHandler = new Method(onAccept);
			
			txtOutput.text = GameResPath.outputPath;
			txtTable.text = GameResPath.tablePath;
		}
		
		private function onSetOutput():void {
			var file:File = File.applicationDirectory;
			file.browseForDirectory("选择资源导出目录");
			file.addEventListener(Event.SELECT, onOutputSelect);
		}
		
		private function onSetTable():void {
			var file:File = File.applicationDirectory;
			file.browseForDirectory("选择数据导出目录");
			file.addEventListener(Event.SELECT, onTableSelect);
		}
		
		private function onOutputSelect(event:Event):void {
			var file:File = event.target as File;
			file.removeEventListener(Event.SELECT, onOutputSelect);
			var appFile:File = new File(File.applicationDirectory.nativePath);
			txtOutput.text = appFile.getRelativePath(file, true);
		}
		
		private function onTableSelect(event:Event):void {
			var file:File = event.target as File;
			file.removeEventListener(Event.SELECT, onTableSelect);
			var appFile:File = new File(File.applicationDirectory.nativePath);
			txtTable.text = appFile.getRelativePath(file, true);
		}
		
		private function onAccept():void {
			if (txtOutput.text == "") {
				Alert.show("输出目录不能为空！");
				return;
			}
			GameResPath.outputPath = txtOutput.text;
			GameResPath.tablePath = txtTable.text;
			GameResPath.initializeOutput();
			DataCenter.saveSetting();
			Alert.show("保存成功！");
			close();
		}
		
		override public function close(type:String=null):void {
			super.close(type);
			dispose();
		}
	}
}