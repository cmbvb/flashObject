package com.canaan.lib.managers
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	
	public class CursorManager extends Sprite
	{
		public static const CURSOR_DEFAULT:String = "default";
		
		private static var canInstantiate:Boolean;
        private static var instance:CursorManager;
        
        private var cursors:Dictionary = new Dictionary();
        private var _currentCursor:String = CURSOR_DEFAULT;
		
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
		
        public function addCursor(cursor:String, displayObject:DisplayObject):void {
        	cursors[cursor] = displayObject;
        }
        
        public function showCursor(cursor:String, showMouse:Boolean = false):void {
        	if (cursors[cursor] == null || currentCursor == cursor) {
        		return;
        	}
        	if (cursor == CURSOR_DEFAULT) {
        		showSystemCursor();
        		return;
        	}
        	if (showMouse) {
        		Mouse.show();
        	} else {
        		Mouse.hide();
        	}
        	removeCursor();
        	_currentCursor = cursor;
        	currentCursorDisplayObject.x = parent.mouseX;
        	currentCursorDisplayObject.y = parent.mouseY;
			addChild(currentCursorDisplayObject);
			StageManager.getInstance().registerHandler(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        }
        
        public function showSystemCursor():void {
        	removeCursor();
        	Mouse.show();
        }
        
        public function removeCursor():void {
        	if (_currentCursor != CURSOR_DEFAULT) {
				removeChild(currentCursorDisplayObject);
				StageManager.getInstance().deleteHandler(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        		_currentCursor = CURSOR_DEFAULT;
        	}
			Mouse.hide();
        }
        
        private function mouseMoveHandler():void {
        	currentCursorDisplayObject.x = mouseX;
        	currentCursorDisplayObject.y = mouseY;
        }
        
        public function get currentCursor():String {
        	return _currentCursor;
        }
        
        public function get currentCursorDisplayObject():DisplayObject {
        	return cursors[_currentCursor];
        }
	}
}