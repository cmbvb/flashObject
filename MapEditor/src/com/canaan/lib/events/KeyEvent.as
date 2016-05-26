package com.canaan.lib.events
{
	import flash.events.Event;

	public class KeyEvent extends Event
	{
		public static const KEY_DOWN:String = "keyDown";
		public static const KEY_UP:String = "keyUp";
		public static const KEY_DOWN_CTRL:String = "keyDownCtrl";
		public static const KEY_UP_CTRL:String = "keyUpCtrl";
		public static const KEY_DOWN_SHIFT:String = "keyDownShift";
		public static const KEY_UP_SHIFT:String = "keyUpShift";
		public static const KEY_DOWN_CTRL_SHIFT:String = "keyDownCtrlShift";
		public static const KEY_UP_CTRL_SHIFT:String = "keyUpCtrlShift";
		
		private var _keyCode:uint;
		private var _charCode:uint;
		private var _keyLocation:uint;
		private var _ctrlKey:Boolean;
		private var _shiftKey:Boolean;
		private var _altKey:Boolean;
		
		public function KeyEvent(type:String, keyCode:uint, charCode:uint,
								 keyLocation:uint, ctrlKey:Boolean,
								 shiftKey:Boolean, altKey:Boolean)
		{
			super(type);
			_keyCode = keyCode;
			_charCode = charCode;
			_keyLocation = keyLocation;
			_ctrlKey = ctrlKey;
			_shiftKey = shiftKey;
			_altKey = altKey;
		}
		
		public function get keyCode():uint {
			return _keyCode;
		}
		
		public function get charCode():uint {
			return _charCode;
		}
		
		public function get keyLocation():uint {
			return _keyLocation;
		}
		
		public function get ctrlKey():Boolean {
			return _ctrlKey;
		}
		
		public function get shiftKey():Boolean {
			return _shiftKey;
		}
		
		public function get altKey():Boolean {
			return _altKey;
		}
	}
}