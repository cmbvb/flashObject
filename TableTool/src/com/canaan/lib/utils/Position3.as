package com.canaan.lib.utils
{
	import flash.geom.Point;

	public class Position3
	{
		private var _x:Number;
		private var _y:Number;
		private var _z:Number;
		
		public function Position3(x:Number = 0, y:Number = 0, z:Number = 0)
		{
			setPosition(x, y, z);
		}
		
		public function setPosition(x:Number = 0, y:Number = 0, z:Number = 0):void {
			_x = x;
			_y = y;
			_z = z;
		}
		
		public function copy(position:Position3):void {
			if (position != null) {
				_x = position.x;
				_y = position.y;
				_z = position.z;
			}
		}
		
		public function getPosition2():Point {
			return new Point(_x, _y);
		}
		
		public function clone():Position3 {
			return new Position3(_x, _y, _z);
		}

		public function get x():Number {
			return _x;
		}

		public function set x(value:Number):void {
			_x = value;
		}

		public function get y():Number {
			return _y;
		}

		public function set y(value:Number):void {
			_y = value;
		}

		public function get z():Number {
			return _z;
		}

		public function set z(value:Number):void {
			_z = value;
		}
		
		public function toString():String {
			return "(x=" + _x + ", y=" + _y + ", z=" + _z + ")";
		}
	}
}