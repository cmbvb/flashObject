package com.canaan.lib.utils.force
{
	public class AForce
	{
		protected var _speed:Number;									// 速度
		protected var _nonForce:Boolean;								// 是否无重力
		
		public function AForce(speed:Number = 0, nonForce:Boolean = false)
		{
			reset(speed, nonForce);
		}
		
		public function reset(speed:Number = 0, nonForce:Boolean = false):void {
			_speed = speed;
			_nonForce = nonForce;
		}
		
		public function getAcceleration():Number {
			return 0;
		}

		public function get speed():Number {
			return _speed;
		}

		public function set speed(value:Number):void {
			_speed = value;
		}

		public function get nonForce():Boolean {
			return _nonForce;
		}

		public function set nonForce(value:Boolean):void {
			_nonForce = value;
		}
		
		public function updateSpeed(time:Number):Number {
			var s:Number = 0;
			var acceleration:Number = getAcceleration();
			if (acceleration != 0 && _nonForce == false) {
				s = _speed * time - 0.5 * acceleration * time * time;
				_speed -= acceleration * time;
			} else {
				s = _speed * time;
			}
			return s;
		}
	}
}