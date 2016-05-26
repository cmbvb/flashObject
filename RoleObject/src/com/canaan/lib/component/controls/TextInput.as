/**
 * Morn UI Version 2.1.0623 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package com.canaan.lib.component.controls {
	import com.canaan.lib.managers.KeyboardManager;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.TextEvent;
	import flash.text.TextFieldType;
	
	/**当用户输入文本时调度*/
	[Event(name="textInput",type="flash.events.TextEvent")]
	
	/**输入框*/
	public class TextInput extends Label {
		
		public function TextInput(text:String = "", skin:String = null) {
			super(text, skin);
		}
		
		override protected function initialize():void {
			super.initialize();
			width = 128;
			height = 22;
			selectable = true;
			_textField.type = TextFieldType.INPUT;
			_textField.autoSize = "none";
			_textField.addEventListener(Event.CHANGE, onTextFieldChange);
			_textField.addEventListener(TextEvent.TEXT_INPUT, onTextFieldTextInput);
			_textField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			_textField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		}
		
		private function onTextFieldTextInput(e:TextEvent):void {
			dispatchEvent(e);
		}
		
		protected function onTextFieldChange(e:Event):void {
			text = _textField.text;
			dispatchEvent(e);
		}
		
		protected function onFocusIn(event:FocusEvent = null):void {
			KeyboardManager.getInstance().enabled = false;
		}
		
		protected function onFocusOut(event:FocusEvent = null):void {
			KeyboardManager.getInstance().enabled = true;
		}
		
		/**指示用户可以输入到控件的字符集*/
		public function get restrict():String {
			return _textField.restrict;
		}
		
		public function set restrict(value:String):void {
			_textField.restrict = value;
		}
		
		/**是否可编辑*/
		public function get editable():Boolean {
			return _textField.type == TextFieldType.INPUT;
		}
		
		public function set editable(value:Boolean):void {
			_textField.type = value ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
		}
		
		/**最多可包含的字符数*/
		public function get maxChars():int {
			return _textField.maxChars;
		}
		
		public function set maxChars(value:int):void {
			_textField.maxChars = value;
		}
	}
}