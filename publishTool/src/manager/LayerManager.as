package manager
{
	import flash.display.Sprite;

	public class LayerManager extends Sprite
	{
		private static var _ins:LayerManager;
		private var _map:Sprite;
		private var _ui:Sprite;
		private var _notice:Sprite;
		private var _mainUI:Sprite;
		
		public function LayerManager()
		{
		}
		
		public static function get ins():LayerManager {
			if (_ins == null) {
				_ins = new LayerManager();
			}
			return _ins;
		}
		
		public function init():void {
			_map = new Sprite();
			_ui = new Sprite();
			_notice = new Sprite();
			_mainUI = new Sprite();
			
			this.addChild(_map);
			this.addChild(_ui);
			this.addChild(_notice);
			_ui.addChild(_mainUI);
		}
		
		public function get map():Sprite {
			return _map;
		}
		
		public function get ui():Sprite {
			return _ui;
		}
		
		public function get notice():Sprite {
			return _notice;
		}
		
		public function get mainUI():Sprite {
			return _mainUI;
		}
		
	}
}