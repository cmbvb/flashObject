package com.canaan.programEditor.constants
{
	public class TypeAttribute
	{
		public static const BYTE_ARRAY:String = "byte[]";
		public static const BYTE_ARRAY_WRITE:String = "Bytes";
		
		public static const AS_MAP:Object = {
			"int":"int",
			"byte":"int",
			"short":"int",
			"float":"Number",
			"double":"Number",
			"long":"Number",
			"bool":"Boolean",
			"string":"String",
			"string[]":"Array",
			"int[]":"Array",
			"float[]":"Array",
			"double[]":"Array",
			"ArrayList":"Array",
			"Hashtable":"Object",
			"Number":"Number",
			"byte[]":"ByteArray"
		};
		
		public static const BASE_TYPE:Object = {
			"byte":true,
			"double":true,
			"float":true,
			"short":true,
			"int":true,
			"string":true,
			"bool":true
		};
		
		public static const BASE_WRITE:Object = {
			"byte":"Byte",
			"double":"Double",
			"float":"Float",
			"short":"Short",
			"int":"Int",
			"string":"UTF",
			"bool":"Boolean"
		};
	}
}