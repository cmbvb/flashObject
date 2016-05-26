package com.canaan.lib.utils
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class ObjectUtil
	{
		public static var gBytes:ByteArray = new ByteArray();
		
		public static function clone(source:Object):Object {
	        var result:Object = {};
	        var prop:String;
	        for (prop in source) {
	        	result[prop] = source[prop];
	        }
	        return result;
	    }
		
		public static function cloneDictionary(source:Dictionary):Dictionary {
			var result:Dictionary = new Dictionary();
			var prop:String;
			for (prop in source) {
				result[prop] = source[prop];
			}
			return result;
		}
	    
	    public static function deapClone(value:Object):* {
	    	var className:String = getQualifiedClassName(value);
	    	var clazz:Class = getDefinitionByName(className) as Class;
	    	if (className.indexOf("::") != -1) {
	    		className = className.split("::")[1];
	    	}
	    	registerClassAlias(className, clazz);
	    	var bytes:ByteArray = objectToBytes(value);
	    	return bytesToObject(bytes);
	    }
		
		public static function objectToBytes(value:Object, compress:Boolean = false, bytes:ByteArray = null):ByteArray {
			if (!bytes) {
				bytes = new ByteArray();
			} else {
				bytes.clear();
			}
			bytes.writeObject(value);
			if (compress) {
				bytes.compress();
			}
			return bytes;
		}
		
		public static function bytesToObject(bytes:ByteArray, uncompress:Boolean = false):Object {
			gBytes.clear();
			gBytes.writeBytes(bytes);
			if (uncompress) {
				gBytes.uncompress();
			}
			gBytes.position = 0;
			return gBytes.readObject();
		}
	    
	    public static function count(source:Object):int {
	    	var count:int;
	    	var prop:String;
	    	for (prop in source) {
	    		count++;
	    	}
	    	return count;
	    }
	    
	    public static function merge(source:Object, target:Object):void {
	    	if (source == null || target == null) {
	    		return;
	    	}
	    	for (var key:Object in target) {
	    		source[key] = target[key];
	    	}
	    }
		
		public static function fill(source:Object, target:Object):void {
			if (source == null || target == null) {
				return;
			}
			for (var key:Object in target) {
				if (source.hasOwnProperty(key)) {
					source[key] = target[key];
				}
			}
		}
		
		public static function mergeXML(source:XML, target:XML):void {
			if (source == null || target == null) {
				return;
			}
			for each (var attr:XML in target.attributes()) {
				source.@[attr.name().toString()] = attr;
			}
		}
	    
	    public static function objectToArray(source:Object, addKey:Boolean = false, keyStr:String = "key", valueStr:String = "value"):Array {
	    	if (source == null) {
	    		return null;
	    	}
	    	var result:Array = [];
	    	var object:Object;
	    	for (var key:Object in source) {
	    		if (addKey) {
	    			object = {};
	    			object[keyStr] = key;
	    			object[valueStr] = source[key];
	    		} else {
	    			object = source[key];
	    		}
	    		result.push(object);
	    	}
	    	return result;
	    }
		
		public static function objectToVector(source:Object, addKey:Boolean = false, keyStr:String = "key", valueStr:String = "value"):Vector.<Object> {
			if (source == null) {
				return null;
			}
			var result:Vector.<Object> = new Vector.<Object>();
			var object:Object;
			for (var key:Object in source) {
				if (addKey) {
					object = {};
					object[keyStr] = key;
					object[valueStr] = source[key];
				} else {
					object = source[key];
				}
				result.push(object);
			}
			return result;
		}
		
		public static function dispose(source:*):void {
			if (source == null) {
				return;
			}
			var key:*;
			for (key in source) {
				delete source[key];
			}
		}
		
		public static function getCharsLength(value:String):int {
			gBytes.clear();
			gBytes.writeMultiByte(value, "gb2312");
			return gBytes.length;
		}
		
		public static function getClassByInstance(instance:*):Class {
			return getDefinitionByName(getQualifiedClassName(instance)) as Class;
		}
		
		public static function formatString(source:Object):String {
			var str:String = "";
			var qualifiedClassName:String = getQualifiedClassName(source);
			if (qualifiedClassName == "Object") {
				for (var key:String in source) {
					str += key + "=\"" + source[key] + "\" ";
				}
			} else {
				var describeTypeXML:XML = describeType(source);
				var i:int;
				for (i = 0; i < describeTypeXML.variable.length(); i++) {
					str += describeTypeXML.variable[i].@name + "=\"" + source[describeTypeXML.variable[i].@name] + "\" ";
				}
				for (i = 0; i < describeTypeXML.accessor.length(); i++) {
					str += describeTypeXML.accessor[i].@name + "=\"" + source[describeTypeXML.accessor[i].@name] + "\" ";
				}
			}
			return str;
		}
	}
}