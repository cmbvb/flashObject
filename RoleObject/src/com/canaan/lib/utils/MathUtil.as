package com.canaan.lib.utils
{
	import flash.geom.Point;

	public class MathUtil
	{
		private static var sinCache:Vector.<Number> = new Vector.<Number>(360);
		private static var cosCache:Vector.<Number> = new Vector.<Number>(360);
		
		/**
		 * sin
		 * @param angle
		 * @return 
		 * 
		 */		
		public static function sin(angle:int):Number {
			angle = toUAngle(angle);
			if (!sinCache[angle]) {
				sinCache[angle] = Math.sin(angleToRadian(angle));
			}
			return sinCache[angle];
		}
		
		/**
		 * cos
		 * @param angle
		 * @return 
		 * 
		 */		
		public static function cos(angle:int):Number {
			angle = toUAngle(angle);
			if (!cosCache[angle]) {
				cosCache[angle] = Math.cos(angleToRadian(angle));
			}
			return cosCache[angle];
		}
		
		/**
		 * 角度转弧度
		 * @param angle
		 * @return 
		 * 
		 */		
		public static function angleToRadian(angle:int):Number {
			return angle * Math.PI / 180;
		}
		
		/**
		 * 弧度转角度
		 * @param radian
		 * @return 
		 * 
		 */		
		public static function radianToAngle(radian:Number):int {
			return Math.round(radian * 180 / Math.PI);
		}

		/**
		 * 整数随机
		 * @param min
		 * @param max
		 * @return 
		 * 
		 */		
		public static function randRange(min:int, max:int):int {
            return int(Math.random() * (max - min + 1)) + min;
        }
		
		/**
		 * 浮点数随机
		 * @param min
		 * @param max
		 * @return 
		 * 
		 */		
		public static function randRangeFloat(min:Number, max:Number):Number {
			return Math.random() * (max - min) + min;
		}
		
		/**
		 * 四舍五入保留小数
		 * @param value
		 * @param dot
		 * @return 
		 * 
		 */		
		public static function roundFixed(value:Number, dot:int):Number {
			dot = rangeLimit(dot, 0, 16);
			var num:Number = Math.pow(10, dot);
			return Math.round(value * num) / num;
		}
		
		/**
		 * 向下取整保留小数
		 * @param value
		 * @param dot
		 * @return 
		 * 
		 */		
		public static function floorFixed(value:Number, dot:int):Number {
			dot = rangeLimit(dot, 0, 16);
			var num:Number = Math.pow(10, dot);
			return int(value * num) / num;
		}
		
		/**
		 * 获取弧度 
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		public static function getRadian(x:Number, y:Number):Number {
			return Math.atan2(y, x);
		}
		
		/**
		 * 获取角度
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		public static function getAngle(x:Number, y:Number):int {
			return radianToAngle(getRadian(x, y));
		}
		
		/**
		 * 获取有效角度
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		public static function getUAngle(x:Number, y:Number):int {
			return toUAngle(radianToAngle(getRadian(x, y)));
		}
		
		/**
		 * 有效话角度
		 * @param angle
		 * @return 
		 * 
		 */		
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
		
		/**
		 * 范围限制
		 * @param value
		 * @param minValue
		 * @param maxValue
		 * @return 
		 * 
		 */		
		public static function rangeLimit(value:Number, minValue:Number = NaN, maxValue:Number = NaN):Number {
			if (!isNaN(minValue)) {
				if (value < minValue) {
					value = minValue;
				}
			}
			if (!isNaN(maxValue)) {
				if (value > maxValue) {
					value = maxValue;
				}
			}
			return value;
		}
		
		/**
		 * 获取两点弧度
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @return 
		 * 
		 */		
		public static function getTwoPointRadian(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			return getRadian(dx, dy);
		}
		
		/**
		 * 获取两点角度
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @return 
		 * 
		 */		
		public static function getTwoPointAngle(x1:Number, y1:Number, x2:Number, y2:Number):int {
			return radianToAngle(getTwoPointRadian(x1, y1, x2, y2));
		}
		
		/**
		 * 获取两点距离
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @return 
		 * 
		 */		
		public static function getDistance(x1:Number, y1:Number, x2:Number, y2:Number):Number {
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		/**
		 * 根据长度获取直角边长
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @param length
		 * @return 
		 * 
		 */		
		public static function getRightAngleSide(x1:Number, y1:Number, x2:Number, y2:Number, length:Number):Point {
			var angle:int = MathUtil.getTwoPointAngle(x1, y1, x2, y2);
			var xx:Number = length * cos(angle);
			var yy:Number = length * sin(angle);
			return new Point(xx, yy);
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
		
		/**
		 * 根据弧度获取距离点(x, y)length长度的点
		 * @param x
		 * @param y
		 * @param length
		 * @param angle
		 * @return 
		 * 
		 */		
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
		
		/**
		 * 换算代为
		 * @param num
		 * @param unit
		 * @param unitString
		 * @return 
		 * 
		 */		
		public static function convertUtils(num:Number, unit:Number, unitString:String):String {
			return int(num / unit) + unitString;
		}
	}
}