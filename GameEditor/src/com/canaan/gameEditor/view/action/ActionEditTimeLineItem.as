package com.canaan.gameEditor.view.action
{
	import com.canaan.gameEditor.cfg.ActionResConfigVo;
	import com.canaan.gameEditor.cfg.SoundResConfigVo;
	import com.canaan.gameEditor.contants.TypeDragType;
	import com.canaan.gameEditor.core.GameRes;
	import com.canaan.gameEditor.event.GlobalEvent;
	import com.canaan.gameEditor.ui.action.ActionEditTimeLineItemUI;
	import com.canaan.gameEditor.utils.GlobalEffect;
	import com.canaan.lib.component.controls.Image;
	import com.canaan.lib.core.SysConfig;
	import com.canaan.lib.events.DragEvent;
	import com.canaan.lib.managers.DragManager;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.utils.DisplayUtil;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	public class ActionEditTimeLineItem extends ActionEditTimeLineItemUI
	{
		private var mActionConfig:ActionResConfigVo;
		private var mAnimIndex:int;
		private var mFrameIndex:int;
		
		public function ActionEditTimeLineItem()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			imgCircle.visible = false;
			imgRect.visible = false;
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(DragEvent.DRAG_DROP, onItemDragDrop);
		}
		
		private function onMouseDown(event:MouseEvent):void {
			if (mFrameIndex == -1) {
				return;
			}
			var bitmapData:BitmapData = new BitmapData(width, height, true, 0x00000000);
			bitmapData.draw(this);
			var image:Image = new Image();
			image.bitmapData = bitmapData;
			DragManager.getInstance().doDrag(this, image, {type:TypeDragType.DRAG_TIME_LINE_ITEM, animIndex:mAnimIndex});
		}
		
		private function onItemDragDrop(event:DragEvent):void {
			if (event.data == null) {
				return;
			}
			var type:int = int(event.data.type);
			switch (type) {
				case TypeDragType.DRAG_TIME_LINE_ITEM:
					var animIndex:int = int(event.data.animIndex);
					if (animIndex == mAnimIndex) {
						return;
					}
					EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.ACTION_EDIT_SWAP_TIME_LINE, {animIndex:animIndex, newAnimIndex:mAnimIndex}));
					break;
				case TypeDragType.DRAG_IMAGE_ITEM:
					var frameIndex:int = int(event.data.frameIndex);
					EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.ACTION_EDIT_SET_TIME_LINE, {animIndex:mAnimIndex, newFrameIndex:frameIndex}));
					break;
			}
		}
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mFrameIndex = int(value);
			imgCircle.visible = false;
			imgRect.visible = false;
			imgSound.visible = false;
			imgSound.toolTip = null;
			filters = null;
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
				lblAnimFrame.text = mFrameIndex.toString();
			}
		}
		
		public function setActionConfig(value:ActionResConfigVo):void {
			mActionConfig = value;
		}
		
		public function setIndex(index:int):void {
			mAnimIndex = index;
			if (index % 5 == 0) {
				lblFrame.text = index.toString();
			} else {
				lblFrame.text = "";
			}
		}
		
		override public function dispose():void {
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(DragEvent.DRAG_DROP, onItemDragDrop);
			super.dispose();
		}
	}
}