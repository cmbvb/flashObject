package com.canaan.lib.utils
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class TextUtil
	{
		public static const TEXT_WIDTH_PADDING:Number = 5;
		private static var gTextField:TextField = new TextField();

		/**
		 * 截断字符串
		 * 
		 */
		public static function truncateToFit(textField:TextField, maxWidth:Number, ellipsis:String = "..."):Boolean {
		    var originalText:String = textField.text;
		    var w:Number = maxWidth;
		    
		    if (originalText != "" && textField.textWidth + TEXT_WIDTH_PADDING > w + 0.00000000000001) {
		        var s:String = textField.text = originalText;
	            originalText.slice(0, Math.floor((w / (textField.textWidth + TEXT_WIDTH_PADDING)) * originalText.length));
		
		        while (s.length > 1 && textField.textWidth + TEXT_WIDTH_PADDING > w) {
		            s = s.slice(0, -1);
		            textField.text = s + ellipsis;
		        }
		        
		        return true;
		    }
		    return false;
		}
		
		public static function getHtmlText(text:String, color:String = "#FFFFFF", underLine:Boolean = false, fontSize:int = 12):String {
			var htmlText:String = text;
			if (underLine) {
				htmlText = "<u>" + text + "</u>";
			}
			htmlText = "<font color=\"" + color + "\" size='" + fontSize + "'>" + htmlText + "</font>";
			return htmlText;
		}
		
		public static function getHtmlTextHex(text:String, color:uint = 0xFFFFFF, underLine:Boolean = false, fontSize:int = 12):String {
			return getHtmlText(text, MathUtil.toHex(color), underLine, fontSize);
		}
		
		public static function getLinkText(text:String, param : String, underLine:Boolean = true):String
		{
			var tempStr : String = text;
			if (underLine)
			{
				tempStr = "<u>" + text + "</u>";
			}
			return "<a href=\"event:" + param + "\">" + tempStr + "</a>";
		}
		
		public static function getTextField(format:TextFormat, text:String = "Test"):TextField {
			gTextField.autoSize = "left";
			gTextField.defaultTextFormat = format;
			gTextField.text = text;
			return gTextField;
		}
		
		/**
		 * 聊天显示tips的超链接 
		 * @param linkType			链接类型
		 * @param linkContent		链接功能可能需要的内容, 比如人名、物品Id等
		 * @return 
		 * 
		 */		
		public static function getChatTipLinkText(strText:String, strLinkType:int, strLinkContent:String = null, bUnderLine:Boolean = true):String
		{	
			var strTextEvent:String = "linkType_" + strLinkType; 
			if(strLinkContent)
			{
				strTextEvent += "*linkContent_" + strLinkContent; 
			}
			return getLinkText(strText, strTextEvent, bUnderLine);
		}
	}
}