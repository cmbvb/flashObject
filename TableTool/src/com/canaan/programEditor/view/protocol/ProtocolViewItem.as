package com.canaan.programEditor.view.protocol
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.utils.ArrayUtil;
	import com.canaan.programEditor.core.DataCenter;
	import com.canaan.programEditor.data.ProtocolPackageVo;
	import com.canaan.programEditor.data.ProtocolVo;
	import com.canaan.programEditor.event.GlobalEvent;
	import com.canaan.programEditor.ui.protocol.ProtocolViewItemUI;
	import com.canaan.programEditor.view.common.Alert;
	
	import flash.events.MouseEvent;
	
	public class ProtocolViewItem extends ProtocolViewItemUI
	{
		private var mProtocolPackageVo:ProtocolPackageVo;
		private var mProtocolVo:ProtocolVo;
		
		public function ProtocolViewItem()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			btnDelete.visible = false;
			btnDelete.clickHandler = new Method(onDelete);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mProtocolVo = value.protocol as ProtocolVo;
			mProtocolPackageVo = value.protocolPackage as ProtocolPackageVo;
			if (mProtocolVo) {
				imgIcon.url = "png.comp.img_file";
				lblName.text = mProtocolVo.id + "(" + mProtocolVo.name + ")";
			} else {
				imgIcon.url = "png.comp.img_folder";
				lblName.text = mProtocolPackageVo.name;
			}
		}
		
		private function onDelete():void {
			Alert.show("确定要删除吗？", Alert.TYPE_ACCEPT_CANCEL, new Method(function():void {
				if (mProtocolVo) {
					ArrayUtil.removeElements(mProtocolPackageVo.protocols, mProtocolVo);
				} else {
					DataCenter.deleteProtocols(mProtocolPackageVo);
				}
				EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.PROTOCOL_VIEW_REFRESH_LIST));
			}));
		}
		
		private function onMouseOver(event:MouseEvent):void {
			btnDelete.visible = true;
		}
		
		private function onMouseOut(event:MouseEvent):void {
			btnDelete.visible = false;
		}
		
		override public function dispose():void {
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			super.dispose();
		}
	}
}