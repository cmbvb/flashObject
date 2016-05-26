package com.canaan.lib.component.controls
{
	public class BitmapNumber extends HBox
	{
		protected var _url:String;
		protected var _value:uint;
		protected var clips:Vector.<Clip> = new Vector.<Clip>();
		
		public function BitmapNumber(url:String = "")
		{
			super();
			this.url = url;
		}
		
		public function reset():void {
			removeAllChildren();
			for each (var clip:Clip in clips) {
				Clip.toPool(clip);
			}
			clips.length = 0;
		}

		public function get url():String {
			return _url;
		}
		
		public function set url(value:String):void {
			if (_url != value) {
				_url = value;
				callLater(changeClips);
			}
		}
		
		public function get value():uint {
			return _value;
		}
		
		public function set value(num:uint):void {
			if (_value != num) {
				_value = num;
				callLater(changeClips);
			}
		}
		
		protected function changeClips():void {
			reset();
			var clip:Clip;
			var v:uint = _value;
			var num:uint;
			var index:int;
			do {
				num = v % 10;
				v /= 10;
				clip = Clip.fromPool();
				clip.clipX = 10;
				clip.clipY = 1;
				clip.autoPlay = false;
				clip.url = url;
				clip.gotoAndStop(num);
				addChildAt(clip, 0);
				clip.x = index;
				index--;
				clips.unshift(clip);
			} while (v != 0);
		}
		
		override public function dispose():void {
			reset();
			clips = null;
			super.dispose();
		}
	}
}