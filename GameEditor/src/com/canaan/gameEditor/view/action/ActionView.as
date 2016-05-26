package com.canaan.gameEditor.view.action
{
	import com.canaan.gameEditor.cfg.RoleResConfigVo;
	import com.canaan.gameEditor.cfg.RoleTypeConfigVo;
	import com.canaan.gameEditor.core.ActionHelper;
	import com.canaan.gameEditor.core.DataCenter;
	import com.canaan.gameEditor.core.GameRes;
	import com.canaan.gameEditor.event.GlobalEvent;
	import com.canaan.gameEditor.ui.action.ActionViewUI;
	import com.canaan.gameEditor.view.common.Alert;
	import com.canaan.lib.core.Application;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.core.SysConfig;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.managers.TimerManager;
	import com.canaan.lib.utils.ObjectUtil;
	import com.canaan.lib.utils.StringUtil;
	
	import flash.events.Event;
	
	public class ActionView extends ActionViewUI
	{
		private var mFilterKeywords:String;
		private var mRoleTypeArray:Array;
		
		public function ActionView()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			btnImport.clickHandler = new Method(onImport);
			btnRoleType.clickHandler = new Method(onEditRoleType);
			btnActionType.clickHandler = new Method(onEditActionType);
			btnSaveAll.clickHandler = new Method(onSaveAll);
			listRoles.selectHandler = new Method(onListSelect);
			cboRoleType.selectHandler = new Method(onRoleTypeSelect);
			txtSearch.addEventListener(Event.CHANGE, onTextChange);
			initialRoleType();
			cboRoleType.selectedIndex = 0;
			refreshList();
		}
		
		public function onShow():void {
			EventManager.getInstance().addEventListener(GlobalEvent.ACTION_VIEW_REFRESH_LIST, refreshList);
			EventManager.getInstance().addEventListener(GlobalEvent.ACTION_ROLE_TYPE_REFRESH_LIST, initialRoleType);
			editView.onShow();
		}
		
		public function onHide():void {
			EventManager.getInstance().removeEventListener(GlobalEvent.ACTION_VIEW_REFRESH_LIST, refreshList);
			EventManager.getInstance().removeEventListener(GlobalEvent.ACTION_ROLE_TYPE_REFRESH_LIST, initialRoleType);
			editView.onHide();
		}
		
		/**
		 * 初始化角色类型
		 * 
		 */		
		private function initialRoleType(event:GlobalEvent = null):void {
			mRoleTypeArray = ObjectUtil.objectToArray(SysConfig.getConfig(GameRes.TBL_ROLE_TYPE));
			mRoleTypeArray.sortOn("id", Array.NUMERIC);
			
			var labelArray:Array = [];
			for each (var roleTypeConfig:RoleTypeConfigVo in mRoleTypeArray) {
				labelArray.push(roleTypeConfig.showText);
			}
			var selectedIndex:int = cboRoleType.selectedIndex;
			cboRoleType.labels = labelArray.join(",");
			cboRoleType.selectedIndex = selectedIndex;
		}
		
		private function onImport():void {
			var actionImportDialog:ActionImportDialog = new ActionImportDialog();
			actionImportDialog.showRole(null);
			actionImportDialog.popup(true, true);
		}
		
		private function onEditRoleType():void {
			var roleTypeDialog:ActionRoleTypeDialog = new ActionRoleTypeDialog();
			roleTypeDialog.popup(true, true);
		}
		
		private function onEditActionType():void {
			var actionTypeDialog:ActionActionTypeDialog = new ActionActionTypeDialog();
			actionTypeDialog.popup(true, true);
		}
		
		private function onSaveAll():void {
			Alert.show("正在处理动作资源，请稍等...", Alert.TYPE_OK, null, null, false);
			Application.app.mouseChildren = Application.app.mouseEnabled = false;
			TimerManager.getInstance().doOnce(500, function():void {
				for each (var roleConfig:RoleResConfigVo in SysConfig.getConfig(GameRes.TBL_ROLE_RES)) {
					ActionHelper.saveActions(roleConfig.id);
				}
				DataCenter.saveRoleTableCfg();
				DataCenter.saveActionTableCfg();
				Application.app.mouseChildren = Application.app.mouseEnabled = true;
				Alert.show("保存成功！");
			});
		}
		
		private function onRoleTypeSelect(index:int):void {
			refreshList();
		}
		
		private function onTextChange(event:Event):void {
			mFilterKeywords = StringUtil.trim(txtSearch.text);
			refreshList();
		}
		
		private function onListSelect(index:int):void {
			editView.dataSource = listRoles.selectedItem;
		}
		
		private function refreshList(event:GlobalEvent = null):void {
			var roleList:Array = ObjectUtil.objectToArray(SysConfig.getConfig(GameRes.TBL_ROLE_RES));
			roleList = roleList.filter(filterFunc);
			roleList.sort(sortFunc);
			listRoles.array = roleList;
			onListSelect(listRoles.selectedIndex);
		}
		
		private function filterFunc(element:*, index:int, arr:Array):Boolean {
			var config:RoleResConfigVo = element as RoleResConfigVo;
			if (cboRoleType.selectedIndex != mRoleTypeArray.indexOf(config.typeConfig)) {
				return false;
			}
			if (mFilterKeywords && config.id.toString().indexOf(mFilterKeywords) == -1 && config.desc.indexOf(mFilterKeywords) == -1) {
				return false;
			}
			return true;
		}
		
		private function sortFunc(configA:RoleResConfigVo, configB:RoleResConfigVo):int {
			return configA.id > configB.id ? 1 : -1;
		}
	}
}