package com.canaan.programEditor.view
{
	import com.canaan.lib.component.controls.TextInput;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.utils.StringUtil;
	import com.canaan.programEditor.core.DataCenter;
	import com.canaan.programEditor.event.GlobalEvent;
	import com.canaan.programEditor.ui.SettingDialogUI;
	import com.canaan.programEditor.view.common.Alert;
	
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
			
			tab.selectHandler = viewStack.setIndexHandler;
			btnAccept.clickHandler = new Method(onAccept);
			
			btnTableInput.clickHandler = new Method(selectFile, [txtTableInput, "选择数据导入目录"]);
			btnSettingInput.clickHandler = new Method(selectFile, [txtSettingInput, "选择Setting数据导入目录"]);
			btnTableOutputServer.clickHandler = new Method(selectFile, [txtTableOutputServer, "选择服务器数据导出目录"]);
			btnTableOutputClient.clickHandler = new Method(selectFile, [txtTableOutputClient, "选择服务器数据导出目录"]);
			btnTableOutputSetting.clickHandler = new Method(selectFile, [txtTableOutputSetting, "选择Setting数据导出目录"]);
			
			btnTempleOutputServer.clickHandler = new Method(selectFile, [txtTempleOutputServer, "选择服务器模板导出目录"]);
			btnTempleOutputClient.clickHandler = new Method(selectFile, [txtTempleOutputClient, "选择客户端模板导出目录"]);
			
			btnEnumOutputServer.clickHandler = new Method(selectFile, [txtEnumOutputServer, "选择服务器枚举导出目录"]);
			btnEnumOutputClient.clickHandler = new Method(selectFile, [txtEnumOutputClient, "选择客户端枚举导出目录"]);
			
			btnProtocolOutputServer.clickHandler = new Method(selectFile, [txtProtocolOutputServer, "选择服务器协议导出目录"]);
			btnProtocolOutputClient.clickHandler = new Method(selectFile, [txtProtocolOutputClient, "选择客户端协议导出目录"]);
			
			txtTableInput.text = DataCenter.tableInputTablePath;
			txtSettingInput.text = DataCenter.tableInputSettingPath;
			txtTableOutputServer.text = DataCenter.tableOutputServerPath;
			txtTableOutputClient.text = DataCenter.tableOutputClientPath;
			txtTableOutputSetting.text = DataCenter.tableOutputSettingPath;
			
			txtTempleOutputServer.text = DataCenter.templeOutputServerPath;
			txtTempleOutputClient.text = DataCenter.templeOutputClientPath;
			txtTempleServerNameSpace.text = DataCenter.templeOutputServerNameSpace;
			txtTempleServerImport.text = DataCenter.templeOutputServerImport;
			txtTempleClientImport.text = DataCenter.templeOutputClientImport;
			
			txtEnumOutputServer.text = DataCenter.enumOutputServerPath;
			txtEnumOutputClient.text = DataCenter.enumOutputClientPath;
			txtEnumServerNameSpace.text = DataCenter.enumOutputServerNameSpace;
			txtEnumServerImport.text = DataCenter.enumOutputServerImport;
			txtEnumClientImport.text = DataCenter.enumOutputClientImport;
			
			txtProtocolOutputServer.text = DataCenter.protocolOutputServerPath;
			txtProtocolOutputClient.text = DataCenter.protocolOutputClientPath;
			txtProtocolServerNameSpace.text = DataCenter.protocolOutputServerNameSpace;
			txtProtocolServerImport.text = DataCenter.protocolOutputServerImport;
			txtProtocolClientImport.text = DataCenter.protocolOutputClientImport;
		}
		
		private function selectFile(textInput:TextInput, title:String = ""):void {
			var file:File = File.applicationDirectory;
			file.browseForDirectory(title);
			var selectFunc:Function = function():void {
				file.removeEventListener(Event.SELECT, selectFunc);
				var appFile:File = new File(File.applicationDirectory.nativePath);
				textInput.text = appFile.getRelativePath(file, true);
			};
			file.addEventListener(Event.SELECT, selectFunc);
		}
		
		private function onAccept():void {
			DataCenter.tableInputTablePath = StringUtil.trim(txtTableInput.text);
			DataCenter.tableInputSettingPath = StringUtil.trim(txtSettingInput.text);
			DataCenter.tableOutputServerPath = StringUtil.trim(txtTableOutputServer.text);
			DataCenter.tableOutputClientPath = StringUtil.trim(txtTableOutputClient.text);
			DataCenter.tableOutputSettingPath = StringUtil.trim(txtTableOutputSetting.text);
			
			DataCenter.templeOutputServerPath = StringUtil.trim(txtTempleOutputServer.text);
			DataCenter.templeOutputClientPath = StringUtil.trim(txtTempleOutputClient.text);
			DataCenter.templeOutputServerNameSpace = StringUtil.trim(txtTempleServerNameSpace.text);
			DataCenter.templeOutputServerImport = StringUtil.trim(txtTempleServerImport.text);
			DataCenter.templeOutputClientImport = StringUtil.trim(txtTempleClientImport.text);
			
			DataCenter.enumOutputServerPath = StringUtil.trim(txtEnumOutputServer.text);
			DataCenter.enumOutputClientPath = StringUtil.trim(txtEnumOutputClient.text);
			DataCenter.enumOutputServerNameSpace = StringUtil.trim(txtEnumServerNameSpace.text);
			DataCenter.enumOutputServerImport = StringUtil.trim(txtEnumServerImport.text);
			DataCenter.enumOutputClientImport = StringUtil.trim(txtEnumClientImport.text);
			
			DataCenter.protocolOutputServerPath = StringUtil.trim(txtProtocolOutputServer.text);
			DataCenter.protocolOutputClientPath = StringUtil.trim(txtProtocolOutputClient.text);
			DataCenter.protocolOutputServerNameSpace = StringUtil.trim(txtProtocolServerNameSpace.text);
			DataCenter.protocolOutputServerImport = StringUtil.trim(txtProtocolServerImport.text);
			DataCenter.protocolOutputClientImport = StringUtil.trim(txtProtocolClientImport.text);
			
			DataCenter.saveSetting();
			
			Alert.show("保存成功！");
			EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.REFRESH_PATH));
			close();
		}
		
		override public function close(type:String=null):void {
			super.close(type);
			dispose();
		}
	}
}