package com.canaan.lib.component.extend
{
	import com.canaan.lib.component.controls.Label;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.TimerManager;
	import com.canaan.lib.utils.DateUtil;

	public class TimerLabel extends Label
	{
		protected var _time:int;
		protected var _reverse:Boolean;
		protected var _timerCallback:Method;
		
		public function TimerLabel(text:String="", skin:String=null)
		{
			super(text, skin);
		}

		public function get time():int {
			return _time;
		}

		public function set time(value:int):void {
			_time = value;
			text = DateUtil.formatTimeLeft(_time);
			if (time > 0 || _reverse == true) {
				TimerManager.getInstance().doLoop(1000, updateTime);
			} else {
				TimerManager.getInstance().clear(updateTime);
			}
		}
		
		public function get reverse():Boolean {
			return _reverse;
		}
		
		public function set reverse(value:Boolean):void {
			_reverse = value;
			this.time = _time;
		}
		
		protected function updateTime():void {
			if (_reverse) {
				_time++;
				text = DateUtil.formatTimeLeft(_time);
			} else {
				_time--;
				text = DateUtil.formatTimeLeft(_time);
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