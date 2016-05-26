package com.canaan.programEditor.utils
{
	public class XmlCodeFilter
	{
		public static var textColor:String = "#000000";
		public static var commentColor:String = "#3f5fbf";
		public static var tagColor:String = "#3f7f5f";
		public static var attributeColor:String = "#7f0055";
		public static var equalColor:String = "#000000";
		public static var stringColor:String = "#2a00ff";
		public static var entityColor:String = "#2a00ff";
		public static var dataColor:String = "#3f7f5f";
		
		public static function filter(text:String):String {
			var result:String = text;
			// 过滤CDATA
			// TODO 应该文本化CDATA里面的标签
			result = result.replace(new RegExp("<!\\[CDATA\\[([^(\\]\\])]*)\\]\\]>", "g"), "[datatempfont][lesstempsign]![CDATA[[/endtempfont]$1[datatempfont]]][greattempsign][/endtempfont]");
			// 过滤注释
			result = result.replace(new RegExp("<!--([^(\\-\\->)]*)-->", "g"), "[commenttempfont][lesstempsign]!--$1--[greattempsign][/endtempfont]");
			// 过滤标签
			result = result.replace(new RegExp("<([^(<|>)]+)>", "g"), "[tagtempfont][lesstempsign]$1[greattempsign]</font>");
			// 过滤属性(双引号)
			// TODO 单双引号应改为反向引用方式
			result = result.replace(new RegExp("(\\s+)([\\w|:]+)(\\s*)\\=(\\s*)(\"[^\"]*\")", "g"), "$1[attributetempfont]$2</font>$3[equaltempfont]=</font>$4[stringtempfont]$5</font>");
			// 过滤属性(单引号)
			result = result.replace(new RegExp("(\\s+)([\\w|:]+)(\\s*)\\=(\\s*)(\'[^\']*\')", "g"), "$1[attributetempfont]$2</font>$3[equaltempfont]=</font>$4[stringtempfont]$5</font>");
			// 过滤&amp;符号
			//result = result.replace("&amp;", "&amp;amp;");
			// 过滤dtd实体
			result = result.replace(new RegExp("(&amp;amp;[A-Z|a-z]+;)", "g"), "[entitytempfont]$1</font>");
			// 过滤HtmlUnicode转码
			result = result.replace(new RegExp("(&amp;amp;#[0-9]+;)", "g"), "[entitytempfont]$1</font>");
			// 过滤空格
			result = result.replace(new RegExp(" ", "g"), " ");
			// 过滤缩进
			result = result.replace(new RegExp("\t", "g"), "    ");
			// 过滤Winodws换行
			result = result.replace(new RegExp("\r\n", "g"), "\n");
			// 过滤换行
			result = result.replace(new RegExp("\n", "g"), "\n");
			// 下面的替换把上面作的标记换成相应颜色
			result = result.replace(new RegExp("\\[lesstempsign\\]", "g"), "&lt;");
			result = result.replace(new RegExp("\\[greattempsign\\]", "g"), "&gt;");
			result = result.replace(new RegExp("\\[/endtempfont\\]", "g"), "</font>");
			result = result.replace(new RegExp("\\[commenttempfont\\]", "g"), "<font color=\"" + commentColor + "\">");
			result = result.replace(new RegExp("\\[datatempfont\\]", "g"), "<font color=\"" + dataColor + "\">");
			result = result.replace(new RegExp("\\[tagtempfont\\]", "g"), "<font color=\"" + tagColor + "\">");
			result = result.replace(new RegExp("\\[attributetempfont\\]", "g"), "<font color=\"" + attributeColor + "\">");
			result = result.replace(new RegExp("\\[equaltempfont\\]", "g"), "<font color=\"" + equalColor + "\">");
			result = result.replace(new RegExp("\\[stringtempfont\\]", "g"), "<font color=\"" + stringColor + "\">");
			result = result.replace(new RegExp("\\[entitytempfont\\]", "g"), "<font color=\"" + entityColor + "\">");
			return result; 
		}
	}
}