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
		private var mPlaying:Boolean;
		
		public function Glow()
		{
			mFilter = new GlowFilter();
		}
		
		public function start(target:DisplayObject, color:uint, time:Number = 750, startBlur:Number = 5, endBlur:Number = 15, startAlpha:Number = 1, endAlpha:Number = 1, strength:Number = 2, inner:Boolean = false):void {
			stop();
			mTarget = target;
			glow(color, time, startBlur, endBlur, startAlpha, endAlpha, strength, inner);
			mPlaying = true;
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
			mPlaying = false;
		}
		
		private function glow(color:uint, time:Number, startBlur:Number, endBlur:Number, startAlpha:Number, endAlpha:Number, strength:Number, inner:Boolean):void {
			mFilter.color = color;
			mFilter.blurX = startBlur;
			mFilter.blurX = startBlur;
			mFilter.alpha = startAlpha;
			mFilter.strength = strength;
			mFilter.inner = inner;
			mTween = Tween.fromPool(mFilter, time);
			mTween.repeatCount = int.MAX_VALUE;
			mTween.reverse = true;
			mTween.animate("blurX", endBlur);
			mTween.animate("blurY", endBlur);
			mTween.animate("alpha", endAlpha);
			mTween.onUpdate = updateFilter;
			mTween.start();
		}
		
		private function updateFilter():void {
			DisplayUtil.removeFilter(mTarget, GlowFilter);
			DisplayUtil.addFilter(mTarget, mFilter);
		}
		
		public function get playing():Boolean {
			return mPlaying;
		}
	}
}