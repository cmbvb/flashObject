package role.constants
{
	import com.canaan.lib.role.constants.TypeRoleDirection;
	
	import flash.utils.Dictionary;

	/**
	 * 渲染组件枚举
	 * @author Administrator
	 * 
	 */	
	public class TypeRenderPart
	{
		public static const WING:int = 0;									// 翅膀
		public static const MOUNTS:int = 1;									// 坐骑
		public static const CLOTHES:int = 2;								// 皮肤
		public static const WEAPON:int = 3;									// 武器
		public static const WEAPON_EFFECT:int = 4;							// 武器特效
		public static const SHIELD:int = 5;									// 盾牌
		
		public static const DEPTH:Dictionary = new Dictionary();
		public static const DEPTH_VALUE:Dictionary = new Dictionary();
		
		DEPTH_VALUE[TypeRoleDirection.UP] = 1;
		DEPTH_VALUE[TypeRoleDirection.RIGHT_UP] = 2;
		DEPTH_VALUE[TypeRoleDirection.RIGHT] = 2;
		DEPTH_VALUE[TypeRoleDirection.RIGHT_DOWN] = 3;
		DEPTH_VALUE[TypeRoleDirection.DOWN] = 3;
		DEPTH_VALUE[TypeRoleDirection.LEFT_DOWN] = 3;
		DEPTH_VALUE[TypeRoleDirection.LEFT] = 1;
		DEPTH_VALUE[TypeRoleDirection.LEFT_UP] = 1;
		
		DEPTH[TypeRoleDirection.UP] = [
			WEAPON,
			WEAPON_EFFECT,
			CLOTHES,
			WING
		];
		
		DEPTH[TypeRoleDirection.RIGHT] = [
			CLOTHES,
			WEAPON,
			WEAPON_EFFECT,
			WING
		];
		
		DEPTH[TypeRoleDirection.DOWN] = [
			WING,
			CLOTHES,
			WEAPON,
			WEAPON_EFFECT,
		];
		
		DEPTH[TypeRoleDirection.RIGHT_DOWN] = DEPTH[TypeRoleDirection.LEFT_DOWN] = DEPTH[TypeRoleDirection.DOWN];
		DEPTH[TypeRoleDirection.LEFT_UP] = DEPTH[TypeRoleDirection.LEFT] = DEPTH[TypeRoleDirection.UP];
		DEPTH[TypeRoleDirection.RIGHT_UP] = DEPTH[TypeRoleDirection.RIGHT];
		
		/**
		 * 深度是否改变
		 * @param lastDirection
		 * @param currentDirection
		 * @return 
		 * 
		 */		
		public static function isDepthChange(lastDirection:int, currentDirection:int):Boolean {
			return DEPTH_VALUE[lastDirection] != DEPTH_VALUE[currentDirection];
		}
		
		/**
		 * 根据角色方向和渲染部件类型获取深度
		 * @param direction
		 * @param type
		 * @return 
		 * 
		 */		
		public static function getDepth(direction:int, type:int):int {
			if (direction == 0) {
				direction = TypeRoleDirection.DOWN;
			}
			return DEPTH[direction].indexOf(type);
		}
	}
}