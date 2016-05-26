package com.canaan.lib.display.effects
{
	import com.canaan.lib.animation.Tween;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.utils.DisplayUtil;
	
	import flash.display.DisplayObject;

	/**
	 * 高亮特效
	 * @author Administrator
	 * 
	 */	
	public class HighlightEffect
	{
		private var mTarget:DisplayObject;
		private var mTween:Tween;
		private var mOnComplete:Method;
		private var mPlaying:Boolean;
		
		public function HighlightEffect()
		{
		}
		
		public function start(target:DisplayObject, brightness:Number, time:Number = 500, onComplete:Method = null, transition:String = "linear"):void {
			stop();
			mTarget = target;
			mOnComplete = onComplete;
			highlight(brightness, time, transition);
			mPlaying = true;
		}
		
		public function stop():void {
			if (mTarget) {
				DisplayUtil.setBrightness(mTarget, 0);
				mTarget = null;
			}
			if (mTween) {
				Tween.toPool(mTween);
				mTween = null;
			}
			if (mOnComplete) {
				mOnComplete.apply();
				mOnComplete = null;
			}
			mPlaying = false;
		}
		
		private function highlight(brightness:Number, time:Number, transition:String = "linear"):void {
			mTween = Tween.fromPool(mTarget, time);
			mTween.transition = transition;
			mTween.reverse = true;
			mTween.repeatCount = 2;
			mTween.onUpdate = function():void {
				DisplayUtil.setBrightness(mTarget, mTween.transitionValue * brightness);
			};
			mTween.onComplete = stop;
			mTween.start();
		}
		
		public function get playing():Boolean {
			return mPlaying;
		}
	}
}