package com.canaan.gameEditor.view.action
{
	import com.canaan.gameEditor.cfg.ActionTypeConfigVo;
	import com.canaan.gameEditor.core.DataCenter;
	import com.canaan.gameEditor.core.GameRes;
	import com.canaan.gameEditor.event.GlobalEvent;
	import com.canaan.gameEditor.ui.action.ActionActionTypeDialogUI;
	import com.canaan.gameEditor.view.common.Alert;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.core.SysConfig;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.utils.ObjectUtil;
	import com.canaan.lib.utils.StringUtil;
	
	public class ActionActionTypeDialog extends ActionActionTypeDialogUI
	{
		public function ActionActionTypeDialog()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			btnAdd.clickHandler = new Method(onAddRoleType);
			EventManager.getInstance().addEventListener(GlobalEvent.ACTION_ACTION_TYPE_REFRESH_LIST, resfreshList);
			resfreshList();
		}
		
		private function resfreshList(event:GlobalEvent = null):void {
			var actionTypeList:Array = ObjectUtil.objectToArray(SysConfig.getConfig(GameRes.TBL_ACTION_TYPE));
			actionTypeList.sortOn("id", Array.NUMERIC);
			listActionType.array = actionTypeList;
		}
		
		private function onAddRoleType():void {
			var id:String = StringUtil.trim(txtID.text);
			if (id == "") {
				Alert.show("编号不能为空");
				return;
			}
			if (isNaN(Number(id))) {
				Alert.show("编号必须为数字");
				return;
			}
			var name:String = StringUtil.trim(txtName.text);
			if (name == "") {
				Alert.show("名称不能为空");
				return;
			}
			if (SysConfig.getConfigVo(GameRes.TBL_ROLE_TYPE, id) != null) {
				Alert.show("编号已存在");
				return;
			}
			if (int(id) <= 100) {
				Alert.show("非通用类型为了扩展，请从100以后开始");
				return;
			}
			var config:ActionTypeConfigVo = new ActionTypeConfigVo();
			config.id = int(id);
			config.name = name;
			SysConfig.addConfigVo(GameRes.TBL_ACTION_TYPE, id, config);
			DataCenter.saveActionTypeTableCfg();
			Alert.show("添加成功！");
			
			resfreshList();
		}
		
		override public function close(type:String=null):void {
			super.close(type);
			EventManager.getInstance().removeEventListener(GlobalEvent.ACTION_ACTION_TYPE_REFRESH_LIST, resfreshList);
			dispose();
		}
	}
}