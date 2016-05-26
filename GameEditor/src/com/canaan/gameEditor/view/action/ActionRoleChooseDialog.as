package com.canaan.gameEditor.view.action
{
	import com.canaan.gameEditor.cfg.ActionResConfigVo;
	import com.canaan.gameEditor.cfg.RoleResConfigVo;
	import com.canaan.gameEditor.cfg.RoleTypeConfigVo;
	import com.canaan.gameEditor.core.FileHelper;
	import com.canaan.gameEditor.core.GameRes;
	import com.canaan.gameEditor.core.GameResPath;
	import com.canaan.gameEditor.event.GlobalEvent;
	import com.canaan.gameEditor.ui.action.ActionRoleChooseDialogUI;
	import com.canaan.gameEditor.view.common.Alert;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.core.SysConfig;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.role.constants.TypeRoleDirection;
	import com.canaan.lib.utils.ObjectUtil;
	import com.canaan.lib.utils.StringUtil;
	
	import flash.events.Event;
	
	public class ActionRoleChooseDialog extends ActionRoleChooseDialogUI
	{
		private var mFilterKeywords:String;
		private var previewImage:ActionEditPreview;
		private var mRoleTypeArray:Array;
		
		public function ActionRoleChooseDialog()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			btnAccept.clickHandler = new Method(onAccept);
			listRoles.selectHandler = new Method(onRoleSelect);
			cboRoleType.selectHandler = new Method(onRoleTypeSelect);
			txtSearch.addEventListener(Event.CHANGE, onTextChange);
			
			previewImage = new ActionEditPreview(220, 300);
			panelPreview.addChild(previewImage);
			
			initialRoleType();
			refreshList();
		}
		
		public function showType(type:int):void {
			for (var i:int = 0; i < mRoleTypeArray.length; i++) {
				var roleTypeConfig:RoleTypeConfigVo = mRoleTypeArray[i];
				if (roleTypeConfig.id == type) {
					cboRoleType.selectedIndex = i;
				}
			}
		}
		
		/**
		 * 初始化角色类型
		 * 
		 */		
		private function initialRoleType():void {
			mRoleTypeArray = ObjectUtil.objectToArray(SysConfig.getConfig(GameRes.TBL_ROLE_TYPE));
			mRoleTypeArray.sortOn("id", Array.NUMERIC);
			
			var labelArray:Array = [];
			for each (var roleTypeConfig:RoleTypeConfigVo in mRoleTypeArray) {
				labelArray.push(roleTypeConfig.showText);
			}
			cboRoleType.labels = labelArray.join(",");
			cboRoleType.selectedIndex = 0;
		}
		
		private function onAccept():void {
			var roleConfig:RoleResConfigVo = listRoles.selectedItem as RoleResConfigVo;
			if (roleConfig == null) {
				Alert.show("未选择角色！");
				return;
			}
			EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.ACTION_CHOOSE_COMPLETE, roleConfig));
			close();
		}
		
		private function onRoleSelect(index:int):void {
			var roleConfig:RoleResConfigVo = listRoles.selectedItem as RoleResConfigVo;
			var acrionConfig:ActionResConfigVo;
			for (var actionId:int in roleConfig.actionConfigs) {
				acrionConfig = roleConfig.actionConfigs[actionId];
				break;
			}
			var imageUrl:String = GameResPath.cfg_actionImages + roleConfig.id + "/" + acrionConfig.actionId + "/" + TypeRoleDirection.DOWN + "/0000.png";
			var xmlPath:String = GameResPath.file_cfg_actionXML + roleConfig.id + "\\" + acrionConfig.actionId + "\\" + TypeRoleDirection.DOWN + ".xml";
			var xml:XML = FileHelper.readXML(xmlPath).children()[0];
			var anchorX:int = int(xml.@x);
			var anchorY:int = int(xml.@y);
			previewImage.showImage(imageUrl, anchorX, anchorY);
		}
		
		private function onRoleTypeSelect(index:int):void {
			refreshList();
		}
		
		private function onTextChange(event:Event):void {
			mFilterKeywords = StringUtil.trim(txtSearch.text);
			refreshList();
		}
		
		private function refreshList():void {
			var roleList:Array = ObjectUtil.objectToArray(SysConfig.getConfig(GameRes.TBL_ROLE_RES));
			roleList = roleList.filter(filterFunc);
			roleList.sort(sortFunc);
			listRoles.array = roleList;
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
		
		override public function close(type:String=null):void {
			super.close(type);
			txtSearch.removeEventListener(Event.CHANGE, onTextChange);
			dispose();
		}
	}
}