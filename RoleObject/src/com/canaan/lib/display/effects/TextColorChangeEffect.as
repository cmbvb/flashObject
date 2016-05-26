package com.canaan.lib.display.effects
{
	import com.canaan.lib.component.controls.Label;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.TimerManager;

	public class TextColorChangeEffect
	{
		private var mTarget:Label;
		private var mOnComplete:Method;
		private var mChangeNum:int;
		private var mColor:uint;
		private var mChangeColor:uint;
		private var mCurrentColor:uint;
		private var mPlaying:Boolean;
		
		public function TextColorChangeEffect()
		{
		}
		
		public function start(target:Label, color:uint, changeColor:uint, time:Number = 300, changeNum:int = 3, onComplete:Method = null):void {
			stop();
			mTarget = target;
			mChangeNum = changeNum;
			mColor = color;
			mChangeColor = changeColor;
			mCurrentColor = mColor;
			mOnComplete = onComplete;
			TimerManager.getInstance().doLoop(time, transform);
			mPlaying = true;
		}
		
		public function stop():void {
			if (mTarget) {
				mTarget.color = mColor;
				mTarget = null;
			}
			if (mOnComplete) {
				mOnComplete.apply();
				mOnComplete = null;
			}
			mChangeNum = 0;
			mColor = 0;
			mChangeColor = 0;
			mCurrentColor = 0;
			mPlaying = false;
			TimerManager.getInstance().clear(transform);
		}
		
		private function transform():void {
			if (mChangeNum > 0 && mTarget) {
				if (mCurrentColor == mColor) {
					mTarget.color = mChangeColor;
					mCurrentColor = mChangeColor;
				} else {
					mTarget.color = mColor;
					mCurrentColor = mColor;
				}
				mChangeNum--;
			} else {
				stop();
			}
		}
		
		public function get playing():Boolean {
			return mPlaying;
		}
		
	}
}