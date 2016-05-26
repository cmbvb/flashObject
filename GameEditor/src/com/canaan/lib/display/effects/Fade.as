package com.canaan.lib.display.effects
{
	import com.canaan.lib.animation.Tween;
	import com.canaan.lib.core.Method;
	
	import flash.display.DisplayObject;

	/**
	 * 淡入淡出特效
	 * 
	 */	
	public class Fade
	{
		private var mTarget:DisplayObject;
		private var mTween:Tween;
		private var mOnComplete:Method;
		
		public function Fade()
		{
		}
		
		public function start(target:DisplayObject, time:Number, startAlpha:Number = 0, endAlpha:Number = 1,
							  onComplete:Method = null, transition:String = "linear"):void {
			stop();
			mTarget = target;
			mOnComplete = onComplete;
			fade(time, startAlpha, endAlpha, transition);
		}
		
		public function stop():void {
			if (mTarget) {
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
		}
		
		private function fade(time:Number, startAlpha:Number = 0, endAlpha:Number = 1, transition:String = "linear"):void {
			mTarget.alpha = startAlpha;
			mTween = Tween.fromPool(mTarget, time, transition);
			mTween.fadeTo(endAlpha);
			mTween.onComplete = stop;
			mTween.start();
		}
	}
}