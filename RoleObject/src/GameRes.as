package
{
	public class GameRes
	{
		public static var root:String;						// 根目录
		public static var action:String;					// 角色动作目录
		
		public static var TBL_ACTION_RES:String = "ActionResTemple";			// 动作资源
		
		public static function init():void {
			action = "action/";
		}
		
	}
}