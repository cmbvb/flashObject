package com.canaan.gameEditor.view.action
{
	import com.canaan.gameEditor.cfg.ActionResConfigVo;
	import com.canaan.gameEditor.cfg.RoleResConfigVo;
	import com.canaan.gameEditor.cfg.RoleTypeConfigVo;
	import com.canaan.gameEditor.core.ActionHelper;
	import com.canaan.gameEditor.core.ActionImageLoader;
	import com.canaan.gameEditor.core.DataCenter;
	import com.canaan.gameEditor.core.GameRes;
	import com.canaan.gameEditor.data.ActionAnimData;
	import com.canaan.gameEditor.data.ActionAnimSequence;
	import com.canaan.gameEditor.data.ActionRoleData;
	import com.canaan.gameEditor.event.GlobalEvent;
	import com.canaan.gameEditor.ui.action.ActionImportDialogUI;
	import com.canaan.gameEditor.view.common.Alert;
	import com.canaan.lib.core.Application;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.core.SysConfig;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.managers.TimerManager;
	import com.canaan.lib.utils.ObjectUtil;
	import com.canaan.lib.utils.StringUtil;
	
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class ActionImportDialog extends ActionImportDialogUI
	{
		private var mActionRoleData:ActionRoleData;
		private var mActionImageLoader:ActionImageLoader;
		private var mRoleTypeArray:Array;
		
		public function ActionImportDialog()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			mActionImageLoader = new ActionImageLoader();
			
			btnImport.clickHandler = new Method(onImport);
			btnSave.clickHandler = new Method(onSave);
			listActions.selectHandler = new Method(onActionSelect);
			txtQuality.textField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			txtQuality.textField.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			EventManager.getInstance().addEventListener(GlobalEvent.ACTION_RES_LOAD_COMPLETE, onActionResLoadComplete);
			EventManager.getInstance().addEventListener(GlobalEvent.ACTION_RES_DELETE_ACTION, onActionResDeleteAction);
			EventManager.getInstance().addEventListener(GlobalEvent.ACTION_RES_REFRESH_LIST, onActionResRefreshList);
			EventManager.getInstance().addEventListener(GlobalEvent.ACTION_IMAGES_SAVE_COMPLETE, onActionImagesSaveComplete);
			
			initialRoleType();
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
		}
		
		private function onImport():void {
			mActionImageLoader.startLoad();
		}
		
		private function onSave():void {
			var id:String = StringUtil.trim(txtID.text);
			if (id == "") {
				Alert.show("编号不能为空");
				return;
			}
			if (isNaN(Number(id))) {
				Alert.show("编号必须为数字");
				return;
			}
			if (mActionRoleData == null || mActionRoleData.hasActions() == false) {
				Alert.show("未导入图片资源");
				return;
			}
			if (SysConfig.getConfigVo(GameRes.TBL_ROLE_RES, id) != null) {
				Alert.show("编号已存在");
				return;
			}
			if (cboRoleType.selectedIndex == -1) {
				Alert.show("未选择动作类型");
				return;
			}
			Alert.show("正在处理动作资源，请稍等...", Alert.TYPE_OK, null, null, false);
			var quility:int = int(txtQuality.text);
			Application.app.mouseChildren = Application.app.mouseEnabled = false;
			TimerManager.getInstance().doOnce(500, function():void {
				ActionHelper.saveActionImages(mActionRoleData, id, quility);
			});
		}
		
		private function onActionImagesSaveComplete(event:GlobalEvent):void {
			var id:int = int(StringUtil.trim(txtID.text));
			var type:int = mRoleTypeArray[cboRoleType.selectedIndex].id;
			var desc:String = StringUtil.trim(txtDesc.text);
			var roleConfig:RoleResConfigVo = new RoleResConfigVo();
			roleConfig.id = id;
			roleConfig.type = type;
			roleConfig.desc = desc;
			for each (var animData:ActionAnimData in mActionRoleData.actions) {
				var actionConfig:ActionResConfigVo = new ActionResConfigVo();
				actionConfig.id = id + "_" + animData.actionId;
				actionConfig.actionId = animData.actionId;
				actionConfig.roleResId = roleConfig.id;
				var directionsArray:Array = [];
				for each (var sequence:ActionAnimSequence in animData.sequences) {
					actionConfig.maxFrame = sequence.bitmapDatas.length - 1;
					actionConfig.maxAnimFrame = sequence.maxAnimFrame;
					actionConfig.animFrames = sequence.animFrames.join(",");
					directionsArray.push(sequence.direction);
				}
				directionsArray.sort(Array.NUMERIC);
				actionConfig.directions = directionsArray.join(",");
				SysConfig.addConfigVo(GameRes.TBL_ACTION_RES, actionConfig.id, actionConfig);
				roleConfig.actionConfigs[animData.actionId] = actionConfig;
			}
			SysConfig.addConfigVo(GameRes.TBL_ROLE_RES, roleConfig.id, roleConfig);
			
			ActionHelper.saveActions(roleConfig.id);
			DataCenter.saveRoleTableCfg();
			DataCenter.saveActionTableCfg();
			Application.app.mouseChildren = Application.app.mouseEnabled = true;
			Alert.show("添加成功！");
			
			close();
			EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.ACTION_VIEW_REFRESH_LIST));
		}
		
		private function onActionSelect():void {
			preview.dataSource = listActions.selectedItem;
		}
		
		private function onFocusOut(event:FocusEvent):void {
			changeQuality();
		}
		
		private function onKeyDown(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.ENTER) {
				changeQuality();
			}
		}
		
		private function changeQuality():void {
			var quailty:int = int(txtQuality.text);
			quailty = Math.max(1, Math.min(100, quailty));
			txtQuality.text = quailty.toString();
		}
		
		private function onActionResLoadComplete(event:GlobalEvent):void {
			var roleData:ActionRoleData = mActionImageLoader.roleData;
			if (mActionRoleData == null) {
				mActionRoleData = roleData;
			} else {
				mActionRoleData.merge(roleData);
			}
			showRoleInfo();
		}
		
		private function onActionResDeleteAction(event:GlobalEvent):void {
			var animData:ActionAnimData = event.data as ActionAnimData;
			delete mActionRoleData.actions[animData.actionId];
		}
		
		private function onActionResRefreshList(event:GlobalEvent):void {
			showRoleInfo();
		}
		
		public function showRole(roleData:ActionRoleData):void {
			mActionRoleData = roleData;
			showRoleInfo();
		}
		
		private function showRoleInfo():void {
			if (mActionRoleData) {
				txtDesc.text = mActionRoleData.desc;
				var actionList:Array = ObjectUtil.objectToArray(mActionRoleData.actions);
				actionList.sortOn("actionId", Array.NUMERIC);
				listActions.array = actionList;
			} else {
				txtDesc.text = "";
				listActions.array = null;
			}
		}
		
		override public function close(type:String=null):void {
			super.close(type);
			txtQuality.textField.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			txtQuality.textField.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			EventManager.getInstance().removeEventListener(GlobalEvent.ACTION_RES_LOAD_COMPLETE, onActionResLoadComplete);
			EventManager.getInstance().removeEventListener(GlobalEvent.ACTION_RES_DELETE_ACTION, onActionResDeleteAction);
			EventManager.getInstance().removeEventListener(GlobalEvent.ACTION_RES_REFRESH_LIST, onActionResRefreshList);
			EventManager.getInstance().removeEventListener(GlobalEvent.ACTION_IMAGES_SAVE_COMPLETE, onActionImagesSaveComplete);
			dispose();
		}
	}
}