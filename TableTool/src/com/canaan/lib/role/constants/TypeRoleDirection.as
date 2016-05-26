package com.canaan.lib.role.constants
{
	public class TypeRoleDirection
	{
		public static const UP:int = 1;
		public static const RIGHT_UP:int = 2;
		public static const RIGHT:int = 3;
		public static const RIGHT_DOWN:int = 4;
		public static const DOWN:int = 5;
		public static const LEFT_DOWN:int = 6;
		public static const LEFT:int = 7;
		public static const LEFT_UP:int = 8;
		
		public static function getOppositeDirection(direction:int):int {
			var oppositeDirection:int = direction + 4;
			if (oppositeDirection > LEFT_UP) {
				oppositeDirection -= LEFT_UP;
			}
			return oppositeDirection;
		}
		
		public static function getCopyDirection(direction:int):int {
			switch (direction) {
				case LEFT_DOWN:
					direction = RIGHT_DOWN;
					break;
				case LEFT:
					direction = RIGHT;
					break;
				case LEFT_UP:
					direction = RIGHT_UP;
					break;
			}
			return direction;
		}
	}
}