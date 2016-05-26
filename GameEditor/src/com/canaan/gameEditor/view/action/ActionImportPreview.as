package com.canaan.gameEditor.view.action
{
	import com.canaan.gameEditor.contants.TypeRoleAction;
	import com.canaan.gameEditor.data.ActionAnimData;
	import com.canaan.gameEditor.data.ActionAnimSequence;
	import com.canaan.gameEditor.ui.action.ActionImportPreviewUI;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.display.BitmapMovieClip;
	import com.canaan.lib.role.constants.TypeRoleDirection;
	
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class ActionImportPreview extends ActionImportPreviewUI
	{
		private var mAnimData:ActionAnimData;
		private var mCurrentSequence:ActionAnimSequence;
		private var mCurrentDirections:Array;
		private var mCurrentLabels:Array;
		
		private var mBmpMC:BitmapMovieClip;
		
		public function ActionImportPreview()
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			mBmpMC = new BitmapMovieClip();
			mBmpMC.setPivotXY(300, 300);
			mBmpMC.frameChangeHandler = new Method(onFrameChanged);
			panelPreview.addChild(mBmpMC);
			
			btnPlay.clickHandler = new Method(onPlay);
			sliderFrame.changeHandler = new Method(onSliderChange);
			cboDirection.selectHandler = new Method(onDirectionChange);
			txtFrameSet.textField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			txtFrameSet.textField.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mAnimData = value as ActionAnimData;
			
			mCurrentDirections = [];
			mCurrentLabels = [];
			var sequence:ActionAnimSequence;
			var direction:int;
			for (direction in mAnimData.sequences) {
				sequence = mAnimData.sequences[direction];
				mCurrentDirections.push(direction);
			}
			mCurrentDirections.sort(Array.NUMERIC);
			for each (direction in mCurrentDirections) {
				mCurrentLabels.push(TypeRoleAction.BASE_DIRECTION[direction]);
			}
			
			cboDirection.labels = mCurrentLabels.join(",");
			var index:int = mCurrentLabels.indexOf(TypeRoleAction.BASE_DIRECTION[TypeRoleDirection.DOWN]);
			if (index == -1) {
				index = 0;
			}
			cboDirection.selectedIndex = index;
			
			mouseEnabled = true;
			mouseChildren = true;
		}
		
		private function onFocusOut(event:FocusEvent):void {
			changeFrameSet();
		}
		
		private function onKeyDown(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.ENTER) {
				changeFrameSet();
			}
		}
		
		private function changeFrameSet():void {
			var frame:int = int(txtFrameSet.text);
			frame = Math.max(1, Math.min(30, frame));
			txtFrameSet.text = frame.toString();
			mBmpMC.interval = 1000 / frame;
		}
		
		private function onFrameChanged():void {
			sliderFrame.value = mBmpMC.frame;
			txtCurrentFrame.text = mBmpMC.frame + "/" + mBmpMC.maxIndex;
		}
		
		private function onSliderChange():void {
			mBmpMC.frame = sliderFrame.value;
		}
		
		private function onDirectionChange(index:int):void {
			if (index == -1) {
				return;
			}
			mCurrentSequence = mAnimData.sequences[mCurrentDirections[index]];
			
			sliderFrame.min = 0;
			sliderFrame.max = mCurrentSequence.bitmapDatas.length - 1;
			mBmpMC.bitmapDatas = mCurrentSequence.bitmapDatas;
			mBmpMC.frame = sliderFrame.value;
		}
		
		private function onPlay():void {
			if (btnPlay.label == "播放") {
				play();
			} else {
				stop();
			}
		}
		
		private function play():void {
			mBmpMC.play();
			btnPlay.label = "停止";
		}
		
		private function stop():void {
			mBmpMC.stop();
			btnPlay.label = "播放";
		}
	}
}