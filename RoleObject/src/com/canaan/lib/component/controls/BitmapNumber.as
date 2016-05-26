package com.canaan.lib.component.controls
{
	import com.canaan.lib.component.UIComponent;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.events.UIEvent;
	import com.canaan.lib.managers.TimerManager;

	public class BitmapNumber extends LayoutBox
	{
		public static const NONE:String = "none";
		public static const LEFT:String = "left";
		public static const CENTER:String = "center";
		public static const RIGHT:String = "right";
		
		protected var _url:String;
		protected var _value:int;
		protected var clips:Vector.<Clip> = new Vector.<Clip>();
		protected var nums:Array = [];
		protected var mAnimCallback:Method;
		
		public function BitmapNumber(url:String = "")
		{
			super();
			this.url = url;
		}
		
		override protected function changeItems():void {
			var items:Array = [];
			var totalWidth:Number = 0;
			for (var i:int = 0, n:int = numChildren; i < n; i++) {
				var item:UIComponent = getChildAt(i) as UIComponent;
				if (item) {
					items.push(item);
					totalWidth += item.displayWidth + _space;
				}
			}
			if (items.length > 0) {
				totalWidth -= _space;
			}
			
			var left:Number = 0;
			if (_align == CENTER) {
				left = (width - totalWidth) * 0.5;
			} else if (_align == RIGHT) {
				left = width - totalWidth;
			} else {
				left = 0;
			}
			if (left < 0) {
				left = 0;
			}
			
			items.sortOn(["x"], Array.NUMERIC);
			for each (item in items) {
				item.x = left;
				left += item.displayWidth + _space;
			}
			changeSize();
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			callLater(changeItems);
		}
		
		public function reset():void {
			removeAllChildren();
			for each (var clip:Clip in clips) {
				clip.removeEventListener(UIEvent.IMAGE_LOADED, onImageLoaded);
				Clip.toPool(clip);
			}
			clips.length = 0;
			nums.length = 0;
		}

		public function get url():String {
			return _url;
		}
		
		public function set url(value:String):void {
//			if (_url != value) {
				_url = value;
				callLater(changeClips);
//			}
		}
		
		public function get value():int {
			return _value;
		}
		
		public function set value(num:int):void {
//			if (_value != num) {
				_value = Math.max(0, num);
				callLater(changeClips);
//			}
		}
		
		public function setIndex(value:String):void {
			exeCallLater(changeClips);
			reset();
			var array:Array = value.split(",");
			var clip:Clip;
			var num:uint;
			for (var i:int = 0; i < array.length; i++) {
				num = array[i];
				clip = Clip.fromPool();
				clip.clipX = 10;
				clip.clipY = 1;
				clip.autoPlay = false;
				clip.url = url;
				clip.gotoAndStop(num);
				addChildAt(clip, 0);
				clip.x = i;
				clips.push(clip);
			}
		}
		
		public function changeClips():void {
			reset();
			var clip:Clip;
			var v:uint = _value;
			var num:uint;
			var index:int;
			do {
				num = v % 10;
				nums.unshift(num);
				v /= 10;
				clip = Clip.fromPool();
				clip.addEventListener(UIEvent.IMAGE_LOADED, onImageLoaded);
				clip.clipX = 10;
				clip.clipY = 1;
				clip.autoPlay = false;
				clip.url = url;
				clip.commitMeasure();
				clip.gotoAndStop(num);
				addChildAt(clip, 0);
				clip.x = index;
				index--;
				clips.unshift(clip);
			} while (v != 0);
			callLater(changeItems);
		}
		
		private function onImageLoaded(event:UIEvent):void {
			callLater(changeItems);
		}
		
		override public function dispose():void {
			reset();
			clips = null;
			nums = null;
			super.dispose();
		}
		
		public function setClipValue(value:int):void {
			exeCallLater(changeClips);
			for (var i:int = 0; i < clips.length; i++) {
				clips[i].frame = value;
			}
		}
		
		public function playAnimation(animCallback:Method = null):void {
			exeCallLater(changeClips);
			if (clips.length > 0) {
				mAnimCallback = animCallback;
				for each (var clip:Clip in clips) {
					clip.frame = 0;
				}
				playClipAnimation(clips.length - 1);
			}
		}
		
		private function playClipAnimation(index:int):void {
			if (index >= 0) {
				var clip:Clip = clips[index];
				var num:int = nums[index];
				var animNum:int = num == 0 ? 9 : num;
				clip.playFromTo(0, animNum, new Method(function():void {
					clip.frame = num;
				}));
				TimerManager.getInstance().doOnce(200, playClipAnimation, [index - 1]);
			} else {
				if (mAnimCallback != null) {
					mAnimCallback.apply();
					mAnimCallback = null;
				}
			}
		}
	}
}