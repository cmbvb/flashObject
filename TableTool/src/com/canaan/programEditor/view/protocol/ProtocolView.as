package com.canaan.programEditor.view.protocol
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.events.KeyEvent;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.managers.KeyboardManager;
	import com.canaan.lib.managers.RenderManager;
	import com.canaan.lib.utils.StringUtil;
	import com.canaan.programEditor.core.DataCenter;
	import com.canaan.programEditor.data.ProtocolPackageVo;
	import com.canaan.programEditor.data.ProtocolVo;
	import com.canaan.programEditor.event.GlobalEvent;
	import com.canaan.programEditor.ui.protocol.ProtocolViewUI;
	import com.canaan.programEditor.view.common.Alert;
	
	import flash.events.Event;
	import flash.ui.Keyboard;
	
	public class ProtocolView extends ProtocolViewUI
	{
		private var mFilterKeywords:String;
		private var mProtocolPackageVo:ProtocolPackageVo;
		private var mProtocolVo:ProtocolVo;
		
		public function ProtocolView()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			treeProtocols.selectHandler = new Method(onProtocolSelect);
			btnCreateFolder.clickHandler = new Method(onCreateFolder);
			btnChangeFolder.clickHandler = new Method(onChangeFolder);
			btnCreateProtocol.clickHandler = new Method(onCreateProtocol);
			btnSave.clickHandler = new Method(onSave);
			txtSearch.addEventListener(Event.CHANGE, onTextChange);
			
			refreshProtocols();
		}
		
		public function onShow():void {
			EventManager.getInstance().addEventListener(GlobalEvent.PROTOCOL_VIEW_REFRESH_LIST, refreshProtocols);
			KeyboardManager.getInstance().addEventListener(KeyEvent.KEY_DOWN, onKeyDown);
		}
		
		public function onHide():void {
			EventManager.getInstance().removeEventListener(GlobalEvent.PROTOCOL_VIEW_REFRESH_LIST, refreshProtocols);
			KeyboardManager.getInstance().removeEventListener(KeyEvent.KEY_DOWN, onKeyDown);
		}
		
		private function refreshProtocols(event:GlobalEvent = null):void {
			var protocols:Array = [];
			var pkgs:Array = DataCenter.protocolPackages.concat();
			var obj:Object;
			for each (var protocolPackageVo:ProtocolPackageVo in pkgs) {
				obj = {protocolPackage:protocolPackageVo, children:[]};
				protocols.push(obj);
				for each (var protocolVo:ProtocolVo in protocolPackageVo.protocols) {
					if (mFilterKeywords) {
						if (protocolVo.id.toString().indexOf(mFilterKeywords) == -1 && protocolVo.name.toString().indexOf(mFilterKeywords) == -1) {
							continue;
						}
					}
					obj.children.push({protocolPackage:protocolPackageVo, protocol:protocolVo});
				}
			}
			treeProtocols.array = protocols;
			treeProtocols.expandAll();
			RenderManager.getInstance().renderAll();
			mProtocolPackageVo = null;
			mProtocolVo = null;
			txtID.text = "";
			txtName.text = "";
			txtDesc.text = "";
			txtContent.text = "";
		}
		
		private function onProtocolSelect(item:Object):void {
			if (item) {
				mProtocolPackageVo = item.protocolPackage;
				mProtocolVo = item.protocol;
				if (mProtocolVo) {
					txtID.text = mProtocolVo.id.toString();
					txtName.text = mProtocolVo.name;
					txtDesc.text = mProtocolVo.desc;
					txtContent.text = mProtocolVo.content;
				} else {
					txtID.text = "";
					txtName.text = "";
					txtDesc.text = "";
					txtContent.text = "";
				}
			} else {
				mProtocolPackageVo = null;
				mProtocolVo = null;
				txtID.text = "";
				txtName.text = "";
				txtDesc.text = "";
				txtContent.text = "";
			}
		}
		
		private function onCreateFolder():void {
			var dialog:ProtocolPackageCreateDialog = new ProtocolPackageCreateDialog();
			dialog.popup();
		}
		
		private function onChangeFolder():void {
			if (!treeProtocols.selectedItem) {
				Alert.show("未选中协议目录");
				return;
			}
			var dialog:ProtocolPackageCreateDialog = new ProtocolPackageCreateDialog();
			dialog.show(treeProtocols.selectedItem.protocolPackage);
			dialog.popup();
		}
		
		private function onCreateProtocol():void {
			if (!treeProtocols.selectedItem) {
				Alert.show("未选中协议目录");
				return;
			}
			var dialog:ProtocolCreateDialog = new ProtocolCreateDialog();
			dialog.show(treeProtocols.selectedItem.protocolPackage);
			dialog.popup();
		}
		
		private function onKeyDown(event:KeyEvent):void {
			var keyCode:int = event.keyCode;
			var shift:Boolean = event.shiftKey;
			var ctrl:Boolean = event.ctrlKey;
			switch (keyCode) {
				case Keyboard.S:
					if (ctrl) {
						onSave();
					}
					break;
			}
		}
		
		private function onSave():void {
			if (treeProtocols.selectedItem) {
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
				if (mProtocolVo.id != int(id) && !DataCenter.validateProtocolId(int(id))) {
					Alert.show("协议ID已存在");
					return;
				}
				if (mProtocolVo.name != name && !DataCenter.validateProtocolName(name)) {
					Alert.show("协议名已存在");
					return;
				}
				
				var desc:String = StringUtil.trim(txtDesc.text);
				var content:String = StringUtil.trim(txtContent.text);
				
				mProtocolVo.name = name;
				mProtocolVo.id = int(id);
				mProtocolVo.desc = desc;
				mProtocolVo.content = content;
				mProtocolPackageVo.sortProtocols();
			}
			DataCenter.saveProtocols();
			Alert.show("保存成功");
		}
		
		private function onTextChange(event:Event):void {
			mFilterKeywords = StringUtil.trim(txtSearch.text);
			refreshProtocols();
		}
	}
}