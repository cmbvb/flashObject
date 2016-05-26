package modules
{
	import modules.map.MapControl;
	import modules.map.ModuleMap;

	public class GameModules
	{
		public static var modelMap:ModuleMap;
		public static var mapControl:MapControl;
		
		public function GameModules()
		{
		}
		
		public static function init():void {
			modelMap = new ModuleMap();
			mapControl = new MapControl();
			mapControl.init();
		}
		
	}
}