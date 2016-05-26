package
{
	import com.canaan.lib.core.Application;
	import com.canaan.lib.core.Config;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.debug.Stats;
	import com.canaan.lib.managers.TimerManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import role.objectPart.RoleBodyPart;
	
	public class RoleObject extends Sprite
	{
		public function RoleObject()
		{
			Config.setConfig("tablePackage", "table");	// 配置表包
			Config.setConfig("fps", 30);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function callBack():void {
			TimerManager.getInstance().initialize();
			var stats:Stats = new Stats();
			addChild(stats);
			for (var i:int = 0; i < 400; i++) {
				var roleView:RoleBodyPart = new RoleBodyPart();
				addChild(roleView);
				roleView.moveTo(300, 100);
			}
		}
		
		private function onAdded(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			GameRes.init();
			Application.initialize(this);
			Application.loadConfig("config.byte", new Method(callBack));
		}
		
	}
}