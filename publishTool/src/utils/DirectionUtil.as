package utils
{
	import flash.geom.Point;
	
	public class DirectionUtil
	{
		private static const SEGMENT_22_5:Number = 22.5;
		private static const SEGMENT_67_5:Number = 67.5;
		private static const SEGMENT_112_5:Number = 112.5;
		private static const SEGMENT_157_5:Number = 157.5;
		private static const SEGMENT_202_5:Number = 202.5;
		private static const SEGMENT_247_5:Number = 247.5;
		private static const SEGMENT_292_5:Number = 292.5;
		private static const SEGMENT_337_5:Number = 337.5;
		
		private static const SEGMENT_45:Number = 45;
		private static const SEGMENT_135:Number = 135;
		private static const SEGMENT_225:Number = 225;
		private static const SEGMENT_315:Number = 315;
		
		/**
		 * 获取2方向朝向
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @return 
		 * 
		 */		
		public static function getDirection2(x1:Number, y1:Number, x2:Number, y2:Number):int {
			return x2 >= x1 ? TypeRoleDirection.RIGHT : TypeRoleDirection.LEFT;
		}
		
		/**
		 * 获取4方向朝向
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @return 
		 * 
		 */		
		public static function getDirection4(x1:Number, y1:Number, x2:Number, y2:Number):int {
			if (x1 == x2) {
				if (y2 >= y1) {
					return TypeRoleDirection.DOWN;
				}
				return TypeRoleDirection.UP;
			} else if (y1 == y2) {
				if (x2 >= x1) {
					return TypeRoleDirection.RIGHT;
				}
				return TypeRoleDirection.LEFT;
			} else {
				var angle:Number = MathUtil.getUAngle(x2 - x1, y2 - y1);
				if (angle <= SEGMENT_45 || angle >= SEGMENT_315) {
					return TypeRoleDirection.RIGHT;
				} else if (angle >= SEGMENT_45 && angle <= SEGMENT_135) {
					return TypeRoleDirection.DOWN;
				} else if (angle >= SEGMENT_135 && angle <= SEGMENT_225) {
					return TypeRoleDirection.LEFT;
				} else if (angle >= SEGMENT_247_5 && angle <= SEGMENT_292_5) {
					return TypeRoleDirection.UP;
				} else if (angle >= SEGMENT_225 && angle <= SEGMENT_315) {
					return TypeRoleDirection.RIGHT_UP;
				}
				return TypeRoleDirection.DOWN;
			}
		}
		
		/**
		 * 获取8方向朝向
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @return 
		 * 
		 */		
		public static function getDirection8(x1:Number, y1:Number, x2:Number, y2:Number):int {
			if (x1 == x2) {
				if (y2 >= y1) {
					return TypeRoleDirection.DOWN;
				}
				return TypeRoleDirection.UP;
			} else if (y1 == y2) {
				if (x2 >= x1) {
					return TypeRoleDirection.RIGHT;
				}
				return TypeRoleDirection.LEFT;
			} else {
				var angle:Number = MathUtil.getUAngle(x2 - x1, y2 - y1);
				if (angle <= SEGMENT_22_5 || angle >= SEGMENT_337_5) {
					return TypeRoleDirection.RIGHT;
				} else if (angle >= SEGMENT_22_5 && angle <= SEGMENT_67_5) {
					return TypeRoleDirection.RIGHT_DOWN;
				} else if (angle >= SEGMENT_67_5 && angle <= SEGMENT_112_5) {
					return TypeRoleDirection.DOWN;
				} else if (angle >= SEGMENT_112_5 && angle <= SEGMENT_157_5) {
					return TypeRoleDirection.LEFT_DOWN;
				} else if (angle >= SEGMENT_157_5 && angle <= SEGMENT_202_5) {
					return TypeRoleDirection.LEFT;
				} else if (angle >= SEGMENT_202_5 && angle <= SEGMENT_247_5) {
					return TypeRoleDirection.LEFT_UP;
				} else if (angle >= SEGMENT_247_5 && angle <= SEGMENT_292_5) {
					return TypeRoleDirection.UP;
				} else if (angle >= SEGMENT_292_5 && angle <= SEGMENT_337_5) {
					return TypeRoleDirection.RIGHT_UP;
				}
				return TypeRoleDirection.DOWN;
			}
		}
		
		/**
		 * 根据朝向获取角度
		 * @param direction
		 * @return 
		 * 
		 */		
		public static function getDirectionDegree(direction:int):int {
			switch (direction) {
				case TypeRoleDirection.RIGHT:
					return 0;
				case TypeRoleDirection.RIGHT_DOWN:
					return 45;
				case TypeRoleDirection.DOWN:
					return 90;
				case TypeRoleDirection.LEFT_DOWN:
					return 135;
				case TypeRoleDirection.LEFT:
					return 180;
				case TypeRoleDirection.LEFT_UP:
					return 225;
				case TypeRoleDirection.UP:
					return 270;
				case TypeRoleDirection.RIGHT_UP:
					return 315;
			}
			return 0;
		}
		
		/**
		 * 根据坐标获取偏移系数(-1, 0, 1)
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @return 
		 * 
		 */		
		public static function getOffsetByPos(x1:Number, y1:Number, x2:Number, y2:Number):Point {
			var offset:Point = new Point();
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			if (dx > 0) {
				offset.x = 1;
			} else if (dx < 0) {
				offset.x = -1;
			} else {
				offset.x = 0;
			}
			if (dy > 0) {
				offset.y = 1;
			} else if (dx < 0) {
				offset.y = -1;
			} else {
				offset.y = 0;
			}
			return offset;
		}
		
		/**
		 * 根据方向获取偏移系数(-1, 0, 1)
		 * @param direction
		 * @return 
		 * 
		 */		
		public static function getOffsetByDirection(direction:int):Point {
			var offset:Point = new Point();
			switch (direction) {
				case TypeRoleDirection.RIGHT:
					offset.x = 1;
					break;
				case TypeRoleDirection.RIGHT_DOWN:
					offset.x = 1;
					offset.y = 1;
					break;
				case TypeRoleDirection.DOWN:
					offset.y = 1;
					break;
				case TypeRoleDirection.LEFT_DOWN:
					offset.x = -1;
					offset.y = 1;
					break;
				case TypeRoleDirection.LEFT:
					offset.x = -1;
					break;
				case TypeRoleDirection.LEFT_UP:
					offset.x = -1;
					offset.y = -1;
					break;
				case TypeRoleDirection.UP:
					offset.y = -1;
					break;
				case TypeRoleDirection.RIGHT_UP:
					offset.x = 1;
					offset.y = -1;
					break;
			}
			return offset;
		}
	}
}