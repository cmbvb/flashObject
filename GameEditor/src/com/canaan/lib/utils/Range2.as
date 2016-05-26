package com.canaan.lib.utils
{
	public class Range2
	{
		public var min:Number;
		public var max:Number;
		
		public function Range2(min:Number = 0, max:Number = 0)
		{
			this.min = min;
			this.max = max;
		}
		
		public function clone():Range2 {
			return new Range2(min, max);
		}
		
		public function toString():String {
			return "(min=" + min + ", max=" + max + ")";
		}
	}
}