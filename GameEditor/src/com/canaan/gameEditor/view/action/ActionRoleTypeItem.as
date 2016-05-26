package com.canaan.gameEditor.view.action
{
	import com.canaan.gameEditor.cfg.RoleTypeConfigVo;
	import com.canaan.gameEditor.core.DataCenter;
	import com.canaan.gameEditor.event.GlobalEvent;
	import com.canaan.gameEditor.ui.action.ActionRoleTypeItemUI;
	import com.canaan.gameEditor.view.common.Alert;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.EventManager;
	
	import flash.events.MouseEvent;
	
	public class ActionRoleTypeItem extends ActionRoleTypeItemUI
	{
		private var mConfig:RoleTypeConfigVo;
		
		public function ActionRoleTypeItem()
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
			mConfig = value as RoleTypeConfigVo;
			lblType.text = mConfig.showText;
		}
		
		private function onDelete():void {
			Alert.show("确定要删除吗？", Alert.TYPE_ACCEPT_CANCEL, new Method(function():void {
				DataCenter.deleteRoleType(mConfig.id);
				EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.ACTION_ROLE_TYPE_REFRESH_LIST));
			}));
		}
		
		private function onMouseOver(event:MouseEvent):void {
			if (mConfig.id != 0) {
				btnDelete.visible = true;
			}
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