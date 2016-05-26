package com.canaan.lib.utils
{
	

	/**
	 * 为兼容Vector，所有Array使用弱无类型*
	 * 
	 */
	public class ArrayUtil
	{
		/**
		 * 获取Array或Vector中匹配的元素 
		 * @param source
		 * @param key
		 * @param value
		 * @return 
		 * 
		 */		
		public static function find(source:*, key:*, value:*):* {
			if (source != null) {
				var item:Object;
				for each (item in source) {
					if (item[key] == value) {
						return item;
					}
				}
			}
			return null;
		}
		
		/**
		 * 获取Array或Vector中匹配的元素数组
		 * @param source
		 * @param key
		 * @param value
		 * @return 
		 * 
		 */		
		public static function findArray(source:*, key:*, value:*):Array {
			var result:Array = [];
			if (source != null) {
				var item:Object;
				for each (item in source) {
					if (item[key] == value) {
						result.push(item);
					}
				}
			}
			return result;
		}

		/**
		 * 获取Array或Vector中多项匹配的元素
		 * @param source
		 * @param keys
		 * @param value
		 * @return 
		 * 
		 */		
		public static function findElement(source:*, keys:Array, value:*):* {
			if (source != null && keys != null && keys.length > 0) {
				var item:Object;
				var key:String;
				for each (item in source) {
					for each (key in keys) {
						if (item[key] == value) {
							return item;
						}
					}
				}
			}
			return null;
		}
		
		/**
		 * 获取Array中所有匹配的元素数组
		 * @param source
		 * @param keys
		 * @param value
		 * @return 
		 * 
		 */		
		public static function findElementsArray(source:*, keys:Array, value:*):Array {
			var result:Array = [];
			if (source != null && keys != null && keys.length > 0) {
				var item:Object;
				var key:String;
				for each (item in source) {
					for each (key in keys) {
						if (item[key] == value) {
							result.push(item);
							break;
						}
					}
				}
			}
			return result;
		}
		
		/**
		 * 获取Array中所有匹配的元素Vector
		 * @param source
		 * @param keys
		 * @param value
		 * @return 
		 * 
		 */		
		public static function findElementsVector(source:*, keys:Array, value:*):Vector.<Object> {
			var result:Vector.<Object> = new Vector.<Object>();
			if (source != null && keys != null && keys.length > 0) {
				var item:Object;
				var key:String;
				for each (item in source) {
					for each (key in keys) {
						if (item[key] == value) {
							result.push(item);
							break;
						}
					}
				}
			}
			return result;
		}
		
		/**
		 * 获取Array或Vector中配对匹配的元素
		 * @param source
		 * @param keys
		 * @param values
		 * @return 
		 * 
		 */		
		public static function findElement2(source:*, keys:Array, values:Array):* {
			if (source == null || keys == null || values == null) {
				return null;
			}
			if (keys.length != values.length) {
				throw new Error("Key's length must equal value's length!");
			}
			var item:Object;
			var length:int;
			for each (item in source) {
				length = keys.length;
				for (var i:int = 0; i < length; i++) {
					if (item[keys[i]] != values[i]) {
						break;
					}
					if (i == length - 1) {
						return item;
					}
				}
			}
			return null;
		}
		
		public static function getRandomItem(source:*):* {
			if (source == null || source.length == 0) {
				return null;
			}
			var randomNum:int = MathUtil.randRange(0, source.length - 1);
			return source[randomNum];
		}
		
		public static function arrayToObject(source:*, key:String):Object {
			if (source == null) {
				return null;
			}
			var result:Object = {};
			var object:Object;
			for each (object in source) {
				result[object[key]] = object;
			}
			return result;
		}
		
		public static function arrayToObjectMultiKey(source:*, keys:Array, separator:String = "_"):Object {
			if (source == null) {
				return null;
			}
			var result:Object = {};
			var object:Object;
			var key:String;
			var length:int;
			for each (object in source) {
				key = "";
				length = keys.length;
				for (var i:int = 0; i < length; i++) {
					key += object[keys[i]];
					if (i != length - 1) {
						key += separator;
					}
				}
				result[key] = object;
			}
			return result;
		}
		
		public static function dispose(source:*):void {
			if (source == null || source.length == 0) {
				return;
			}
			source.length = 0;
//			source.splice(0, source.length);
		}
		
		public static function addElements(source:*, ...args):void {
			if (source == null || args.length == 0) {
				return;
			}
			var item:Object;
			var searchIndex:int;
			for each (item in args) {
				searchIndex = source.indexOf(item);
				if (searchIndex == -1) {
					source.push(item);
				}
			}
		}
		
		public static function removeElements(source:*, ...args):void {
			if (source == null || source.length == 0 || args.length == 0) {
				return;
			}
			var item:Object;
			var searchIndex:int;
			for each (item in args) {
				searchIndex = source.indexOf(item);
				if (searchIndex != -1) {
					source.splice(searchIndex, 1);
				}
			}
		}
		
		public static function shuffle(source:*):void {
			source.sort(function():int {
				var r:Number = Math.random() - 0.5;
				if (r > 0) {
					return 1;
				} else {
					return -1;
				}
			});
		}
		
		public static function copyAndFill(source:*, elementStr:String, separator:String = ",", type:Class = null):* {
			type ||= int;
			var result:* = source.concat();
			var elements:Array = elementStr.split(separator);
			var index:int;
			var length:int = Math.min(result.length, elements.length);
			for (var i:int = 0; i < length; i++) {
				var value:String = elements[i];
				result[i] = type(value == "true" ? true : (value == "false" ? false : value));
			}
			return result;
		}
		
		public static function getArrayFromString(value:String, separator:String = ","):Array {
			if (value) {
				return value.split(separator);
			}
			return [];
		}
	}
}