package com.canaan.lib.managers
{
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	import flash.utils.Dictionary;
	
	public class CursorManager extends Sprite
	{
		public static const CURSOR_SYSTEM:String = "system";
		
		private static var canInstantiate:Boolean;
        private static var instance:CursorManager;
        
        private var cursors:Dictionary = new Dictionary();
        private var _currentCursor:String = CURSOR_SYSTEM;
		private var _currentCursorData:MouseCursorData;
		
		public function CursorManager()
		{
			if (!canInstantiate) {
				throw new Error("Can not instantiate, use getInstance() instead.");
			}
			mouseEnabled = false;
			mouseChildren = false;
		}

		public static function getInstance():CursorManager {
            if (instance == null) {
            	canInstantiate = true;
                instance = new CursorManager();
                canInstantiate = false;
            }
            return instance;
        }
		
        public function addCursor(cursor:String, displayObject:IBitmapDrawable):void {
			var mouseCursorData:MouseCursorData = new MouseCursorData();
			var bitmapDatas:Vector.<BitmapData> = new Vector.<BitmapData>();
			var bitmapData:BitmapData = new BitmapData(32, 32, true, 0x000000);
			var width:Number = Object(displayObject).width;
			var height:Number = Object(displayObject).height;
			bitmapData.draw(displayObject, new Matrix(32 / width, 0, 0, 32 / height));
			bitmapDatas.push(bitmapData);
			mouseCursorData.data = bitmapDatas;
			cursors[cursor] = mouseCursorData;
			Mouse.registerCursor(cursor, mouseCursorData);
        }
        
        public function showCursor(cursor:String):void {
        	if (cursors[cursor] == null || currentCursor == cursor) {
        		return;
        	}
        	if (cursor == CURSOR_SYSTEM) {
        		showSystemCursor();
        		return;
        	}
        	_currentCursor = cursor;
			_currentCursorData = cursors[cursor];
			Mouse.cursor = _currentCursor;
        }
        
        public function showSystemCursor():void {
			if (_currentCursor != CURSOR_SYSTEM) {
				Mouse.cursor = MouseCursor.ARROW;
				_currentCursor = CURSOR_SYSTEM;
				_currentCursorData = null;
			}
        }
        
        public function get currentCursor():String {
        	return _currentCursor;
        }
        
        public function get currentCursorData():MouseCursorData {
        	return _currentCursorData;
        }
	}
}