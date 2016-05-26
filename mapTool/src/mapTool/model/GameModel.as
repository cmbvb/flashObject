package mapTool.model
{
	import mapTool.model.entities.ModelMap;

	public class GameModel
	{
		public static var modelMap:ModelMap;
		
		public function GameModel()
		{
			
		}
		
		public static function init():void {
			modelMap = new ModelMap();
		}
		
	}
}