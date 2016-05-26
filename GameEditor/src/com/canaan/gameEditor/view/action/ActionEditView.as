package com.canaan.gameEditor.view.action
{
	import com.canaan.gameEditor.cfg.ActionResConfigVo;
	import com.canaan.gameEditor.cfg.RoleResConfigVo;
	import com.canaan.gameEditor.cfg.RoleTypeConfigVo;
	import com.canaan.gameEditor.cfg.SoundResConfigVo;
	import com.canaan.gameEditor.contants.TypeDragType;
	import com.canaan.gameEditor.contants.TypeRoleAction;
	import com.canaan.gameEditor.core.ActionHelper;
	import com.canaan.gameEditor.core.AudioHelper;
	import com.canaan.gameEditor.core.DataCenter;
	import com.canaan.gameEditor.core.FileHelper;
	import com.canaan.gameEditor.core.GameRes;
	import com.canaan.gameEditor.core.GameResPath;
	import com.canaan.gameEditor.event.GlobalEvent;
	import com.canaan.gameEditor.ui.action.ActionEditViewUI;
	import com.canaan.gameEditor.view.common.Alert;
	import com.canaan.gameEditor.view.sound.SoundChooseDialog;
	import com.canaan.lib.core.Application;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.core.SysConfig;
	import com.canaan.lib.events.DragEvent;
	import com.canaan.lib.events.KeyEvent;
	import com.canaan.lib.managers.DialogManager;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.managers.KeyboardManager;
	import com.canaan.lib.managers.StageManager;
	import com.canaan.lib.managers.TimerManager;
	import com.canaan.lib.role.constants.TypeRoleDirection;
	import com.canaan.lib.utils.MathUtil;
	import com.canaan.lib.utils.ObjectUtil;
	import com.canaan.lib.utils.StringUtil;
	
	import flash.ui.Keyboard;
	
	public class ActionEditView extends ActionEditViewUI
	{
		private static var timeLineArray:Array;
		
		private var mRoleConfig:RoleResConfigVo;
		private var mActionConfig:ActionResConfigVo;
		private var mImageXML:XML;
		private var mRoleTypeArray:Array;
		private var previewImage:ActionEditPreview;
		private var previewDetail:ActionEditPreview;
		
		public function ActionEditView()
		{
			super();
			disabled = true;
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			btnCopyTimeLine.clickHandler = new Method(onCopyTimeLine);
			btnSave.clickHandler = new Method(onSave);
			btnPlay.clickHandler = new Method(onPlay);
			listActions.selectHandler = new Method(onActionSelect);
			listImages.selectHandler = new Method(onImageSelect);
			listTimeLine.selectHandler = new Method(onTimeLineSelect);
			cboDirection.selectHandler = new Method(onDirectionChange);
//			txtFrameSet.textField.addEventListener(FocusEvent.FOCUS_OUT, onFrameSetFocusOut);
//			txtFrameSet.textField.addEventListener(KeyboardEvent.KEY_DOWN, onFrameSetKeyDown);
			
			previewImage = new ActionEditPreview(140, 220);
			previewDetail = new ActionEditPreview(300, 400);
			panelPreview.addChild(previewImage);
			panelDetail.addChild(previewDetail);
			
			listImages.array = null;
			initialTimeLine();
		}
		
		public function onShow():void {
			KeyboardManager.getInstance().addEventListener(KeyEvent.KEY_DOWN, onKeyDown);
			panelDetail.addEventListener(DragEvent.DRAG_DROP, onImageDragDrop);
			EventManager.getInstance().addEventListener(GlobalEvent.ACTION_EDIT_SWAP_TIME_LINE, onSwapTimeLine);
			EventManager.getInstance().addEventListener(GlobalEvent.ACTION_EDIT_SET_TIME_LINE, onSetTimeLine);
			EventManager.getInstance().addEventListener(GlobalEvent.SOUND_CHOOSE_COMPLETE, onSoundChooseComplete);
			EventManager.getInstance().addEventListener(GlobalEvent.ACTION_CHOOSE_COMPLETE, onActionChooseComplete);
		}
		
		public function onHide():void {
			KeyboardManager.getInstance().removeEventListener(KeyEvent.KEY_DOWN, onKeyDown);
			panelDetail.removeEventListener(DragEvent.DRAG_DROP, onImageDragDrop);
			EventManager.getInstance().removeEventListener(GlobalEvent.ACTION_EDIT_SWAP_TIME_LINE, onSwapTimeLine);
			EventManager.getInstance().removeEventListener(GlobalEvent.ACTION_EDIT_SET_TIME_LINE, onSetTimeLine);
			EventManager.getInstance().removeEventListener(GlobalEvent.SOUND_CHOOSE_COMPLETE, onSoundChooseComplete);
			EventManager.getInstance().removeEventListener(GlobalEvent.ACTION_CHOOSE_COMPLETE, onActionChooseComplete);
		}
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mRoleConfig = value as RoleResConfigVo;
			initialRoleType();
			if (mRoleConfig) {
				txtID.text = mRoleConfig.id.toString();
				txtDesc.text = mRoleConfig.desc;
				if (mRoleConfig.typeConfig) {
					cboRoleType.selectedIndex = mRoleTypeArray.indexOf(mRoleConfig.typeConfig);
				} else {
					cboRoleType.selectedIndex = -1;
				}
				var actionList:Array = ObjectUtil.objectToArray(mRoleConfig.actionConfigs);
				actionList.sortOn("actionId", Array.NUMERIC);
				listActions.array = actionList;
				onActionSelect(listActions.selectedIndex);
				disabled = false;
			} else {
				mActionConfig = null;
				txtID.text = "";
				txtDesc.text = "";
				cboRoleType.selectedIndex = -1;
				listActions.selectedIndex = -1;
				listActions.array = null;
				disabled = true;
				AudioHelper.stopSound();
				initialRoleType();
			}
		}
		
		private function onSave():void {
			if (mRoleConfig == null) {
				return;
			}
			var id:String = StringUtil.trim(txtID.text);
			if (id == "") {
				Alert.show("编号不能为空");
				return;
			}
			if (isNaN(Number(id))) {
				Alert.show("编号必须为数字");
				return;
			}
			if (mRoleConfig.id != int(id) && SysConfig.getConfigVo(GameRes.TBL_ROLE_RES, id) != null) {
				Alert.show("编号已存在");
				return;
			}
			if (cboRoleType.selectedIndex == -1) {
				Alert.show("未选择动作类型");
				return;
			}
			mRoleConfig.id = int(id);
			mRoleConfig.type = mRoleTypeArray[cboRoleType.selectedIndex].id;
			mRoleConfig.desc = StringUtil.trim(txtDesc.text);
			
			Alert.show("正在处理动作资源，请稍等...", Alert.TYPE_OK, null, null, false);
			Application.app.mouseChildren = Application.app.mouseEnabled = false;
			TimerManager.getInstance().doOnce(500, function():void {
				ActionHelper.saveActions(mRoleConfig.id);
				DataCenter.saveRoleTableCfg();
				DataCenter.saveActionTableCfg();
				Application.app.mouseChildren = Application.app.mouseEnabled = true;
				Alert.show("保存成功！");
			});
		}
		
		private function onCopyTimeLine():void {
			if (mRoleConfig == null) {
				return;
			}
			var roleChooseDialog:ActionRoleChooseDialog = new ActionRoleChooseDialog();
			roleChooseDialog.popup(true);
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
				previewDetail.showImage(null);
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
				previewDetail.showImage(null);
				return;
			}
			// 显示图片
			var direction:int = mActionConfig.directionArray[cboDirection.selectedIndex];
			var frameIndex:int = listTimeLine.array[index];
			var url:String = GameResPath.cfg_actionImages + mActionConfig.roleResId + "/" + mActionConfig.actionId + "/" + direction + "/" + ActionHelper.getIndexString(frameIndex) + ".png";
			var xml:XML = mImageXML.children()[frameIndex];
			var anchorX:int = int(xml.@x);
			var anchorY:int = int(xml.@y);
			previewDetail.showImage(url, anchorX, anchorY);
			// 播放声音
			var soundId:int = mActionConfig.soundEffectConfigs[index];
			if (soundId) {
				var soundConfig:SoundResConfigVo = SysConfig.getConfigVo(GameRes.TBL_SOUND_RES, soundId) as SoundResConfigVo;
				if (soundConfig != null) {
					AudioHelper.playSound(soundConfig.id);
				}
			}
		}
		
		/**
		 * 选中动作
		 * @param index
		 * 
		 */		
		private function onActionSelect(index:int):void {
			stopPlay();
			if (index == -1) {
				cboDirection.selectedIndex = -1;
				listTimeLine.selectedIndex = -1;
				listTimeLine.array = timeLineArray.concat();
				return;
			}
			mActionConfig = listActions.array[index];
			
			// 显示动作方向
			var labels:Array = [];
			for each (var direction:int in mActionConfig.directionArray) {
				labels.push(TypeRoleAction.BASE_DIRECTION[direction]);
			}
			cboDirection.labels = labels.join(",");
			var cboIndex:int = labels.indexOf(TypeRoleAction.BASE_DIRECTION[TypeRoleDirection.DOWN]);
			if (cboIndex == -1) {
				cboIndex = 0;
			}
			cboDirection.selectedIndex = cboIndex;
			onDirectionChange(cboIndex);
			
			// 刷新时间线
			for each (var item:ActionEditTimeLineItem in listTimeLine.cells) {
				item.setActionConfig(mActionConfig);
			}
			refreshTimeLine();
		}
		
		/**
		 * 图片库选中预览图片
		 * @param index
		 * 
		 */		
		private function onImageSelect(index:int):void {
			if (index == -1) {
				previewImage.showImage(null);
				return;
			}
			var url:String = listImages.array[index].url;
			var xml:XML = mImageXML.children()[index];
			var anchorX:int = int(xml.@x);
			var anchorY:int = int(xml.@y);
			previewImage.showImage(url, anchorX, anchorY);
		}
		
		/**
		 * 改变动作方向，读取对应图片
		 * @param index
		 * 
		 */		
		private function onDirectionChange(index:int):void {
			if (index == -1) {
				listImages.selectedIndex = -1;
				listImages.array = null;
				return;
			}
			if (mActionConfig == null) {
				return;
			}
			
			var direction:int = mActionConfig.directionArray[index];
			// 读取图片坐标偏移
			var xmlPath:String = GameResPath.file_cfg_actionXML + mActionConfig.roleResId + "\\" + mActionConfig.actionId + "\\" + direction + ".xml";
			mImageXML = FileHelper.readXML(xmlPath);
			
			// 设置图片库
			var imageArray:Array = [];
			for (var i:int = 0; i <= mActionConfig.maxFrame;i++) {
				var url:String = GameResPath.cfg_actionImages + mActionConfig.roleResId + "/" + mActionConfig.actionId + "/" + direction + "/" + ActionHelper.getIndexString(i) + ".png";
				imageArray.push({url:url, frameIndex:i});
			}
			listImages.array = imageArray;
			onImageSelect(listImages.selectedIndex);
			refreshTimeLine();
		}
		
