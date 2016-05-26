package com.canaan.programEditor.view.enum
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.programEditor.core.DataCenter;
	import com.canaan.programEditor.data.EnumVo;
	import com.canaan.programEditor.event.GlobalEvent;
	import com.canaan.programEditor.ui.enum.EnumViewItemUI;
	import com.canaan.programEditor.view.common.Alert;
	
	import flash.events.MouseEvent;
	
	public class EnumViewItem extends EnumViewItemUI
	{
		private var mEnumVo:EnumVo;
		
		public function EnumViewItem()
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
			mEnumVo = value as EnumVo;
			lblEnumName.text = mEnumVo.name;
		}
		
		private function onDelete():void {
			Alert.show("确定要删除吗？", Alert.TYPE_ACCEPT_CANCEL, new Method(function():void {
				DataCenter.deleteEnum(mEnumVo);
				EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.ENUM_VIEW_REFRESH_LIST));
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