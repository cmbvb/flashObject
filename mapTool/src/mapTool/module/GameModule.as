package mapTool.module
{
	import mapTool.module.mainUI.ModuleMainUI;

	public class GameModule
	{
		private static var _ins:GameModule
		public var moduleMainUI:ModuleMainUI;
		
		public function GameModule()
		{
		}
		
		public function init():void {
			moduleMainUI = new ModuleMainUI();
		}
		
		public static function get ins():GameModule {
			if (_ins == null) {
				_ins = new GameModule();
			}
			return _ins;
		}
		
	}
}