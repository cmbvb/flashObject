package com.canaan.programEditor.utils
{
	import com.canaan.lib.utils.ArrayUtil;
	import com.canaan.lib.utils.BooleanUtil;

	public class TableUtil
	{
		public static var wrap:String = "\r\n";
		public static var separator:String = "\t";
		public static var quote:String = "\"";
		public static var doubleQuotes:String = "\"\"";
		public static var quoteReg:RegExp = /""/g;
		public static var doubleQuotesReg:RegExp = /\"/g;
		public static var splitReg:RegExp = /"?\t(?=[^"]*(?:(?:"[^"]*){2})*$)"?/; 
		
		private static function escape(value:String):String {
			return value.replace(quoteReg, quote);
		}
		
		private static function eacapeForEach(element:String, index:int, array:Array):void {
			element = escape(element);
			var searchIndex:int;
			if (index == 0) {
				searchIndex = element.indexOf(quote);
				if (searchIndex == 0) {
					element = element.substring(1);
				}
			} else if (index == array.length - 1) {
				searchIndex = element.lastIndexOf(quote);
				if (searchIndex == element.length - 1) {
					element = element.substring(0, searchIndex);
				}
			}
			array[index] = element;
		}
		
		public static function getTitles(xls:String):Array {
			var result:Array;
			var lines:Array = xls.split(wrap);
			if (lines.length > 0) {
				result = lines[0].split(splitReg);
				result.forEach(eacapeForEach);
			}
			return result;
		}

		
		public static function XLSToArray(xls:String):Array {
			var result:Array = [];
			if (xls) {
				var lines:Array = xls.split(wrap);
				// remove the first line title
				var keys:Array = lines.shift().split(splitReg);
				keys.forEach(eacapeForEach);
				var line:String;
				var values:Array;
				var object:Object;
				for each (line in lines) {
					if (line == "") {
						continue;
					}
					values = line.split(splitReg);
					values.forEach(eacapeForEach);
					object = {};
					for (var i:int = 0; i < keys.length; i++) {
						object[keys[i]] = values[i];
					}
					result.push(object);
				}
			}
			return result;
		}
		
		public static function XLSToVector(xls:String):Vector.<Object> {
			var result:Vector.<Object> = new Vector.<Object>();
			if (xls) {
				var lines:Array = xls.split(wrap);
				// remove the first line title
				var keys:Array = lines.shift().split(splitReg);
				keys.forEach(eacapeForEach);
				var line:String;
				var values:Array;
				var object:Object;
				for each (line in lines) {
					if (line == "") {
						continue;
					}
					values = line.split(splitReg);
					values.forEach(eacapeForEach);
					object = {};
					for (var i:int = 0; i < keys.length; i++) {
						object[keys[i]] = values[i];
					}
					result.push(object);
				}
			}
			return result;
		}
		
		public static function XLSToObject(xls:String, key:* = null):Object {
			var xlsVector:Vector.<Object> = XLSToVector(xls);
			if (key != null) {
				if (key is Array) {
					return ArrayUtil.arrayToObjectMultiKey(xlsVector, key);
				} else if (key is String) {
					return ArrayUtil.arrayToObject(xlsVector, key);
				}
			} else {
				var titles:Array = getTitles(xls);
				return ArrayUtil.arrayToObject(xlsVector, titles[0]);
			}
			return null;
		}
		
		private static function createLine(value:Array):String {
			var result:String = "";
			var str:String;
			var l:int = value.length;
			for (var i:int = 0; i < l; i++) {
				str = value[i];
				if (str.indexOf(separator) != -1 || str.indexOf(quote) != -1) {
					str = str.replace(doubleQuotesReg, doubleQuotes);
					str = quote + str + quote;
				}
				result += str;
				if (i != value.length - 1) {
					result += separator;
				}
			}
			return result;
		}
		
		public static function ArrayToXLS(desc:Array, titles:Array, types:Array, source:Array = null):String {
			if (titles == null || titles.length == 0) {
				return null;
			}
			
			var result:String = "";
			result += createLine(desc) + wrap;
			result += createLine(titles) + wrap;
			result += createLine(types) + wrap;
			
			if (source != null && source.length != 0) {
				var obj:Object;
				var title:String;
				var array:Array;
				for each (obj in source) {
					array = [];			
					for each (title in titles) {
						if (!obj.hasOwnProperty(title)) {
							obj[title] = "";
						}
						array.push(obj[title]);
					}
					result += createLine(array) + wrap;
				}
			}
			return result;
		}
		
		public static function XLSToArray2(xls:String):Object {
			var result:Object = {};
			if (xls) {
				var datas:Array = [];
				var lines:Array = xls.split(wrap);
				lines.shift();
				var descs:Array = lines.shift().split(splitReg);
				lines.shift();
				var types:Array = lines.shift().split(splitReg);
				var keys:Array = lines.shift().split(splitReg);
				keys.forEach(eacapeForEach);
				var line:String;
				var values:Array;
				var object:Object;
				for each (line in lines) {
					if (line == "") {
						continue;
					}
					var firstChar:String = line.charAt(0);
					if (firstChar == "#" || firstChar == ";") {
						continue;
					}
					values = line.split(splitReg);
					values.forEach(eacapeForEach);
					object = {};
					for (var i:int = 0; i < keys.length; i++) {
						object[keys[i]] = getValueByType(values[i], types[i]);
					}
					datas.push(object);
				}
				
				result.datas = datas;
				result.descs = descs;
				result.keys = keys;
				result.types = types;
			}
			return result;
		}
		
		private static function getValueByType(value:*, type:String):* {
			switch (type) {
				case "1":
				case "int":
					if (isNaN(value)) {
						return 0;
					} else {
						return int(value);
					}
				case "2":
				case "float":
				case "double":
					if (isNaN(value)) {
						return 0;
					} else {
						return Number(value);
					}
				case "bool":
					return BooleanUtil.toBoolean(value);
				case "string":
					return value.toString();
				case "3":
				case "string[]":
					return ArrayUtil.getArrayFromString(value);
				case "float[]":
				case "double[]":
					var array:Array = ArrayUtil.getArrayFromString(value);
					for (var i:int = 0; i < array.length; i++) {
						if (isNaN(array[i])) {
							array[i] = 0;
						} else {
							array[i] = Number(array[i]);
						}
					}
					return array;
			}
			return value;
		}
	}
}