package com.canaan.gameEditor.view.skill
{
	import com.canaan.gameEditor.cfg.ActionResConfigVo;
	import com.canaan.gameEditor.cfg.SoundResConfigVo;
	import com.canaan.gameEditor.core.GameRes;
	import com.canaan.gameEditor.ui.skill.SkillTimeLineItemUI;
	import com.canaan.gameEditor.utils.GlobalEffect;
	import com.canaan.lib.core.SysConfig;
	import com.canaan.lib.utils.DisplayUtil;
	
	public class SkillTimeLineItem extends SkillTimeLineItemUI
	{
		private var mActionConfig:ActionResConfigVo;
		private var mAnimIndex:int;
		private var mFrameIndex:int;
		
		public function SkillTimeLineItem()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			imgCircle.visible = false;
			imgRect.visible = false;
		}
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mFrameIndex = int(value);
			imgCircle.visible = false;
			imgRect.visible = false;
			imgSound.visible = false;
			imgSound.toolTip = null;
			filters = [];
			if (mFrameIndex == -1) {
				imgBG.url = "png.comp.border2";
				lblAnimFrame.text = "";
			} else {
				if (mActionConfig) {
					var nextFrame:int = mActionConfig.animFramesArray[mAnimIndex + 1];
					if (mAnimIndex == 0) {
						if (nextFrame == mFrameIndex) {
							imgBG.url = "png.comp.border_timeline_1";
							imgCircle.visible = true;
						} else {
							imgBG.url = "png.comp.borderBlank";
							imgCircle.visible = true;
						}
					} else {
						var prevFrame:int = mActionConfig.animFramesArray[mAnimIndex - 1];
						if (prevFrame != mFrameIndex && nextFrame != mFrameIndex) {
							imgBG.url = "png.comp.borderBlank";
							imgCircle.visible = true;
						} else if (prevFrame != mFrameIndex && nextFrame == mFrameIndex) {
							imgBG.url = "png.comp.border_timeline_1";
							imgCircle.visible = true;
						} else if (prevFrame == mFrameIndex && nextFrame != mFrameIndex) {
							imgBG.url = "png.comp.border_timeline_3";
							imgRect.visible = true;
						} else if (prevFrame == mFrameIndex && nextFrame == mFrameIndex) {
							imgBG.url = "png.comp.border_timeline_2";
						}
					}
					var soundId:int = mActionConfig.soundEffectConfigs[mAnimIndex];
					if (soundId) {
						imgSound.visible = true;
						var soundConfig:SoundResConfigVo = SysConfig.getConfigVo(GameRes.TBL_SOUND_RES, soundId) as SoundResConfigVo;
						if (soundConfig != null) {
							imgSound.toolTip = soundConfig.showText;
						} else {
							imgSound.toolTip = soundId + " 音频不存在";
							DisplayUtil.addFilter(this, GlobalEffect.WARING_FILTER);
						}
					}
				} else {
					imgBG.url = "png.comp.borderBlank";
					imgCircle.visible = true;
				}
			}
		}
		
		public function setActionConfig(value:ActionResConfigVo):void {
			mActionConfig = value;
		}
		
		public function setIndex(index:int):void {
			mAnimIndex = index;
			lblAnimFrame.text = index.toString();
		}
	}
}