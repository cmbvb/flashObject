package com.canaan.gameEditor.view.skill
{
	import com.canaan.gameEditor.cfg.ActionResConfigVo;
	import com.canaan.gameEditor.cfg.RoleResConfigVo;
	import com.canaan.gameEditor.cfg.SkillResConfigVo;
	import com.canaan.gameEditor.cfg.SoundResConfigVo;
	import com.canaan.gameEditor.contants.TypeRoleAction;
	import com.canaan.gameEditor.contants.TypeRoleType;
	import com.canaan.gameEditor.core.AudioHelper;
	import com.canaan.gameEditor.core.DataCenter;
	import com.canaan.gameEditor.core.GameRes;
	import com.canaan.gameEditor.event.GlobalEvent;
	import com.canaan.gameEditor.ui.skill.SkillCreateDialogUI;
	import com.canaan.gameEditor.view.action.ActionRoleChooseDialog;
	import com.canaan.gameEditor.view.common.Alert;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.core.SysConfig;
	import com.canaan.lib.events.KeyEvent;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.managers.KeyboardManager;
	import com.canaan.lib.managers.StageManager;
	import com.canaan.lib.managers.TimerManager;
	import com.canaan.lib.role.constants.TypeRoleDirection;
	import com.canaan.lib.utils.MathUtil;
	import com.canaan.lib.utils.ObjectUtil;
	import com.canaan.lib.utils.StringUtil;
	
	import flash.events.Event;
	import flash.ui.Keyboard;
	
	public class SkillCreateDialog extends SkillCreateDialogUI
	{
		private static const POS_X:int = 120;
		private static const POS_Y:int = 300;
		
		private var mConfig:SkillResConfigVo;
		private var mRoleConfig:RoleResConfigVo;
		private var mActionConfig:ActionResConfigVo;
		private var mActions:Array;
		
		private var isEdit:Boolean;
		private var chooseType:int;
		private var chooseFromTimeLine:Boolean;
		
		private var mReleaseConfig:RoleResConfigVo;
		private var mDirectionConfig:RoleResConfigVo;
		private var mMissileConfig:RoleResConfigVo;
		private var mMissileHitConfig:RoleResConfigVo;
		
		private var mRoleLoader:BMPActionLoader;
		private var mTargetLoader:BMPActionLoader;
		private var mReleaseLoader:BMPActionLoader;
		private var mDirectionLoader:BMPActionLoader;
		private var mMissileLoader:BMPActionLoader;
		private var mMissileHitLoader:BMPActionLoader;
		
		public function SkillCreateDialog()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			KeyboardManager.getInstance().addEventListener(KeyEvent.KEY_DOWN, onKeyDown);
			EventManager.getInstance().addEventListener(GlobalEvent.ACTION_CHOOSE_COMPLETE, onRoleChooseComplete);
			btnSave.clickHandler = new Method(onSave);
			btnPlay.clickHandler = new Method(onPlay);
			btnInfoRoleChoose.clickHandler = new Method(chooseRole, [TypeRoleType.ROLE, false]);
			btnRelease.clickHandler = new Method(chooseRole, [TypeRoleType.SKILL_RELEASE, false]);
			btnDirection.clickHandler = new Method(chooseRole, [TypeRoleType.SKILL_DIRECTION, false]);
			btnMissile.clickHandler = new Method(chooseRole, [TypeRoleType.SKILL_MISSILE, false]);
			btnMissileHit.clickHandler = new Method(chooseRole, [TypeRoleType.SKILL_MISSILE_HIT, false]);
			txtRole.addEventListener(Event.CHANGE, onTextChange);
			txtReleaseId.addEventListener(Event.CHANGE, onReleaseIdChange);
			txtDirectionId.addEventListener(Event.CHANGE, onDirectionIdChange);
			txtMissileId.addEventListener(Event.CHANGE, onMissileIdChange);
			txtMissileHitId.addEventListener(Event.CHANGE, onMissileHitIdChange);
			txtReleaseFrame.addEventListener(Event.CHANGE, onReleaseFrameChange);
			txtDirectionFrame.addEventListener(Event.CHANGE, onDirectionFrameChange);
			txtMissileFrame.addEventListener(Event.CHANGE, onMissileFrameChange);
			txtMissileSpeed.addEventListener(Event.CHANGE, onMissileSpeedChange);
			listTimeLine.selectHandler = new Method(onTimeLineSelect);
			listTimeLine.array = null;
			cboMissileType.selectHandler = new Method(onMissileTypeSelect);
			cboMissileType.selectedIndex = 0;
			cboRoleAction.selectHandler = new Method(onActionChange);
			cboRoleAction.labels = null;
			cboRoleAction.disabled = true;
			
			mRoleLoader = new BMPActionLoader();
			mRoleLoader.setPivotXY(POS_X, POS_Y);
			panelDetail.addChild(mRoleLoader);
			mTargetLoader = new BMPActionLoader();
			mTargetLoader.setPivotXY(POS_X + 600, POS_Y);
			panelDetail.addChild(mTargetLoader);
			mReleaseLoader = new BMPActionLoader();
			mReleaseLoader.setPivotXY(POS_X, POS_Y);
			panelDetail.addChild(mReleaseLoader);
			mDirectionLoader = new BMPActionLoader();
			mDirectionLoader.setPivotXY(POS_X, POS_Y);
			panelDetail.addChild(mDirectionLoader);
			mMissileLoader = new BMPActionLoader();
			mMissileLoader.setPivotXY(POS_X, POS_Y);
			panelDetail.addChild(mMissileLoader);
			mMissileHitLoader = new BMPActionLoader();
			mMissileHitLoader.playOnce = true;
			mMissileHitLoader.setPivotXY(POS_X + 600, POS_Y);
			panelDetail.addChild(mMissileHitLoader);
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
			var roleResId:String = StringUtil.trim(txtRole.text);
			if (roleResId == "") {
				Alert.show("角色不能为空");
				return;
			}
			if (cboRoleAction.selectedIndex == -1) {
				Alert.show("未选择动作");
				return;
			}
			
			if (isEdit) {
				var config:SkillResConfigVo = SysConfig.getConfigVo(GameRes.TBL_SKILL_RES, id) as SkillResConfigVo;
				if (config != null && config != mConfig) {
					Alert.show("编号已存在");
					return;
				}
			} else {
				if (SysConfig.getConfigVo(GameRes.TBL_SKILL_RES, id) != null) {
					Alert.show("编号已存在");
					return;
				}
				SysConfig.addConfigVo(GameRes.TBL_SKILL_RES, id, mConfig);
			}
			
			mConfig.id = int(id);
			mConfig.roleResId = int(roleResId);
			mConfig.action = mActionConfig.actionId;
			mConfig.desc = txtDesc.text;
			mConfig.lockTarget = chkLockTarget.selected ? 1 : 0;
			mConfig.unLoackTarget = chkUnLockTarget.selected ? 1 : 0;
			mConfig.nonTargetSelf = chkNonTargetSelf.selected ? 1 : 0;
			mConfig.releaseEffectId = int(txtReleaseId.text);
			mConfig.releaseEffectFrame = int(txtReleaseFrame.text);
			mConfig.directionEffectId = int(txtDirectionId.text);
			mConfig.directionEffectFrame = int(txtDirectionFrame.text);
			mConfig.missileEffectType = cboMissileType.selectedIndex + 1;
			mConfig.missileSpeed = int(txtMissileSpeed.text);
			mConfig.missileEffectId = int(txtMissileId.text);
			mConfig.missileEffectFrame = int(txtMissileFrame.text);
			mConfig.missileHitEffectId = int(txtMissileHitId.text);
			DataCenter.saveSkillTableCfg();
			Alert.show("保存成功！");
			
			close();
			EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.SKILL_VIEW_REFRESH_LIST));
		}
		
		private function onPlay():void {
			if (mActionConfig == null) {
				stopPlay();
				return;
			}
			if (btnPlay.label == "播放") {
				startPlay();
			} else {
				stopPlay();
			}
		}
		
		private function startPlay():void {
			btnPlay.label = "停止";
			TimerManager.getInstance().doFrameLoop(1, showTimeLineImage);
		}
		
		private function stopPlay():void {
			btnPlay.label = "播放";
			TimerManager.getInstance().clear(showTimeLineImage);
			AudioHelper.stopSound();
		}
		
		private function showTimeLineImage():void {
			if (listTimeLine.selectedIndex < mActionConfig.animFramesArray.length - 1) {
				listTimeLine.selectedIndex++;
			} else {
				listTimeLine.selectedIndex = 0;
			}
		}
		
		private function chooseRole(type:int, fromTimeLine:Boolean):void {
			chooseType = type;
			chooseFromTimeLine = fromTimeLine;
			var dialog:ActionRoleChooseDialog = new ActionRoleChooseDialog();
			dialog.showType(type);
			dialog.popup(true);
		}
		
		private function onKeyDown(event:KeyEvent):void {
			var keyCode:int = event.keyCode;
			var shift:Boolean = event.shiftKey;
			var ctrl:Boolean = event.ctrlKey;
			switch (keyCode) {
				case Keyboard.F6:
					// 添加自身特效
					if (!shift) {
						addReleaseEffect();
					} else {
						removeReleaseEffect();
					}
					break;
				case Keyboard.F7:
					// 添加8方向特效
					if (!shift) {
						addDirectionEffect();
					} else {
						removeDirectionEffect();
					}
					break;
				case Keyboard.F8:
					// 添加飞行特效
					if (!shift) {
						addMissileEffect();
					} else {
						removeMissileEffect();
					}
					break;
				case Keyboard.LEFT:
					// 左移帧
					if (mActionConfig != null) {
						listTimeLine.selectedIndex = Math.max(0, listTimeLine.selectedIndex - 1);
					}
					break;
				case Keyboard.RIGHT:
					// 右移帧
					if (mActionConfig != null) {
						listTimeLine.selectedIndex = Math.min(listTimeLine.cells.length - 1, listTimeLine.selectedIndex + 1);
					}
					break;
				case Keyboard.S:
					if (ctrl) {
						onSave();
					}
					break;
			}
		}
		
		private function addReleaseEffect():void {
			if (mActionConfig != null && listTimeLine.selectedIndex != -1) {
				chooseRole(TypeRoleType.SKILL_RELEASE, true);
			}
		}
		
		private function addDirectionEffect():void {
			if (mActionConfig != null && listTimeLine.selectedIndex != -1) {
				chooseRole(TypeRoleType.SKILL_DIRECTION, true);
			}
		}
		
		private function addMissileEffect():void {
			if (mActionConfig != null && listTimeLine.selectedIndex != -1) {
				chooseRole(TypeRoleType.SKILL_MISSILE, true);
			}
		}
		
		private function removeReleaseEffect():void {
			txtReleaseId.text = "";
			txtReleaseFrame.text = "";
		}
		
		private function removeDirectionEffect():void {
			txtDirectionId.text = "";
			txtDirectionFrame.text = "";
		}
		
		private function removeMissileEffect():void {
			txtMissileId.text = "";
			txtMissileFrame.text = "";
		}
		
		private function onRoleChooseComplete(event:GlobalEvent = null):void {
			var roleConfig:RoleResConfigVo = event.data as RoleResConfigVo;
			switch (chooseType) {
				case TypeRoleType.ROLE:
					txtRole.text = roleConfig.id.toString();
					break;
				case TypeRoleType.SKILL_RELEASE:
					txtReleaseId.text = roleConfig.id.toString();
					if (chooseFromTimeLine) {
						txtReleaseFrame.text = listTimeLine.selectedIndex.toString();
					}
					break;
				case TypeRoleType.SKILL_DIRECTION:
					txtDirectionId.text = roleConfig.id.toString();
					if (chooseFromTimeLine) {
						txtDirectionFrame.text = listTimeLine.selectedIndex.toString();
					}
					break;
				case TypeRoleType.SKILL_MISSILE:
					txtMissileId.text = roleConfig.id.toString();
					if (chooseFromTimeLine) {
						txtMissileFrame.text = listTimeLine.selectedIndex.toString();
					}
					break;
				case TypeRoleType.SKILL_MISSILE_HIT:
					txtMissileHitId.text = roleConfig.id.toString();
					break;
			}
			onTimeLineSelect(listTimeLine.selectedIndex);
		}
		
		private function onTextChange(event:Event):void {
			var roleResId:int = int(txtRole.text.toString());
			mRoleConfig = SysConfig.getConfigVo(GameRes.TBL_ROLE_RES, roleResId) as RoleResConfigVo;
			if (mRoleConfig != null) {
				cboRoleAction.disabled = false;
				
				txtRole.text = mRoleConfig.id.toString();
				lblRoleDesc.text = mRoleConfig.desc;
				
				var labels:Array = [];
				mActions = ObjectUtil.objectToArray(mRoleConfig.actionConfigs);
				mActions.sortOn("actionId", Array.NUMERIC);
				for each (var actionResConfig:ActionResConfigVo in mActions) {
					labels.push(actionResConfig.actionTypeConfig.showText);
				}
				cboRoleAction.labels = labels.join(",");
				if (cboRoleAction.selectedIndex == -1) {
					cboRoleAction.selectedIndex = 0;
				}
				
				mRoleLoader.setAction(mRoleConfig.id, mRoleConfig.type, TypeRoleAction.IDLE, mActionConfig.getCheckedDirection(TypeRoleDirection.RIGHT));
				mTargetLoader.setAction(mRoleConfig.id, mRoleConfig.type, TypeRoleAction.IDLE, mActionConfig.getCheckedDirection(TypeRoleDirection.LEFT));
			} else {
				mRoleLoader.bitmapData = null;
				mTargetLoader.bitmapData = null;
				mActionConfig = null;
				cboRoleAction.labels = null;
				cboRoleAction.disabled = true;
				lblRoleDesc.text = "错误ID";
			}
			onTimeLineSelect(listTimeLine.selectedIndex);
		}
		
		private function onReleaseIdChange(event:Event = null):void {
			var roleResId:int = int(txtReleaseId.text.toString());
			mReleaseConfig = SysConfig.getConfigVo(GameRes.TBL_ROLE_RES, roleResId) as RoleResConfigVo;
			if (mReleaseConfig != null) {
				mReleaseLoader.setAction(mReleaseConfig.id, mReleaseConfig.type, TypeRoleAction.IDLE, TypeRoleDirection.DOWN);
			}
			onTimeLineSelect(listTimeLine.selectedIndex);
		}
		
		private function onDirectionIdChange(event:Event = null):void {
			var roleResId:int = int(txtDirectionId.text.toString());
			mDirectionConfig = SysConfig.getConfigVo(GameRes.TBL_ROLE_RES, roleResId) as RoleResConfigVo;
			if (mDirectionConfig != null) {
				var actionConfig:ActionResConfigVo = mDirectionConfig.getActionByActionId(TypeRoleAction.IDLE);
				if (actionConfig.directionArray.indexOf(TypeRoleDirection.RIGHT.toString()) == -1) {
					mDirectionConfig = null;
				}
			}
			if (mDirectionConfig != null && mActionConfig != null) {
				mDirectionLoader.setAction(mDirectionConfig.id, mDirectionConfig.type, TypeRoleAction.IDLE, mActionConfig.getCheckedDirection(TypeRoleDirection.RIGHT));
			}
			
			onTimeLineSelect(listTimeLine.selectedIndex);
		}
		
		private function onMissileIdChange(event:Event = null):void {
			var roleResId:int = int(txtMissileId.text.toString());
			mMissileConfig = SysConfig.getConfigVo(GameRes.TBL_ROLE_RES, roleResId) as RoleResConfigVo;
			if (mMissileConfig != null) {
				mMissileLoader.setAction(mMissileConfig.id, mMissileConfig.type, TypeRoleAction.IDLE, TypeRoleDirection.DOWN);
			}
			
			onTimeLineSelect(listTimeLine.selectedIndex);
		}
		
		private function onMissileHitIdChange(event:Event = null):void {
			var roleResId:int = int(txtMissileHitId.text.toString());
			mMissileHitConfig = SysConfig.getConfigVo(GameRes.TBL_ROLE_RES, roleResId) as RoleResConfigVo;
			if (mMissileHitConfig != null) {
				mMissileHitLoader.setAction(mMissileHitConfig.id, mMissileHitConfig.type, TypeRoleAction.IDLE, TypeRoleDirection.DOWN);
			}
			
			onTimeLineSelect(listTimeLine.selectedIndex);
		}
		
		private function onReleaseFrameChange(event:Event):void {
			onTimeLineSelect(listTimeLine.selectedIndex);
		}
		
		private function onDirectionFrameChange(event:Event):void {
			onTimeLineSelect(listTimeLine.selectedIndex);
		}
		
		private function onMissileFrameChange(event:Event):void {
			onTimeLineSelect(listTimeLine.selectedIndex);
		}
		
		private function onMissileSpeedChange(event:Event):void {
			onTimeLineSelect(listTimeLine.selectedIndex);
		}
		
		private function onMissileTypeSelect(index:int):void {
			if (index == 0) {
				containerMissileSpeed.visible = true;
			} else {
				containerMissileSpeed.visible = false;
			}
		}
		
		/**
		 * 帧选中
		 * @param index
		 * 
		 */		
		private function onTimeLineSelect(index:int):void {
			if (index == -1 || mActionConfig == null) {
				mRoleLoader.bitmapData = null;
				mTargetLoader.bitmapData = null;
				txtCurrentFrame.text = "0/0";
				txtSeconds.text = "0s/0s";
				return;
			}
			// 显示属性
			txtCurrentFrame.text = index + "/" + (mActionConfig.animFramesArray.length - 1);
			var intervalSecond:Number = StageManager.getInstance().intervalSecond;
			var currentSeconds:Number = MathUtil.roundFixed(intervalSecond * index, 3);
			var totalSeconds:Number = MathUtil.roundFixed(intervalSecond * (mActionConfig.animFramesArray.length - 1), 3);
			txtSeconds.text = currentSeconds + "s/" + totalSeconds + "s";
			if (listTimeLine.array[index] == -1) {
				mRoleLoader.bitmapData = null;
				mTargetLoader.bitmapData = null;
				return;
			}
			
			mRoleLoader.index = index;
//			mTargetLoader.index = index;
			// 播放声音
			playSound(mActionConfig, index);
			
			var releaseFrame:int = index - int(txtReleaseFrame.text);
			if (mReleaseConfig != null && txtReleaseFrame.text != "" && releaseFrame >= 0) {
				mReleaseLoader.index = releaseFrame;
				var releaseActionConfig:ActionResConfigVo = mReleaseConfig.getActionByActionId(TypeRoleAction.IDLE);
				playSound(releaseActionConfig, releaseFrame);
			} else {
				mReleaseLoader.bitmapData = null;
			}
			
			var directionFrame:int = index - int(txtDirectionFrame.text);
			if (mDirectionConfig != null && txtDirectionFrame.text != "" && directionFrame >= 0) {
				mDirectionLoader.index = directionFrame;
				var directionActionConfig:ActionResConfigVo = mDirectionConfig.getActionByActionId(TypeRoleAction.IDLE);
				playSound(directionActionConfig, directionFrame);
			} else {
				mDirectionLoader.bitmapData = null;
			}
			
			var missileFrame:int = index - int(txtMissileFrame.text);
			if (mMissileConfig != null && txtMissileFrame.text != "" && missileFrame >= 0) {
				if (cboMissileType.selectedIndex == 0) {
					mMissileLoader.rotation = 90;
					
					var missSpeed:int = int(txtMissileSpeed.text);
					var missDist:Number = (missileFrame / 30) * missSpeed;
					if (POS_X + missDist <= 600) {
						if (!mMissileLoader.isPlaying) {
							mMissileLoader.play();
						}
						mMissileLoader.setPivotXY(POS_X + missDist, POS_Y - 80);
					} else {
						mMissileLoader.stop();
						mMissileLoader.bitmapData = null;
						if (mMissileHitConfig != null) {
							if (!mMissileHitLoader.isPlaying) {
								mMissileHitLoader.play();
							}
						} else {
							mMissileHitLoader.stop();
							mMissileHitLoader.bitmapData = null;
						}
					}
				} else {
					mMissileLoader.rotation = 0;
					mMissileLoader.stop();
					mMissileLoader.index = missileFrame;
					mMissileLoader.setPivotXY(POS_X + 600, POS_Y);
					if (mMissileLoader.index == mMissileLoader.maxIndex) {
						if (!mMissileHitLoader.isPlaying) {
							mMissileHitLoader.play();
						}
					}
				}
				
				var missileActionConfig:ActionResConfigVo = mMissileConfig.getActionByActionId(TypeRoleAction.IDLE);
				playSound(missileActionConfig, missileFrame);
			} else {
				mMissileLoader.rotation = 0;
				mMissileLoader.stop();
				mMissileLoader.bitmapData = null;
				mMissileHitLoader.stop();
				mMissileHitLoader.bitmapData = null;
			}
		}
		
		private function playSound(actionResConfig:ActionResConfigVo, frame:int):void {
			var soundId:int = actionResConfig.soundEffectConfigs[frame];
			if (soundId) {
				var soundConfig:SoundResConfigVo = SysConfig.getConfigVo(GameRes.TBL_SOUND_RES, soundId) as SoundResConfigVo;
				if (soundConfig != null) {
					AudioHelper.playSound(soundConfig.id);
				}
			}
		}
		
		private function onActionChange(index:int = 0):void {
			mActionConfig = null;
			for each (var actionConfig:ActionResConfigVo in mActions) {
				if (actionConfig.actionTypeConfig.showText == cboRoleAction.selectedLabel) {
					mActionConfig = actionConfig;
					break;
				}
			}
			if (mActionConfig) {
				containerEdit.disabled = false;
				var item:SkillTimeLineItem;
				for (var i:int = 0; i < listTimeLine.cells.length; i++) {
					item = listTimeLine.cells[i];
					item.setActionConfig(mActionConfig);
					item.setIndex(i);
				}
				listTimeLine.array = mActionConfig.animFramesArray;
				
				mRoleLoader.setAction(mRoleConfig.id, mRoleConfig.type, mActionConfig.actionId, TypeRoleDirection.RIGHT);
				mTargetLoader.setAction(mRoleConfig.id, mRoleConfig.type, TypeRoleAction.IDLE, TypeRoleDirection.LEFT);
				mTargetLoader.play();
				
				onReleaseIdChange();
				onDirectionIdChange();
			} else {
				containerEdit.disabled = true;
			}
		}
		
		public function create():void {
			isEdit = false;
			
			mConfig = new SkillResConfigVo();
		}
		
		public function edit(skillConfig:SkillResConfigVo):void {
			isEdit = true;
			
			mConfig = skillConfig;
			txtID.text = mConfig.id.toString();
			txtRole.text = mConfig.roleResId.toString();
			lblRoleDesc.text = mConfig.roleConfig.desc;
			
			for (var i:int = 0; i < mActions.length; i++) {
				var actionConfig:ActionResConfigVo = mActions[i];
				if (actionConfig.actionId == mConfig.action) {
					mActionConfig = actionConfig;
					cboRoleAction.selectedIndex = i;
					break;
				}
			}
			
			txtDesc.text = mConfig.desc;
			chkLockTarget.selected = mConfig.lockTarget == 1;
			chkUnLockTarget.selected = mConfig.unLoackTarget == 1;
			chkNonTargetSelf.selected = mConfig.nonTargetSelf == 1;
			txtReleaseId.text = mConfig.releaseEffectId != 0 ? mConfig.releaseEffectId.toString() : "";
			txtReleaseFrame.text = mConfig.releaseEffectFrame.toString();
			txtDirectionId.text = mConfig.directionEffectId != 0 ? mConfig.directionEffectId.toString() : "";
			txtDirectionFrame.text = mConfig.directionEffectFrame.toString();
			txtMissileId.text = mConfig.missileEffectId != 0 ? mConfig.missileEffectId.toString() : "";
			txtMissileFrame.text = mConfig.missileEffectFrame.toString();
			txtMissileHitId.text = mConfig.missileHitEffectId != 0 ? mConfig.missileHitEffectId.toString() : "";
			cboMissileType.selectedIndex = mConfig.missileEffectType - 1;
			txtMissileSpeed.text = mConfig.missileSpeed.toString();
		}
		
		override public function close(type:String=null):void {
			super.close(type);
			KeyboardManager.getInstance().removeEventListener(KeyEvent.KEY_DOWN, onKeyDown);
			EventManager.getInstance().removeEventListener(GlobalEvent.ACTION_CHOOSE_COMPLETE, onRoleChooseComplete);
			txtRole.removeEventListener(Event.CHANGE, onTextChange);
			txtReleaseId.removeEventListener(Event.CHANGE, onReleaseIdChange);
			txtDirectionId.removeEventListener(Event.CHANGE, onDirectionIdChange);
			txtMissileId.removeEventListener(Event.CHANGE, onMissileIdChange);
			txtMissileHitId.removeEventListener(Event.CHANGE, onMissileHitIdChange);
			txtReleaseFrame.removeEventListener(Event.CHANGE, onReleaseFrameChange);
			txtDirectionFrame.removeEventListener(Event.CHANGE, onDirectionFrameChange);
			txtMissileFrame.removeEventListener(Event.CHANGE, onMissileFrameChange);
			stopPlay();
			dispose();
		}
	}
}