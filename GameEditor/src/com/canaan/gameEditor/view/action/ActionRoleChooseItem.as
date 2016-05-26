package com.canaan.gameEditor.view.action
{
	import com.canaan.gameEditor.cfg.RoleResConfigVo;
	import com.canaan.gameEditor.ui.action.ActionRoleChooseItemUI;
	
	public class ActionRoleChooseItem extends ActionRoleChooseItemUI
	{
		private var mConfig:RoleResConfigVo;
		
		public function ActionRoleChooseItem()
		{
			super();
		}
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mConfig = value as RoleResConfigVo;
			lblRole.text = mConfig.showText;
		}
	}
}