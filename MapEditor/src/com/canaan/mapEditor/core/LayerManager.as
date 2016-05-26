package com.canaan.mapEditor.core
{
	import com.canaan.lib.display.BaseSprite;
	import com.canaan.lib.managers.CursorManager;
	import com.canaan.lib.managers.DialogManager;
	import com.canaan.lib.managers.DragManager;
	import com.canaan.lib.managers.ToolTipManager;
	import com.canaan.mapEditor.view.common.CommonToolTip;
	
	import flash.display.DisplayObjectContainer;

	public class LayerManager
	{
		private static var canInstantiate:Boolean;
		private static var instance:LayerManager;
		
		private var mRoot:DisplayObjectContainer;
		
		private var _world:BaseSprite;
		private var _ui:BaseSprite;
		private var _log:BaseSprite;
		
		private var _mainUI:BaseSprite;
		private var _viewUI:BaseSprite;
		private var _dialog:BaseSprite;
		private var _drag:BaseSprite;
		private var _tip:BaseSprite;
		private var _loading:BaseSprite;
		private var _cursor:BaseSprite;
		
		public function LayerManager()
		{
			if (!canInstantiate) {
				throw new Error("Can not instantiate, use getInstance() instead.");
			}
		}
		
		public static function getInstance():LayerManager {
			if (instance == null) {
				canInstantiate = true;
				instance = new LayerManager();
				canInstantiate = false;
			}
			return instance;
		}
		
		public function initialize(root:DisplayObjectContainer):void {
			mRoot = root;
			
			_world = new BaseSprite();
			_ui = new BaseSprite();
			_log = new BaseSprite();
			
			mRoot.addChild(_world);
			mRoot.addChild(_ui);
			mRoot.addChild(_log);
			
			_mainUI = new BaseSprite();
			_viewUI = new BaseSprite();
			_dialog = new BaseSprite();
			_drag = new BaseSprite();
			_tip = new BaseSprite();
			_loading = new BaseSprite();
			_cursor = new BaseSprite();
			
			_ui.addChild(_mainUI);
			_ui.addChild(_viewUI);
			_ui.addChild(_dialog);
			_ui.addChild(_drag);
			_ui.addChild(_tip);
			_ui.addChild(_loading);
			_ui.addChild(_cursor);
			
			disableLayer(_drag);
			disableLayer(_tip);
			disableLayer(_loading);
			disableLayer(_cursor);
			
			_dialog.addChild(DialogManager.getInstance());
			_drag.addChild(DragManager.getInstance());
			_tip.addChild(ToolTipManager.getInstance());
			_cursor.addChild(CursorManager.getInstance());
			
			ToolTipManager.getInstance().toolTipClass = CommonToolTip;
		}
		
		public function enableLayer(layer:BaseSprite):void {
			layer.mouseEnabled = layer.mouseChildren = true;
		}
		
		public function disableLayer(layer:BaseSprite):void {
			layer.mouseEnabled = layer.mouseChildren = false;
		}

		public function get world():BaseSprite
		{
			return _world;
		}

		public function set world(value:BaseSprite):void
		{
			_world = value;
		}

		public function get ui():BaseSprite
		{
			return _ui;
		}

		public function set ui(value:BaseSprite):void
		{
			_ui = value;
		}

		public function get log():BaseSprite
		{
			return _log;
		}

		public function set log(value:BaseSprite):void
		{
			_log = value;
		}

		public function get mainUI():BaseSprite
		{
			return _mainUI;
		}

		public function set mainUI(value:BaseSprite):void
		{
			_mainUI = value;
		}

		public function get viewUI():BaseSprite
		{
			return _viewUI;
		}

		public function set viewUI(value:BaseSprite):void
		{
			_viewUI = value;
		}

		public function get dialog():BaseSprite
		{
			return _dialog;
		}

		public function set dialog(value:BaseSprite):void
		{
			_dialog = value;
		}

		public function get drag():BaseSprite
		{
			return _drag;
		}

		public function set drag(value:BaseSprite):void
		{
			_drag = value;
		}

		public function get tip():BaseSprite
		{
			return _tip;
		}

		public function set tip(value:BaseSprite):void
		{
			_tip = value;
		}

		public function get loading():BaseSprite
		{
			return _loading;
		}

		public function set loading(value:BaseSprite):void
		{
			_loading = value;
		}

		public function get cursor():BaseSprite
		{
			return _cursor;
		}

		public function set cursor(value:BaseSprite):void
		{
			_cursor = value;
		}
	}
}