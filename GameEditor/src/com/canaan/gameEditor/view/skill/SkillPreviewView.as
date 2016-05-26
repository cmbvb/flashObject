package com.canaan.gameEditor.view.skill
{
	import com.canaan.gameEditor.cfg.ActionResConfigVo;
	import com.canaan.gameEditor.cfg.RoleResConfigVo;
	import com.canaan.gameEditor.cfg.SkillResConfigVo;
	import com.canaan.gameEditor.cfg.SoundResConfigVo;
	import com.canaan.gameEditor.contants.TypeRoleAction;
	import com.canaan.gameEditor.core.AudioHelper;
	import com.canaan.gameEditor.core.GameRes;
	import com.canaan.gameEditor.ui.skill.SkillPreviewViewUI;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.core.SysConfig;
	import com.canaan.lib.managers.StageManager;
	import com.canaan.lib.managers.TimerManager;
	import com.canaan.lib.role.constants.TypeRoleDirection;
	import com.canaan.lib.utils.MathUtil;
	
	public class SkillPreviewView extends SkillPreviewViewUI
	{
		private static const POS_X:int = 120;
		private static const POS_Y:int = 300;
		
		private var mConfig:SkillResConfigVo;
		private var mRoleConfig:RoleResConfigVo;
		private var mActionConfig:ActionResConfigVo;
		
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
		
		public function SkillPreviewView()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			btnEdit.clickHandler = new Method(onEdit);
			btnPlay.clickHandler = new Method(onPlay);
			listTimeLine.selectHandler = new Method(onTimeLineSelect);
			
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
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mConfig = value as SkillResConfigVo;
			mRoleConfig = SysConfig.getConfigVo(GameRes.TBL_ROLE_RES, mConfig.roleResId) as RoleResConfigVo;
			if (mRoleConfig == null) {
				return;
			}
			mActionConfig = mRoleConfig.getActionByActionId(mConfig.action);
			mRoleLoader.setAction(mRoleConfig.id, mRoleConfig.type, mActionConfig.actionId, mActionConfig.getCheckedDirection(TypeRoleDirection.RIGHT));
			mTargetLoader.setAction(mRoleConfig.id, mRoleConfig.type, TypeRoleAction.IDLE, mActionConfig.getCheckedDirection(TypeRoleDirection.LEFT));
			mTargetLoader.play();
			
			listTimeLine.array = mActionConfig.animFramesArray;
			var item:SkillTimeLineItem;
			for (var i:int = 0; i < listTimeLine.cells.length; i++) {
				item = listTimeLine.cells[i];
				item.setActionConfig(mActionConfig);
				item.setIndex(i);
			}
			listTimeLine.array = mActionConfig.animFramesArray;
			
			mReleaseConfig = SysConfig.getConfigVo(GameRes.TBL_ROLE_RES, mConfig.releaseEffectId) as RoleResConfigVo;
			mDirectionConfig = SysConfig.getConfigVo(GameRes.TBL_ROLE_RES, mConfig.directionEffectId) as RoleResConfigVo;
			mMissileConfig = SysConfig.getConfigVo(GameRes.TBL_ROLE_RES, mConfig.missileEffectId) as RoleResConfigVo;
			mMissileHitConfig = SysConfig.getConfigVo(GameRes.TBL_ROLE_RES, mConfig.missileHitEffectId) as RoleResConfigVo;
			
			if (mReleaseConfig != null) {
				mReleaseLoader.setAction(mReleaseConfig.id, mReleaseConfig.type, TypeRoleAction.IDLE, TypeRoleDirection.DOWN);
			}
			if (mDirectionConfig != null) {
				mDirectionLoader.setAction(mDirectionConfig.id, mDirectionConfig.type, TypeRoleAction.IDLE, mActionConfig.getCheckedDirection(TypeRoleDirection.RIGHT));
			}
			if (mMissileConfig != null) {
				mMissileLoader.setAction(mMissileConfig.id, mMissileConfig.type, TypeRoleAction.IDLE, TypeRoleDirection.DOWN);
			}
			if (mMissileHitConfig != null) {
				mMissileHitLoader.setAction(mMissileHitConfig.id, mMissileHitConfig.type, TypeRoleAction.IDLE, TypeRoleDirection.DOWN);
			}
		}
		
		private function onEdit():void {
			var dialog:SkillCreateDialog = new SkillCreateDialog();
			dialog.edit(mConfig);
			dialog.popup(true);
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
			
			var releaseFrame:int = index - mConfig.releaseEffectFrame;
			if (mReleaseConfig != null && releaseFrame >= 0) {
				mReleaseLoader.index = releaseFrame;
				var releaseActionConfig:ActionResConfigVo = mReleaseConfig.getActionByActionId(TypeRoleAction.IDLE);
				playSound(releaseActionConfig, releaseFrame);
			} else {
				mReleaseLoader.bitmapData = null;
			}
			
			var directionFrame:int = index - mConfig.directionEffectFrame;
			if (mDirectionConfig != null && directionFrame >= 0) {
				mDirectionLoader.index = directionFrame;
				var directionActionConfig:ActionResConfigVo = mDirectionConfig.getActionByActionId(TypeRoleAction.IDLE);
				playSound(directionActionConfig, directionFrame);
			} else {
				mDirectionLoader.bitmapData = null;
			}
			
			var missileFrame:int = index - mConfig.missileEffectFrame;
			if (mMissileConfig != null && missileFrame >= 0) {
				if (mConfig.missileEffectType == 1) {
					mMissileLoader.rotation = 90;
					
					var missSpeed:int = mConfig.missileSpeed;
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
	}
}