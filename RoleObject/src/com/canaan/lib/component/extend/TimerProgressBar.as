package com.canaan.lib.component.extend
{
	import com.canaan.lib.component.controls.ProgressBar;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.TimerManager;
	
	public class TimerProgressBar extends ProgressBar
	{
		protected var _time:int;
		protected var _maxTime:int;
		protected var _reverse:Boolean;
		protected var _timerCallback:Method;
		
		public function TimerProgressBar(skin:String=null)
		{
			super(skin);
		}

		public function get time():int {
			return _time;
		}

		public function set time(value:int):void {
			_time = value;
			callLater(changeTime);
		}

		public function get maxTime():int {
			return _maxTime;
		}

		public function set maxTime(value:int):void {
			_maxTime = value;
			callLater(changeTime);
		}
		
		public function get reverse():Boolean {
			return _reverse;
		}
		
		public function set reverse(value:Boolean):void {
			_reverse = value;
		}
		
		protected function changeTime():void {
			if (_time > 0 && _maxTime > 0) {
				value = _time / _maxTime;
				TimerManager.getInstance().doLoop(1000, updateTime);
			} else {
				value = 0;
				TimerManager.getInstance().clear(updateTime);
			}
		}
		
		protected function updateTime():void {
			if (_reverse) {
				_time++;
				value = _time / _maxTime;
				if (_time >= _maxTime) {
					TimerManager.getInstance().clear(updateTime);
					if (_timerCallback != null) {
						_timerCallback.apply();
					}
				}
			} else {
				_time--;
				value = _time / _maxTime;
				if (_time <= 0) {
					TimerManager.getInstance().clear(updateTime);
					if (_timerCallback != null) {
						_timerCallback.apply();
					}
				}
			}
		}

		override public function dispose():void {
			TimerManager.getInstance().clear(updateTime);
			super.dispose();
		}
		
		public function get timerCallback():Method {
			return _timerCallback;
		}
		
		public function set timerCallback(value:Method):void {
			_timerCallback = value;
		}
	}
}