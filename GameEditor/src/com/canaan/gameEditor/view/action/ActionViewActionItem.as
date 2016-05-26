package com.canaan.gameEditor.view.action
{
	import com.canaan.gameEditor.cfg.ActionResConfigVo;
	import com.canaan.gameEditor.core.GameResPath;
	import com.canaan.gameEditor.ui.action.ActionViewActionItemUI;
	import com.canaan.lib.role.constants.TypeRoleDirection;
	
	public class ActionViewActionItem extends ActionViewActionItemUI
	{
		private var mConfig:ActionResConfigVo;
		
		public function ActionViewActionItem()
		{
			super();
		}
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mConfig = value as ActionResConfigVo;
			lblAction.text = mConfig.actionTypeConfig.showText; 
			var imgUrl:String = GameResPath.cfg_actionImages + mConfig.roleResId + "/" + mConfig.actionId + "/" + TypeRoleDirection.DOWN + "/0000.png?" + Math.random();
			imgPreview.url = imgUrl;
		}
	}
}