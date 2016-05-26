package com.canaan.gameEditor.view.action
{
	import com.canaan.gameEditor.cfg.ActionTypeConfigVo;
	import com.canaan.gameEditor.contants.TypeRoleAction;
	import com.canaan.gameEditor.core.DataCenter;
	import com.canaan.gameEditor.event.GlobalEvent;
	import com.canaan.gameEditor.ui.action.ActionActionTypeItemUI;
	import com.canaan.gameEditor.view.common.Alert;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.EventManager;
	
	import flash.events.MouseEvent;
	
	public class ActionActionTypeItem extends ActionActionTypeItemUI
	{
		private var mConfig:ActionTypeConfigVo;
		
		public function ActionActionTypeItem()
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
			mConfig = value as ActionTypeConfigVo;
			lblType.text = mConfig.showText;
		}
		
		private function onDelete():void {
			Alert.show("确定要删除吗？", Alert.TYPE_ACCEPT_CANCEL, new Method(function():void {
				DataCenter.deleteActionType(mConfig.id);
				EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.ACTION_ACTION_TYPE_REFRESH_LIST));
			}));
		}
		
		private function onMouseOver(event:MouseEvent):void {
			if (mConfig.id > TypeRoleAction.CRIT) {
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