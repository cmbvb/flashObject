package com.canaan.programEditor.view.common
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.KeyboardManager;
	import com.canaan.programEditor.ui.common.AlertUI;
	
	import flash.ui.Keyboard;
	
	public class Alert extends AlertUI
	{
		public static const TYPE_OK:int = 1;
		public static const TYPE_ACCEPT_CANCEL:int = 2;
		
		private static var alert:Alert;
		
		private var mSureCallback:Method;
		private var mCancelCallback:Method;
		
		public function Alert()
		{
			super();
		}
		
		public static function show(text:String = "", type:int = 1, sureCallback:Method = null, cancelCallback:Method = null, showAnimation:Boolean = true):void {
			if (alert == null) {
				alert = new Alert();
			}
			alert.showText(text, type, sureCallback, cancelCallback);
			alert.popup(true, false, null, NaN, NaN, showAnimation);
		}
		
		public static function hide():void {
			if (alert != null) {
				alert.close();
			}
		}
		
		/**
		 * 显示提示
		 * @param text
		 * @param type
		 * @param sureCallback
		 * @param cancelCallback
		 * 
		 */		
		public function showText(text:String = "", type:int = 1, sureCallback:Method = null, cancelCallback:Method = null):void {
			lblText.text = text;
			mSureCallback = sureCallback;
			mCancelCallback = cancelCallback;
			if (type == TYPE_OK) {
				btnCancel.remove();
			} else {
				hbox.addChild(btnCancel);
			}
			hbox.x = (width - hbox.width) / 2;
			KeyboardManager.getInstance().registerHandler(Keyboard.ESCAPE, false, close);
			KeyboardManager.getInstance().registerHandler(Keyboard.ENTER, false, close);
		}
		
		override public function close(type:String=null):void {
			super.close(type);
			switch (type) {
				case "close":
				case "cancel":
					if (mCancelCallback != null) {
						mCancelCallback.apply();
					}
					break;
				case "sure":
					if (mSureCallback != null) {
						mSureCallback.apply();
					}
					break;
			}
			KeyboardManager.getInstance().deleteHandler(Keyboard.ESCAPE, false, close);
			KeyboardManager.getInstance().deleteHandler(Keyboard.ENTER, false, close);
		}
	}
}