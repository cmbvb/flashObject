package com.canaan.lib.utils
{
	import flash.geom.Point;

	public class MathUtil
	{
		private static var sinCache:Vector.<Number> = new Vector.<Number>(360);
		private static var cosCache:Vector.<Number> = new Vector.<Number>(360);
		
		public static function sin(angle:int):Number {
			angle = toUAngle(angle);
			if (!sinCache[angle]) {
				sinCache[angle] = Math.sin(angleToRadian(angle));
			}
			return sinCache[angle];
		}
		
		public static function cos(angle:int):Number {
			angle = toUAngle(angle);
			if (!cosCache[angle]) {
				cosCache[angle] = Math.cos(angleToRadian(angle));
			}
			return cosCache[angle];
		}
		
		public static function angleToRadian(angle:int):Number {
			return angle * Math.PI / 180;
		}
		
		public static function radianToAngle(radian:Number):int {
			return Math.round(radian * 180 / Math.PI);
		}

		public static function randRange(min:int, max:int):int {
            return int(Math.random() * (max - min + 1)) + min;
        }
		
		public static function roundFixed(value:Number, dot:int):Number {
			dot = Math.max(0, Math.min(16, dot));
			var num:Number = Math.pow(10, dot);
			return Math.round(value * num) / num;
		}
		
		public static function floorFixed(value:Number, dot:int):Number {
			dot = Math.max(0, Math.min(16, dot));
			var num:Number = Math.pow(10, dot);
			return int(value * num) / num;
		}
		
		public static function getRadian(x:Number, y:Number):Number {
			return Math.atan2(y, x);
		}
		
		public static function getAngle(x:Number, y:Number):int {
			return radianToAngle(getRadian(x, y));
		}
		
		public static function getUAngle(x:Number, y:Number):int {
			return toUAngle(radianToAngle(getRadian(x, y)));
		}
		
		public static function toUAngle(angle:int):int {
			if (angle > -1 && angle < 360) {
				return angle;
			}
			angle %= 360;
			if (angle < 0) {
				angle += 360;
			}
			return angle;
		}
		
		public static function getTwoPointRadian(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			return getRadian(dx, dy);
		}
		
		public static function getTwoPointAngle(x1:Number, y1:Number, x2:Number, y2:Number):int {
			return radianToAngle(getTwoPointRadian(x1, y1, x2, y2));
		}
		
		public static function getDistance(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		/**
		 * 获取线段(x1, y1) (x2, y2)上距离点(x1, y1)位移为length的点
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @param length
		 * @return 
		 * 
		 */		
		public static function getLinePoint(x1:Number, y1:Number, x2:Number, y2:Number, length:Number):Point {
			var distance:Number = getDistance(x1, y1, x2, y2);
			var rate:Number = length / (distance - length);
			var point:Point = new Point();
			point.x = (x1 + x2 * rate) / (1 + rate);
			point.y = (y1 + y2 * rate) / (1 + rate);
			return point;
		}
		
		public static function getLinePoint2(x:Number, y:Number, length:Number, angle:int):Point {
			var xx:Number = x + length * cos(angle);
			var yy:Number = y + length * sin(angle);
			return new Point(xx, yy);
		}
		
		/**
		 * 十进制转十六进制
		 * @param value
		 * @return 
		 * 
		 */		
		public static function toHex(value:uint):String {
			return "#" + value.toString(16);
		}
		
		/**
		 * 换算单位
		 * @param num
		 * @param unit
		 * @param unitString
		 * @return 
		 * 
		 */		
		public static function convertUnits(num:Number, unit:Number, unitString:String):String {
			return int(num / unit) + unitString;
		}
		
		/**
		 * 货币表示
		 * @param value
		 * @return 
		 * 
		 */		
		public static function currencyFormat(value:uint):String {
			var valueStr:String = value.toString();
			var cursor:int = valueStr.length;
			var array:Array = [];
			while (cursor >= 3) {
				array.unshift(valueStr.substr(cursor - 3, 3));
				cursor -= 3;
			}
			if (cursor > 0) {
				array.unshift(valueStr.substr(0, cursor));
			}
			return array.join(",");
		}
	}
}