package com.canaan.lib.utils
{
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	public class FontUtil
	{
		private static var cache:Dictionary = new Dictionary();
		
		public static function registerFont(clazz:Class, id:String):void {
			Font.registerFont(clazz);
			cache[id] = new clazz();
		}
		
		public static function getFont(id:String):Font {
			return cache[id];
		}
		
		public static function setFont(textField:TextField, id:String):void {
			var font:Font = cache[id];
			if (!font) {
				return;
			}
			textField.embedFonts = true;
			var textFormat:TextFormat = textField.defaultTextFormat;
			textFormat.font = font.fontName;
			textField.defaultTextFormat = textFormat;
			textField.setTextFormat(textFormat);
		}
	}
}