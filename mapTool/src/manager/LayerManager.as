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
		private var _dialog:Sprite;
		private var _drag:Sprite;
		private var _tip:Sprite;
		
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
			
			App.stage.addChild(_map);
			App.stage.addChild(_ui);
			App.stage.addChild(_notice);
			
			_mainUI = new Sprite();
			_dialog = new Sprite();
			_drag = new Sprite();
			_tip = new Sprite();
			
			_ui.addChild(_mainUI);
			_ui.addChild(_dialog);
			_ui.addChild(_drag);
			_ui.addChild(_tip);
			_dialog.addChild(App.dialog);
			_drag.addChild(App.drag);
			_tip.addChild(App.tip);
		}

		public function get map():Sprite
		{
			return _map;
		}

		public function get mainUI():Sprite
		{
			return _mainUI;
		}

		public function get notice():Sprite
		{
			return _notice;
		}

		
	}
}