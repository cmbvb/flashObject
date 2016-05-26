package com.canaan.lib.display
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.interfaces.IAnimation;
	import com.canaan.lib.interfaces.IDispose;
	import com.canaan.lib.managers.TimerManager;
	import com.canaan.lib.utils.DisplayUtil;
	
	import flash.events.Event;
	
	public class BitmapMovieClip extends BitmapEx implements IAnimation, IDispose
	{
		protected var _index:int = -1;
		protected var _maxIndex:int;
		protected var _interval:int = 50;
		protected var _isPlaying:Boolean;
		protected var _autoRemoved:Boolean;
		protected var _bitmapDatas:Vector.<BitmapDataEx>;
		
		protected var from:int;
		protected var to:int;
		protected var completeCallback:Method;
		protected var loop:Boolean;
		protected var delay:int;
		
		public function BitmapMovieClip(bitmapDatas:Vector.<BitmapDataEx> = null)
		{
			super();
			this.bitmapDatas = bitmapDatas;
		}
		
		override public function poolInitialize(data:Object = null):void {
			
		}
		
		override public function poolDestory():void {
			super.poolDestory();
			dispose();
		}
		
		public function get bitmapDatas():Vector.<BitmapDataEx> {
			return _bitmapDatas;
		}
		
		public function set bitmapDatas(value:Vector.<BitmapDataEx>):void {
			_bitmapDatas = value;
			if (_bitmapDatas != null) {
				_maxIndex = _bitmapDatas.length - 1;
				var index:int = Math.min(_maxIndex, Math.max(0, _index));
				bitmapDataEx = _bitmapDatas[index];
			} else {
				_maxIndex = 0;
				bitmapDataEx = null;
			}
			if (_isPlaying) {
				play();
			}
		}
		
		public function play():void {
			if (_bitmapDatas == null) {
				return;
			}
			_isPlaying = true;
			TimerManager.getInstance().doLoop(_interval, nextFrame);
		}
		
		public function stop():void {
			_isPlaying = false;
			TimerManager.getInstance().clear(nextFrame);
		}
		
		public function gotoAndStop(value:int):void {
			index = value;
			stop();
		}
		
		public function gotoAndPlay(value:int):void {
			index = value;
			play();
		}
		
		public function prevFrame():void {
			index = _index == 0 ? _maxIndex : _index - 1;
		}
		
		public function nextFrame():void {
			delay++;
			if (delay < _bitmapDataEx.delay) {
				return;
			}
			if (from || to) {
				if (_index == to) {
					if (loop) {
						gotoAndPlay(from);
					} else {
						from = 0;
						to = 0;
						stop();
						animationComplete();
						animationFinished();
					}
					return;
				}
			}
			index = _index >= _maxIndex ? 0 : _index + 1;
			if (_index == 0) {
				animationFinished();
			}
		}
		
		protected function animationComplete():void {
			if (completeCallback != null) {
				var method:Method = completeCallback;
				completeCallback = null;
				method.apply();
			}
		}
		
		protected function animationFinished():void {
			if (_autoRemoved) {
				stop();
				DisplayUtil.removeChild(parent, this);
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function fromTo(from:Object = null, to:Object = null, loop:Boolean = false, onComplete:Method = null):void {
			this.from = Math.max(0, int(from) || 0);
			this.to = Math.min(_maxIndex, int(to) || _maxIndex);
			this.loop = loop;
			completeCallback = onComplete;
			gotoAndPlay(this.from);
		}
		
		public function get autoRemoved():Boolean {
			return _autoRemoved;
		}
		
		public function set autoRemoved(value:Boolean):void {
			_autoRemoved = value;
		}
		
		public function get interval():int {
			return _interval;
		}
		
		public function set interval(value:int):void {
			if (_interval != value) {
				_interval = value;
				if (_isPlaying) {
					play();
				}
			}
		}
		
		public function get index():int {
			return _index;
		}
		
		public function set index(value:int):void {
			if (value < 0) {
				value = 0;
			}
			if (_index != value) {
				_index = value;
				if (_bitmapDatas != null && _maxIndex >= _index) {
					bitmapDataEx = _bitmapDatas[_index];
				}
				delay = 0;
			}
		}
		
		public function get maxIndex():int {
			return _maxIndex;
		}
		
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		
		public function dispose():void {
			_index = -1;
			_maxIndex = 0;
			_interval = 50;
			_autoRemoved = false;
			_bitmapDatas = null;
			from = 0;
			to = 0;
			completeCallback = null;
			loop = false;
			delay = 0;
			stop();
		}
	}
}