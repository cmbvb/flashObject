package com.canaan.lib.utils.force
{
	public class GravityForce extends AForce
	{
		private var _gravityForce:Number;
		
		public function GravityForce(gravityForce:Number, speed:Number=0, nonForce:Boolean=false)
		{
			super(speed, nonForce);
			_gravityForce = gravityForce;
		}
		
		override public function getAcceleration():Number {
			return _gravityForce;
		}

		public function get gravityForce():Number {
			return _gravityForce;
		}

		public function set gravityForce(value:Number):void {
			_gravityForce = value;
		}
	}
}