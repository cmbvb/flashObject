package com.canaan.programEditor.view.protocol
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.utils.ArrayUtil;
	import com.canaan.lib.utils.StringUtil;
	import com.canaan.programEditor.core.DataCenter;
	import com.canaan.programEditor.data.ProtocolPackageVo;
	import com.canaan.programEditor.event.GlobalEvent;
	import com.canaan.programEditor.ui.protocol.ProtocolPackageCreateDialogUI;
	import com.canaan.programEditor.view.common.Alert;
	
	public class ProtocolPackageCreateDialog extends ProtocolPackageCreateDialogUI
	{
		private var mProtocolPackageVo:ProtocolPackageVo;
		
		public function ProtocolPackageCreateDialog()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			btnAccept.clickHandler = new Method(onAccept);
		}
		
		public function show(protocolPackageVo:ProtocolPackageVo):void {
			mProtocolPackageVo = protocolPackageVo;
			txtName.text = protocolPackageVo.name;
		}
		
		private function onAccept():void {
			var name:String = StringUtil.trim(txtName.text);
			if (mProtocolPackageVo) {
				if (mProtocolPackageVo.name != name && ArrayUtil.find(DataCenter.protocolPackages, "name", name) != null) {
					Alert.show("目录已存在");
					return;
				}
				
				mProtocolPackageVo.name = name;
				
				Alert.show("修改成功！");
				EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.PROTOCOL_VIEW_REFRESH_LIST));
				close();
			} else {
				if (ArrayUtil.find(DataCenter.protocolPackages, "name", name) != null) {
					Alert.show("目录已存在");
					return;
				}
				
				var protocolPackageVo:ProtocolPackageVo = new ProtocolPackageVo();
				protocolPackageVo.name = name;
				DataCenter.protocolPackages.push(protocolPackageVo);
				
				Alert.show("创建成功！");
				EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.PROTOCOL_VIEW_REFRESH_LIST));
				close();
			}
		}
		
		override public function close(type:String=null):void {
			super.close(type);
			dispose();
		}
	}
}