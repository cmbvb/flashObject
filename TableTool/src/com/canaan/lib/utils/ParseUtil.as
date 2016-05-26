package com.canaan.lib.utils
{
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ParseUtil
	{
		/**
		 * 根据字符串转换为Point
		 * @param value
		 * @param separator
		 * @return 
		 * 
		 */		
		public static function parsePoint(value:String, separator:String = ","):Point {
			var array:Array = ArrayUtil.getArrayFromString(value, separator);
			if (array.length >= 1) {
				return new Point(array[0], array.length > 1 ? array[1] : array[0]);
			}
			return new Point();
		}
		
		/**
		 * 根据字符串转换为Position3
		 * @param value
		 * @param separator
		 * @return 
		 * 
		 */		
		public static function parsePosition3(value:String, separator:String = ","):Position3 {
			var array:Array = ArrayUtil.getArrayFromString(value, separator);
			if (array.length >= 1) {
				return new Position3(array[0], array.length > 1 ? array[1] : array[0], array.length > 2 ? array[2] : array[0]);
			}
			return new Position3();
		}
		
		/**
		 * 根据字符串转换为Rectangle
		 * @param value
		 * @param separator
		 * @return 
		 * 
		 */		
		public static function parseRectangle(value:String, separator:String = ","):Rectangle {
			var array:Array = ArrayUtil.getArrayFromString(value, separator);
			if (array.length >= 4) {
				return new Rectangle(array[0], array[1], array[2], array[3]);
			}
			return new Rectangle();
		}
	}
}