package com.canaan.lib.utils.force
{
	public class FrictionForce extends AForce
	{
		private var _frictionForce:Number;
		
		public function FrictionForce(frictionForce:Number, speed:Number=0, nonForce:Boolean=false)
		{
			super(speed, nonForce);
			_frictionForce = frictionForce;
		}
		
		private function get stoped():Boolean {
			return _speed == 0;
		}
		
		private function get sign():int {
			if (_speed == 0) {
				return 0;
			}
			return _speed > 0 ? 1 : -1;
		}
		
		override public function getAcceleration():Number {
			return sign * _frictionForce;
		}
		
		override public function updateSpeed(time:Number):Number {
			if (stoped) {
				return 0;
			}
			var s:Number = super.updateSpeed(time);
			if ((sign > 0 && s <= 0) || (sign < 0 && s >= 0)) {
				_speed = 0;
				s = 0;
			}
			return s;
		}
	}
}