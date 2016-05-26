package com.canaan.programEditor.view.protocol
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.utils.StringUtil;
	import com.canaan.programEditor.core.DataCenter;
	import com.canaan.programEditor.data.ProtocolPackageVo;
	import com.canaan.programEditor.data.ProtocolVo;
	import com.canaan.programEditor.event.GlobalEvent;
	import com.canaan.programEditor.ui.protocol.ProtocolCreateDialogUI;
	import com.canaan.programEditor.view.common.Alert;
	
	public class ProtocolCreateDialog extends ProtocolCreateDialogUI
	{
		private var mProtocolPackageVo:ProtocolPackageVo;
		
		public function ProtocolCreateDialog()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			btnAccept.clickHandler = new Method(onAccept);
			txtID.text = DataCenter.getNextProtocolId().toString();
		}
		
		public function show(protocolPackageVo:ProtocolPackageVo):void {
			mProtocolPackageVo = protocolPackageVo;
		}
		
		private function onAccept():void {
			var id:String = StringUtil.trim(txtID.text);
			if (id == "") {
				Alert.show("协议ID不能为空");
				return;
			}
			var name:String = StringUtil.trim(txtName.text);
			if (name == "") {
				Alert.show("协议名称不能为空");
				return;
			}
			if (!DataCenter.validateProtocolId(int(id))) {
				Alert.show("协议ID已存在");
				return;
			}
			if (!DataCenter.validateProtocolName(name)) {
				Alert.show("协议名已存在");
				return;
			}
			
			var desc:String = StringUtil.trim(txtDesc.text);
			var content:String = StringUtil.trim(txtContent.text);
			
			var protocolVo:ProtocolVo = new ProtocolVo();
			protocolVo.name = name;
			protocolVo.id = int(id);
			protocolVo.desc = desc;
			protocolVo.content = content;
			mProtocolPackageVo.protocols.push(protocolVo);
			mProtocolPackageVo.sortProtocols();
			
			Alert.show("创建成功");
			EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.PROTOCOL_VIEW_REFRESH_LIST));
			close();
		}
		
		override public function close(type:String=null):void {
			super.close(type);
			dispose();
		}
	}
}