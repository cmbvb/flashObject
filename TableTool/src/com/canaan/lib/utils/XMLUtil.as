package com.canaan.lib.utils
{
	public class XMLUtil
	{
		public static function XMLToObject(root:*):Object {
			var result:Object = XMLAttributesToObject(root);
			for each (var child:XML in root.children()) {
				// 节点名称
				var name:String = child.name();
				// 获取所有名称为name的节点集合
				var xmlList:XMLList = root[name];
				// 如果节点集合长度为1
				if (xmlList.length() == 1 && root.@array != "true") {
					result[name] = XMLElementsToObject(child);
				} else {
					var array:Array = [];
					for each (var xml:XML in xmlList) {
						array.push(XMLElementsToObject(xml));
					}
					result[name] = array;
				}
			}
			return result;
		}
		
		private static function XMLAttributesToObject(xml:*):Object {
			var result:Object = {};
			var name:String;
			for each (var attr:XML in xml.attributes()) {
				name = attr.name();
				result[name] = attr.toString();
			}
			return result;
		}
		
		private static function XMLElementsToObject(xml:*):Object {
			var name:String = xml.name();
			// 获取该节点的子节点集合
			var children:XMLList = xml.children();
			// 如果该节点的子节点集合长度为0则说明没有曾子节点 只转换属性
			if (children.length() == 0) {
				return XMLAttributesToObject(xml);
			} else {
				// 遍历该节点的所有子节点
				for each (var child:XML in children) {
					// 如果子节点的值等于集合的值说明该节点
					if (child == children.toString() && xml.@array != "true") {
						return child.toString();
					}
				}
				return XMLToObject(xml);
			}
		}
		
		public static function hasChildNode(xml:XML):Boolean {
			var child:XML;
			var children:XMLList = xml.children();
			for each (child in children) {
				if (child.name() != null) {
					return true;
				}
			}
			return false;
		}
	}
}