//		private function onFrameSetFocusOut(event:FocusEvent):void {
//			changeFrameSet();
//		}
//		
//		private function onFrameSetKeyDown(event:KeyboardEvent):void {
//			if (event.keyCode == Keyboard.ENTER) {
//				changeFrameSet();
//			}
//		}
//		
//		/**
//		 * 设置播放速率
//		 * 
//		 */		
//		private function changeFrameSet():void {
//			var frame:int = int(txtFrameSet.text);
//			frame = Math.max(1, Math.min(30, frame));
//			txtFrameSet.text = frame.toString();
//		}
		
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
		
		/**
		 * 初始化时间线，显示刻度
		 * 
		 */		
		private function initialTimeLine():void {
			timeLineArray = [];
			for (var frameIndex:int = 0; frameIndex < 100; frameIndex++) {
				timeLineArray.push(-1);
			}
			listTimeLine.array = timeLineArray;
			
			var item:ActionEditTimeLineItem;
			for (var i:int = 0; i < listTimeLine.cells.length; i++) {
				item = listTimeLine.cells[i];
				item.setIndex(i);
			}
		}
		
		/**
		 * 刷新时间轴显示
		 * 
		 */		
		private function refreshTimeLine():void {
			var timelines:Array = timeLineArray.concat();
			timelines.splice(0, mActionConfig.animFramesArray.length);
			timelines = mActionConfig.animFramesArray.concat(timelines);
			listTimeLine.selectedIndex = listTimeLine.selectedIndex;
			listTimeLine.array = timelines;
			onTimeLineSelect(listTimeLine.selectedIndex);
		}
		
		private function onKeyDown(event:KeyEvent):void {
			var keyCode:int = event.keyCode;
			var shift:Boolean = event.shiftKey;
			var ctrl:Boolean = event.ctrlKey;
			switch (keyCode) {
				case Keyboard.F5:
					// 添加移出帧
					if (!shift) {
						addFrame();
					} else {
						removeFrame();
					}
					break;
				case Keyboard.F6:
					// 添加移出音频
					if (!shift) {
						addSound();
					} else {
						removeSound();
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
		
		private function onSetTimeLine(event:GlobalEvent):void {
			var animIndex:int = int(event.data.animIndex);
			var frameIndex:int = listTimeLine.array[animIndex];
			var newFrameIndex:int = int(event.data.newFrameIndex);
			if (mActionConfig != null) {
				if (frameIndex != -1) {
					// 单帧设置
					mActionConfig.animFramesArray[animIndex] = newFrameIndex;
				} else {
					// 空帧连插
					while (mActionConfig.animFramesArray.length - 1 < animIndex) {
						if (mActionConfig.animFramesArray.length == animIndex) {
							mActionConfig.animFramesArray.push(newFrameIndex);
						} else {
							mActionConfig.animFramesArray.push(mActionConfig.animFramesArray[mActionConfig.animFramesArray.length - 1]);
						}
						mActionConfig.maxAnimFrame++;
					}
				}
				refreshTimeLine();
			}
		}
		
		private function onSwapTimeLine(event:GlobalEvent):void {
			var animIndex:int = int(event.data.animIndex);
			var newAnimIndex:int = int(event.data.newAnimIndex);
			var frameIndex:int = listTimeLine.array[animIndex];
			var newFrameIndex:int = listTimeLine.array[newAnimIndex];
			if (mActionConfig != null) {
				if (newFrameIndex != -1) {
					// 单帧互换
					mActionConfig.animFramesArray[animIndex] = newFrameIndex;
					mActionConfig.animFramesArray[newAnimIndex] = frameIndex;
				} else {
					// 空帧连插
					while (mActionConfig.animFramesArray.length - 1 < newAnimIndex) {
						if (mActionConfig.animFramesArray.length == newAnimIndex) {
							mActionConfig.animFramesArray.push(frameIndex);
						} else {
							mActionConfig.animFramesArray.push(mActionConfig.animFramesArray[mActionConfig.animFramesArray.length - 1]);
						}
						mActionConfig.maxAnimFrame++;
					}
				}
				refreshTimeLine();
			}
		}
		
		private function onImageDragDrop(event:DragEvent):void {
			if (event.data == null || event.data.type != TypeDragType.DRAG_IMAGE_ITEM) {
				return;
			}
			var frameIndex:int = int(event.data.frameIndex);
			if (mActionConfig != null && listTimeLine.selectedIndex != -1 && mActionConfig.animFramesArray.length < listTimeLine.cells.length) {
				if (listTimeLine.selectedItem != -1) {
					// 单帧设值
					mActionConfig.animFramesArray[listTimeLine.selectedIndex] = frameIndex;
				} else {
					// 空帧连插
					while (mActionConfig.animFramesArray.length - 1 < listTimeLine.selectedIndex) {
						if (mActionConfig.animFramesArray.length == listTimeLine.selectedIndex) {
							mActionConfig.animFramesArray.push(frameIndex);
						} else {
							mActionConfig.animFramesArray.push(mActionConfig.animFramesArray[mActionConfig.animFramesArray.length - 1]);
						}
						mActionConfig.maxAnimFrame++;
					}
				}
				refreshTimeLine();
			}
		}
		
		/**
		 * 在指定帧之后插入帧
		 * 
		 */		
		private function addFrame():void {
			if (mActionConfig != null && listTimeLine.selectedIndex != -1 && mActionConfig.animFramesArray.length < listTimeLine.cells.length) {
				if (listTimeLine.selectedItem != -1) {
					// 单帧复制
					mActionConfig.animFramesArray.splice(listTimeLine.selectedIndex, 0, mActionConfig.animFramesArray[listTimeLine.selectedIndex]);
					mActionConfig.maxAnimFrame++;
				} else {
					// 空帧连插
					while (mActionConfig.animFramesArray.length - 1 < listTimeLine.selectedIndex) {
						mActionConfig.animFramesArray.push(mActionConfig.animFramesArray[mActionConfig.animFramesArray.length - 1]);
						mActionConfig.maxAnimFrame++;
					}
				}
				refreshTimeLine();
			}
		}
		
		/**
		 * 删除指定帧
		 * 
		 */		
		private function removeFrame():void {
			if (mActionConfig != null && listTimeLine.selectedIndex != -1 && listTimeLine.selectedItem != -1) {
				mActionConfig.animFramesArray.splice(listTimeLine.selectedIndex, 1);
				mActionConfig.maxAnimFrame--;
				refreshTimeLine();
			}
		}
		
		private function addSound():void {
			if (DialogManager.getInstance().hasPopup(SoundChooseDialog)) {
				return;
			}
			if (mActionConfig != null && listTimeLine.selectedIndex != -1 && listTimeLine.selectedItem != -1) {
				var soundChooseDialog:SoundChooseDialog = new SoundChooseDialog();
				soundChooseDialog.popup(true);
			}
		}
		
		private function removeSound():void {
			if (mActionConfig != null && listTimeLine.selectedIndex != -1 && listTimeLine.selectedItem != -1) {
				if (mActionConfig.soundEffectConfigs[listTimeLine.selectedIndex] != null) {
					delete mActionConfig.soundEffectConfigs[listTimeLine.selectedIndex];
					refreshTimeLine();
				}
			}
		}
		
		private function onSoundChooseComplete(event:GlobalEvent):void {
			if (mActionConfig != null && listTimeLine.selectedIndex != -1 && listTimeLine.selectedItem != -1) {
				var soundConfig:SoundResConfigVo = event.data as SoundResConfigVo;
				mActionConfig.soundEffectConfigs[listTimeLine.selectedIndex] = soundConfig.id;
				refreshTimeLine();
			}
		}
		
		private function onActionChooseComplete(event:GlobalEvent):void {
			var targetRoleConfig:RoleResConfigVo = event.data as RoleResConfigVo;
			if (targetRoleConfig == mRoleConfig) {
				Alert.show("不能拷贝自己！");
				return;
			}
			for (var actionId:int in mRoleConfig.actionConfigs) {
				var targetActionConfig:ActionResConfigVo = targetRoleConfig.actionConfigs[actionId];
				if (targetActionConfig) {
					var currActionConfig:ActionResConfigVo = mRoleConfig.actionConfigs[actionId];
					currActionConfig.maxAnimFrame = targetActionConfig.maxAnimFrame;
					currActionConfig.animFramesArray = targetActionConfig.animFramesArray.concat();
					currActionConfig.soundEffectConfigs = ObjectUtil.clone(targetActionConfig.soundEffectConfigs);
				}
			}
			refreshTimeLine();
		}
	}
}