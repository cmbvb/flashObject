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
		protected var _interval:int = 50;
		protected var _isPlaying:Boolean;
		protected var _autoRemoved:Boolean;
		protected var _bitmapDatas:Vector.<BitmapDataEx>;
		protected var _frameChangeHandler:Method;
		
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
			if (value != null) {
				_bitmapDatas = value;
				var index:int = Math.min(maxIndex, Math.max(0, _index));
				if (_bitmapDatas != null) {
					bitmapDataEx = _bitmapDatas[index];
				}
				if (_isPlaying) {
					play();
				}
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
			frame = value;
			stop();
		}
		
		public function gotoAndPlay(value:int):void {
			frame = value;
			play();
		}
		
		public function prevFrame():void {
			frame = _index == 0 ? maxIndex : _index - 1;
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
			frame = _index == maxIndex ? 0 : _index + 1;
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
			this.to = Math.min(maxIndex, int(to) || maxIndex);
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
		
		public function get frame():int {
			return _index;
		}
		
		public function set frame(value:int):void {
			value = Math.min(maxIndex, Math.max(0, value));
			if (_index != value) {
				_index = value;
				if (_bitmapDatas != null) {
					bitmapDataEx = _bitmapDatas[_index];
				}
				delay = 0;
				if (_frameChangeHandler != null) {
					_frameChangeHandler.apply();
				}
			}
		}
		
		public function get maxIndex():int {
			return _bitmapDatas != null ? _bitmapDatas.length - 1 : 0;
		}
		
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		
		public function dispose():void {
			_index = 0;
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

		public function get frameChangeHandler():Method
		{
			return _frameChangeHandler;
		}

		public function set frameChangeHandler(value:Method):void
		{
			_frameChangeHandler = value;
		}

	}
}