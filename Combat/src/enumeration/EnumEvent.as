package enumeration
{
	import flash.events.Event;
	
	public class EnumEvent extends Event
	{
		public static const ASSETS_LOAD_COMPLETE:String = "assetsLoadComplete";						// 加载资源完毕
		
		// change event
		public static const ROLE_MOVE_EVENT:String = "roleMoveEvent";								// 角色移动事件
//		public static const ROLE_IDLE_EVENT:String = "roleIdleEvent";								// 角色空闲事件
		public static const ROLE_JUMP_EVENT:String = "roleJumpEvent";								// 角色跳跃事件
//		public static const ROLE_FALL_EVENT:String = "roleFallEvent";								// 角色下落事件
		public static const ROLE_SKILL_EVENT:String = "roleSkillEvent";								// 角色普攻事件
		
		// end event
		public static const ROLE_MOVEEND_EVENT:String = "roleMoveEndEvent";							// 角色移动结束事件
//		public static const ROLE_JUMPEND_EVENT:String = "roleJumpEndEvent";							// 角色跳跃结束事件
//		public static const ROLE_FALLEND_EVENT:String = "roleFallEndEvent";							// 角色下落结束事件
		
		private var _data:Object;
		
		public function EnumEvent(type:String, data:Object = null)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		public function get data():Object {
			return _data;
		}
		
	}
}