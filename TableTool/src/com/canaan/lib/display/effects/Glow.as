package com.canaan.lib.display.effects
{
	import com.canaan.lib.animation.Tween;
	import com.canaan.lib.utils.DisplayUtil;
	
	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;

	/**
	 * 发光动画
	 * 
	 */	
	public class Glow
	{
		private var mTarget:DisplayObject;
		private var mTween:Tween;
		private var mFilter:GlowFilter;
		
		public function Glow()
		{
			mFilter = new GlowFilter();
		}
		
		public function start(target:DisplayObject, time:Number, color:uint, startBlur:Number, endBlur:Number, alpha:Number = 1, strength:Number = 2):void {
			stop();
			mTarget = target;
			glow(time, color, startBlur, endBlur, alpha, strength);
		}
		
		public function stop():void {
			if (mTarget) {
				DisplayUtil.removeFilter(mTarget, GlowFilter);
				mTarget = null;
			}
			if (mTween) {
				Tween.toPool(mTween);
				mTween = null;
			}
		}
		
		private function glow(time:Number, color:uint, startBlur:Number, endBlur:Number, alpha:Number, strength:Number):void {
			mFilter.color = color;
			mFilter.blurX = startBlur;
			mFilter.blurX = startBlur;
			mFilter.alpha = alpha;
			mFilter.strength = strength;
			mTween = Tween.fromPool(mFilter, time);
			mTween.repeatCount = int.MAX_VALUE;
			mTween.reverse = true;
			mTween.animate("blurX", endBlur);
			mTween.animate("blurY", endBlur);
			mTween.onUpdate = updateFilter;
			mTween.start();
		}
		
		private function updateFilter():void {
			DisplayUtil.removeFilter(mTarget, GlowFilter);
			DisplayUtil.addFilter(mTarget, mFilter);
		}
	}
}