package models
{
	import models.entities.ModelMap;

	public class GameModels
	{
		public static var modelMap:ModelMap;
		
		public function GameModels()
		{
		}
		
		public static function init():void {
			modelMap = new ModelMap();
		}
		
	}
}