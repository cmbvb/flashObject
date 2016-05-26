package com.canaan.lib.events
{
	import com.canaan.lib.component.controls.Dialog;
	
	import flash.events.Event;
	
	public class DialogEvent extends Event
	{
		public static const SHOW:String = "show";
		public static const CLOSE:String = "close";
		
		private var _dialog:Dialog;
		
		public function DialogEvent(type:String, dialog:Dialog)
		{
			super(type);
			_dialog = dialog;
		}

		public function get dialog():Dialog
		{
			return _dialog;
		}

		public function set dialog(value:Dialog):void
		{
			_dialog = value;
		}
	}
}