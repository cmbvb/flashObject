package com.canaan.lib.role.utils
{
	import com.canaan.lib.role.constants.TypeRoleDirection;
	import com.canaan.lib.utils.MathUtil;
	
	import flash.geom.Point;
	
	public class DirectionUtil
	{	
		/**
		 * 获取相反方向
		 * @param direction
		 * @return 
		 * 
		 */		
		public static function getOppositeDirection(direction:int):int {
			var oppositeDirection:int = direction + 4;
			if (oppositeDirection > TypeRoleDirection.LEFT_UP) {
				oppositeDirection -= TypeRoleDirection.LEFT_UP;
			}
			return oppositeDirection;
		}
		
		/**
		 * 获取镜像方向
		 * @param direction
		 * @return 
		 * 
		 */		
		public static function getCopyDirection(direction:int):int {
			switch (direction) {
				case TypeRoleDirection.LEFT_DOWN:
					direction = TypeRoleDirection.RIGHT_DOWN;
					break;
				case TypeRoleDirection.LEFT:
					direction = TypeRoleDirection.RIGHT;
					break;
				case TypeRoleDirection.LEFT_UP:
					direction = TypeRoleDirection.RIGHT_UP;
					break;
			}
			return direction;
		}
		
		/**
		 * 获取前一个方向
		 * @param direction
		 * @return 
		 * 
		 */		
		public static function getPreviousDirection(direction:int):int {
			var previousDirection:int = direction - 1;
			if (previousDirection < TypeRoleDirection.UP) {
				previousDirection = TypeRoleDirection.LEFT_UP;
			}
			return previousDirection;
		}
		
		/**
		 * 获取后一个方向
		 * @param direction
		 * @return 
		 * 
		 */		
		public static function getNextDirection(direction:int):int {
			var nextDirection:int = direction + 1;
			if (nextDirection > TypeRoleDirection.LEFT_UP) {
				nextDirection = TypeRoleDirection.UP;
			}
			return nextDirection;
		}
		
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
				if (angle <= TypeRoleDirection.SEGMENT_45 || angle >= TypeRoleDirection.SEGMENT_315) {
					return TypeRoleDirection.RIGHT;
				} else if (angle >= TypeRoleDirection.SEGMENT_45 && angle <= TypeRoleDirection.SEGMENT_135) {
					return TypeRoleDirection.DOWN;
				} else if (angle >= TypeRoleDirection.SEGMENT_135 && angle <= TypeRoleDirection.SEGMENT_225) {
					return TypeRoleDirection.LEFT;
				} else if (angle >= TypeRoleDirection.SEGMENT_247_5 && angle <= TypeRoleDirection.SEGMENT_292_5) {
					return TypeRoleDirection.UP;
				} else if (angle >= TypeRoleDirection.SEGMENT_225 && angle <= TypeRoleDirection.SEGMENT_315) {
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
		public static function getTileDirection8(x1:Number, y1:Number, x2:Number, y2:Number):int {
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
				if (angle <= TypeRoleDirection.SEGMENT_22_5 || angle >= TypeRoleDirection.SEGMENT_337_5) {
					return TypeRoleDirection.RIGHT;
				} else if (angle >= TypeRoleDirection.SEGMENT_22_5 && angle <= TypeRoleDirection.SEGMENT_67_5) {
					return TypeRoleDirection.RIGHT_DOWN;
				} else if (angle >= TypeRoleDirection.SEGMENT_67_5 && angle <= TypeRoleDirection.SEGMENT_112_5) {
					return TypeRoleDirection.DOWN;
				} else if (angle >= TypeRoleDirection.SEGMENT_112_5 && angle <= TypeRoleDirection.SEGMENT_157_5) {
					return TypeRoleDirection.LEFT_DOWN;
				} else if (angle >= TypeRoleDirection.SEGMENT_157_5 && angle <= TypeRoleDirection.SEGMENT_202_5) {
					return TypeRoleDirection.LEFT;
				} else if (angle >= TypeRoleDirection.SEGMENT_202_5 && angle <= TypeRoleDirection.SEGMENT_247_5) {
					return TypeRoleDirection.LEFT_UP;
				} else if (angle >= TypeRoleDirection.SEGMENT_247_5 && angle <= TypeRoleDirection.SEGMENT_292_5) {
					return TypeRoleDirection.UP;
				} else if (angle >= TypeRoleDirection.SEGMENT_292_5 && angle <= TypeRoleDirection.SEGMENT_337_5) {
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
		public static function getRealDirection8(x1:Number, y1:Number, x2:Number, y2:Number):int {
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
				if (angle <= TypeRoleDirection.SEGMENT_28 || angle >= TypeRoleDirection.SEGMENT_332) {
					return TypeRoleDirection.RIGHT;
				} else if (angle >= TypeRoleDirection.SEGMENT_28 && angle <= TypeRoleDirection.SEGMENT_73) {
					return TypeRoleDirection.RIGHT_DOWN;
				} else if (angle >= TypeRoleDirection.SEGMENT_73 && angle <= TypeRoleDirection.SEGMENT_107) {
					return TypeRoleDirection.DOWN;
				} else if (angle >= TypeRoleDirection.SEGMENT_107 && angle <= TypeRoleDirection.SEGMENT_152) {
					return TypeRoleDirection.LEFT_DOWN;
				} else if (angle >= TypeRoleDirection.SEGMENT_152 && angle <= TypeRoleDirection.SEGMENT_208) {
					return TypeRoleDirection.LEFT;
				} else if (angle >= TypeRoleDirection.SEGMENT_208 && angle <= TypeRoleDirection.SEGMENT_253) {
					return TypeRoleDirection.LEFT_UP;
				} else if (angle >= TypeRoleDirection.SEGMENT_253 && angle <= TypeRoleDirection.SEGMENT_287) {
					return TypeRoleDirection.UP;
				} else if (angle >= TypeRoleDirection.SEGMENT_287 && angle <= TypeRoleDirection.SEGMENT_332) {
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