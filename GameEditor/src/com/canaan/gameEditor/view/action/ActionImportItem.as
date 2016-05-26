package com.canaan.gameEditor.view.action
{
	import com.canaan.gameEditor.data.ActionAnimData;
	import com.canaan.gameEditor.data.ActionAnimSequence;
	import com.canaan.gameEditor.event.GlobalEvent;
	import com.canaan.gameEditor.ui.action.ActionImportItemUI;
	import com.canaan.gameEditor.view.common.Alert;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.role.constants.TypeRoleDirection;
	import com.canaan.lib.utils.ObjectUtil;
	
	import flash.events.MouseEvent;
	
	public class ActionImportItem extends ActionImportItemUI
	{
		private var mAnimData:ActionAnimData;
		
		public function ActionImportItem()
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
			mAnimData = value as ActionAnimData;
			lblAction.text = mAnimData.actionId + "(" + mAnimData.actionTypeConfig.name + ")"; 
			var sequence:ActionAnimSequence;
			if (mAnimData.sequences[TypeRoleDirection.DOWN] != null) {
				sequence = mAnimData.sequences[TypeRoleDirection.DOWN];
			} else {
				var directions:Array = ObjectUtil.objectToArray(mAnimData.sequences);
				directions.sortOn("direction", Array.NUMERIC);
				sequence = mAnimData.sequences[directions[0]];
			}
			imgPreview.bitmapData = sequence.bitmapDatas[0].bitmapData;
		}
		
		private function onDelete():void {
			Alert.show("确定要删除吗？", Alert.TYPE_ACCEPT_CANCEL, new Method(function():void {
				EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.ACTION_RES_DELETE_ACTION, mAnimData));
				EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.ACTION_RES_REFRESH_LIST));
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