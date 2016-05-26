package com.canaan.lib.display.effects
{
	import com.canaan.lib.animation.Tween;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.utils.DisplayUtil;
	
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;

	/**
	 * 颜色转换特效
	 * @author Administrator
	 * 
	 */	
	public class ColorTransformEffect
	{
		private var mTarget:DisplayObject;
		private var mTween:Tween;
		private var mOnComplete:Method;
		private var mPlaying:Boolean;
		
		public function ColorTransformEffect()
		{
		}
		
		public function start(target:DisplayObject, color:uint, time:Number = 500, onComplete:Method = null, transition:String = "linear"):void {
			stop();
			mTarget = target;
			mOnComplete = onComplete;
			transform(color, time, transition);
			mPlaying = true;
		}
		
		public function stop():void {
			if (mTarget) {
				DisplayUtil.removeFilter(mTarget, ColorMatrixFilter);
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
		
		private function transform(color:uint, time:Number, transition:String = "linear"):void {
			mTween = Tween.fromPool(mTarget, time);
			mTween.transition = transition;
			mTween.reverse = true;
			mTween.repeatCount = 2;
			var a:uint = color >> 24 & 0xff;
			var r:uint = color >> 16 & 0xff;
			var g:uint = color >> 8 & 0xff;
			var b:uint = color & 0xff;
			mTween.onUpdate = function():void {
				var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter([
					1,	0,	0,	0,	r * mTween.transitionValue,
					0,	1,	0,	0,	g * mTween.transitionValue,
					0,	0,	1,	0,	b * mTween.transitionValue,
					0,	0,	0,	mTween.transitionValue,	0
					
				]);
				mTarget.filters = [colorMatrixFilter];
			};
			mTween.onComplete = stop;
			mTween.start();
		}
		
		public function get playing():Boolean {
			return mPlaying;
		}
	}
}