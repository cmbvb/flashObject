package com.canaan.programEditor.core
{
	import com.canaan.programEditor.constants.TypeAttribute;
	import com.canaan.programEditor.data.EnumFieldVo;
	import com.canaan.programEditor.data.EnumVo;
	import com.canaan.programEditor.data.ProtocolVo;
	import com.canaan.programEditor.data.TableVo;

	public class CodeHelper
	{
		public function CodeHelper()
		{
		}
		
		private static function formateString(str:String):String {
//			if (str.length > 0) {
//				str = str.charAt(0).toLowerCase() + str.substring(1);
//			}
			return str;
		}
		
		/**
		 * 创建CS模板
		 * @param tableVo
		 * @return 
		 * 
		 */		
		public static function createTempleCS(tableVo:TableVo):String {
			// namespace using
			var result:String = DataCenter.templeOutputServerImport;
			if (result) {
				result += "\r\r";
			}
			
			// namespace
			result += "namespace " + DataCenter.templeOutputServerNameSpace + "\r{\r";
			
			// class
			result += "\tclass " + tableVo.name + "\r\t{\r";
			
			var i:int;
			
			// attr
			for (i = 0; i < tableVo.tblFields.length; i++) {
				result += "\t\t// " + tableVo.tblDescs[i] + "\r";
				result += "\t\tpublic " + tableVo.tblTypes[i] + " " + formateString(tableVo.tblFields[i]) + ";\r";
			}
			result += "\r";
			
			result += "\t\tstatic public Dictionary<string, " + tableVo.name + "> temples = new Dictionary<string, " + tableVo.name + ">();\r\r";
			
			result+="\t\tstatic public void initdata(Hashtable table)\r\t\t{\r";
			result+="\t\t\tforeach (DictionaryEntry de in table)\r\t\t\t{\r";
			result+="\t\t\t\ttry\r\t\t\t\t{\r";
			result+="\t\t\t\t\t" + tableVo.name + " tp = new " + tableVo.name + "();\r";
			result+="\t\t\t\t\ttemples[(string)de.Key] = tp;\r";
			result+="\t\t\t\t\tHashtable tb = de.Value as Hashtable;\r";
			for (i = 0;i < tableVo.tblFields.length; i++) {
				result += "\t\t\t\t\ttp." + formateString(tableVo.tblFields[i]) + " = (" + (tableVo.tblTypes[i].toString()) + ")tb[\"" + formateString(tableVo.tblFields[i]) + "\"];\r";
			}
			result += "\t\t\t\t}\r\t\t\t\tcatch (System.Exception ee)\r\t\t\t\t{\r" +
				"\t\t\t\t\tLogHelper.log(ee);\r" +
				"\t\t\t\t}\r";
			result += "\t\t\t}\r";
			result += "\t\t}\r"	
			result += "\t}\r"
			result += "}\r";
			
			return result;
		}
		
		/**
		 * 创建AS Config
		 * @param tableVo
		 * @return 
		 * 
		 */		
		public static function createConfigAS(tableVo:TableVo):String {
			// package
			var result:String = "package";
			var pkgStr:String = "";
			var srcFolderIndex:int = DataCenter.templeOutputClientPath.indexOf("src/");
			if (srcFolderIndex != -1) {
				result += " ";
				pkgStr = DataCenter.templeOutputClientPath.substring(srcFolderIndex + "src/".length).replace(/\//g, ".");
			}
			result += pkgStr;
			result += "\r{\r";
			
			// import temple
			result += "\timport " + pkgStr + ".temple." + tableVo.name + ";\r";
			
			// import
			if (DataCenter.templeOutputClientImport) {
				result += "\t" + DataCenter.templeOutputClientImport + "\r";
			}
			
			result += "\r";
			
			// class
			result += "\t" + "public class " + tableVo.asCfgName + " extends " + tableVo.name + "\r\t{\r";
			
			// constructor
			result += "\t\tpublic function " + tableVo.asCfgName + "()\r\t\t{\r\t\t\tsuper();\r\t\t}\r\r";
			
			result += "\t}\r}";
			
			return result;
		}
		
		/**
		 * 创建AS模板
		 * @param tableVo
		 * @return 
		 * 
		 */		
		public static function createTempleAS(tableVo:TableVo):String {
			// package
			var result:String = "package";
			var templePath:String = DataCenter.templeOutputClientPath + "/temple";
			var srcFolderIndex:int = templePath.indexOf("src/");
			if (srcFolderIndex != -1) {
				var pkgStr:String = templePath.substring(srcFolderIndex + "src/".length);
				result += " " + pkgStr.replace(/\//g, ".");
			}
			result += "\r{\r";
			
			// import
			if (DataCenter.templeOutputClientImport) {
				result += "\t" + DataCenter.templeOutputClientImport + "\r\r";
			}
			
			// class
			result += "\t" + "public class " + tableVo.name + "\r\t{\r";
			
			var i:int;
			
			// attr
			for (i = 0; i < tableVo.tblFields.length; i++) {
				result += "\t\t// " + tableVo.tblDescs[i] + "\r";
				result += "\t\tprotected var _" + formateString(tableVo.tblFields[i]) + ":" + getAttrType(tableVo.tblTypes[i]) + ";\r";
			}
			result += "\r";
			
			// constructor
			result += "\t\tpublic function " + tableVo.name + "()\r\t\t{\r\t\t\tsuper();\r\t\t}\r\r";
			
			// getter setter
			for (i = 0; i < tableVo.tblFields.length; i++) {
				// getter
				result += "\t\tpublic function get " + formateString(tableVo.tblFields[i]) + "():" + getAttrType(tableVo.tblTypes[i]) + " {\r";
				result += "\t\t\treturn _" + formateString(tableVo.tblFields[i]) + ";\r";
				result += "\t\t}\r";
				
				result += "\r";
				
				// setter
				result += "\t\tpublic function set " +  formateString(tableVo.tblFields[i]) + "(value:" + getAttrType(tableVo.tblTypes[i]) + "):void {\r";
				result += "\t\t\t_" + formateString(tableVo.tblFields[i]) + " = " + "value;\r";
				result += "\t\t}\r";
				
				result += "\r";
			}
			
			result += "\t}\r}";
			
			return result;
		}
		
		/**
		 * 创建CS枚举
		 * @param enumVo
		 * @return 
		 * 
		 */		
		public static function createEnumCS(enumVo:EnumVo):String {
			// namespace using
			var result:String = DataCenter.enumOutputServerImport;
			if (result) {
				result += "\r\r";
			}
			
			// namespace
			result += "namespace " + DataCenter.enumOutputServerNameSpace + "\r{\r";
			
			// class
			result += "\tpublic enum " + enumVo.name + "\r\t{\r";
			
			// attr
			var field:EnumFieldVo;
			for (var i:int = 0; i < enumVo.fields.length; i++) {
				field = enumVo.fields[i];
				result += "\t\t" + field.name + " = " + field.value + ",";
				if (field.desc) {
					result += "//" + field.desc;
				}
				result += "\r";
			}
			
			result += "\t}\r}";
			
			return result;
		}
		
		/**
		 * 创建AS枚举
		 * @param enumVo
		 * @return 
		 * 
		 */		
		public static function createEnumAS(enumVo:EnumVo):String {
			// package
			var result:String = "package";
			var templePath:String = DataCenter.enumOutputClientPath;
			var srcFolderIndex:int = templePath.indexOf("src/");
			if (srcFolderIndex != -1) {
				var pkgStr:String = templePath.substring(srcFolderIndex + "src/".length);
				result += " " + pkgStr.replace(/\//g, ".");
			}
			result += "\r{\r";
			
			// import
			if (DataCenter.enumOutputClientImport) {
				result += "\t" + DataCenter.enumOutputClientImport + "\r\r";
			}
			
			// class
			result += "\t" + "public class " + enumVo.name + "\r\t{\r";
			
			var i:int;
			
			// attr
			var field:EnumFieldVo;
			for (i = 0; i < enumVo.fields.length; i++) {
				field = enumVo.fields[i];
				result += "\t\t// " + field.desc + "\r";
				result += "\t\tpublic static const " + field.name + ":int = " + field.value + ";\r";
			}
			result += "\r";
			
			result += "\t}\r}";
			
			return result;
		}
		
		/**
		 * 创建CS协议MsgCodeId
		 * @return 
		 * 
		 */		
		public static function createProtocolCSMsgCodeId():String {
			var protocols:Array = DataCenter.getAllProtocols();
			
			// namespace using
			var result:String = DataCenter.protocolOutputServerImport;
			if (result) {
				result += "\r\r";
			}
			
			// namespace
			result += "namespace " + DataCenter.protocolOutputServerNameSpace + "\r{\r";
			
			// class
			result += "\tpublic enum MsgCodeId\r\t{\r";
			
			// attr
			for each (var protocolVo:ProtocolVo in protocols) {
				result += "\t\t" + protocolVo.name + " = " + protocolVo.id + ",";
				result += "\r";
			}
			
			result += "\t}\r}";
			
			return result;
		}
		
		/**
		 * 创建CS协议MsgProcessor
		 * @return 
		 * 
		 */		
		public static function createProtocolCSMsgProcessor():String {
			var protocols:Array = DataCenter.getAllProtocols();
			
			// namespace using
			var result:String = DataCenter.protocolOutputServerImport;
			result += "\rusing System.Collections.Generic;\r";
			result += "\rusing " + DataCenter.protocolOutputServerNameSpace + ".Protocols;\r\r";
			
			// namespace
			result += "namespace " + DataCenter.protocolOutputServerNameSpace + "\r{\r";
			
			// class
			result += "\tpublic partial class MsgHandle\r\t{\r";
			
			result += "\t\tpublic int init()\r" + 
						"\t\t{\r";
			
			// attr
			for each (var protocolVo:ProtocolVo in protocols) {
				if (protocolVo.canCreateCSProcesser) {
					result += "\t\t\taddPro(MsgCodeId." + protocolVo.name + ", " + protocolVo.csHandlerName + ", () => { return new " + protocolVo.name + "(); });";
					result += "\r";
				}
			}
			result += "\t\t\treturn 0;\r\t\t}\r";
			
			result += "\t}\r}";
			
			return result;
		}
		
		/**
		 * 创建CS协议Protocols
		 * @param protocolVo
		 * @return 
		 * 
		 */		
		public static function createProtocolCSProtocol(protocolVo:ProtocolVo):String {
			// namespace using
			var result:String = DataCenter.protocolOutputServerImport;
			if (result) {
				result += "\rusing " + DataCenter.protocolOutputServerNameSpace + ";\r\r";
			}
			
			// namespace
			result += "namespace " + DataCenter.protocolOutputServerNameSpace + ".Protocols\r{\r";
			
			// class
			result += "\tpublic class " + protocolVo.name + " : MsgBase\r\t{\r\r";
			
			// constructor
			result += "\t\tpublic " + protocolVo.name + "()\r\t\t{\r";
			result += "\t\t\tCodeId = MsgCodeId." + protocolVo.name + ";\r";
			result += "\t\t}\r\r";
			
			var encodefunc:String = "\t\tpublic override void encode(ByteArray by)\r\t\t{\r";
			var decodefunc:String = "\t\tpublic override void decode(ByteArray by)\r\t\t{\r";
			var initfunc:String = "\t\tpublic " + protocolVo.name + " init({args})\r\t\t{\r";
			
			var lines:Array = protocolVo.content.split(/\r/g);
			var vardeclare:String = "";
			var varChange:String = "";
			var varGeterSetter:String = "";
			var args:String = "";
			var declare:Boolean;
			for (var i:int = 0;i < lines.length; i++) {
				var line:String = lines[i];
				var arr:Array = new Tokens(line).Parse();
				
				if (arr.length > 2) {
					// 属性声明
					if (arr.length == 3) {
						varGeterSetter += "\t\t// <" + arr[0] + ">" + arr[1] + "\r";
					} else {
						varGeterSetter += "\t\t/**\r\t\t* " + arr[3] + "\r\t\t* " + arr[0] + "\r\t\t* " + arr[1] + "\r\t\t*/\r";
					}
					
					var attrType:String = arr[1];
					if (arr[0] == "repeated") {
						attrType += "[]";
					}
					vardeclare += "\t\tprivate " + attrType + " _" + arr[2] + ";\r";
					
					// 属性getter setter
					varGeterSetter += "\t\tpublic " + attrType + " " + arr[2] + "\r";
					varGeterSetter += "\t\t{\r";
					varGeterSetter += "\t\t\tget { return _" + arr[2] + "; }\r";
					varGeterSetter += "\t\t\tset { _" + arr[2] + " = value; " + arr[2] + "_changed = true; }";
					varGeterSetter += "\r\t\t}\r";
					
					// 变量改变
					varChange += "\t\tpublic bool " + arr[2] + "_changed;\r";
					
					if (arr[0] == "optional") {
						encodefunc += "\t\t\tif (" + arr[2] + "_changed == true)\r\t\t\t{\r" +
							"\t\t\t\tby.WriteByte(1);\r";
						if (isByteArray(arr[1])) {
							encodefunc += "\t\t\t\tby.WriteShort((short)" + arr[2] + ".Length);\r";
							encodefunc += "\t\t\t\tby.WriteBytes(" + arr[2] + ", 0, " + arr[2] + ".Length);\r";
						} else if (isBaseType(arr[1])) {
							encodefunc += "\t\t\t\tby.Write" + TypeAttribute.BASE_WRITE[arr[1]] + "(" + arr[2] + ");\r";
						} else {
							encodefunc += "\t\t\t\t" + arr[2] + ".encode(by);\r";
						}
						encodefunc += "\t\t\t}\r\t\t\telse\r\t\t\t{\r" +
							"\t\t\t\tby.WriteByte(0);\r" +
							"\t\t\t}\r";
						decodefunc += "\t\t\tif (by.ReadByte() > 0)\r\t\t\t{\r";
						if (isByteArray(arr[1])) {
							var length:String = "__length_" + arr[2];
							decodefunc += "\t\t\t\tshort " + length + " = by.ReadShort();\r";
							decodefunc += "\t\t\t\t" + arr[2] + " = by.ReadBytes(" + length + ");\r";
						} else if (isBaseType(arr[1])) {
							decodefunc += "\t\t\t\t" + arr[2] + " = by.Read" + TypeAttribute.BASE_WRITE[arr[1]] + "();\r";
						} else {
							decodefunc += "\t\t\t\t" + arr[2] + " = new " + arr[1] + "();\r";
							decodefunc += "\t\t\t\t" + arr[2] + ".decode(by);\r";
						}
						decodefunc += "\t\t\t}\r";
					} else if (arr[0] == "repeated") {
						if (!declare) {
							encodefunc += "\t\t\tint i = 0;\r";
							decodefunc += "\t\t\tint i = 0;\r";
							declare = true;
						}
						encodefunc += "\t\t\tif (" + arr[2] + "_changed == true)\r\t\t\t{\r" +
							"\t\t\t\tby.WriteByte(1);\r";
						encodefunc += "\t\t\t\tif (" + arr[2] + " != null)\r\t\t\t\t{\r" +
							"\t\t\t\t\tby.WriteShort((short)" + arr[2] + ".Length);\r" +
							"\t\t\t\t\tfor (i = 0; i < " + arr[2] + ".Length; i++)\r\t\t\t\t{\r\t\t\t\t\t\t" +
							(isBaseType(arr[1]) ? ("by.Write" + TypeAttribute.BASE_WRITE[arr[1]] + "(" + arr[2] + "[i]);") : (arr[2] + "[i].encode(by);")) +
							"\r\t\t\t\t\t}\r" +
							"\t\t\t\t} else {\r" +
							"\t\t\t\t\tby.WriteShort(0);\r" +
							"\t\t\t\t}\r";
						encodefunc += "\t\t\t}\r\t\t\telse\r\t\t\t{\r" +
							"\t\t\t\tby.WriteByte(0);\r" +
							"\t\t\t}\r";
						decodefunc += "\t\t\tif (by.ReadByte() > 0)\r\t\t\t{\r";
						var count:String = "__count_" + arr[2];
						decodefunc += "\t\t\t\tshort " + count + " = by.ReadShort();\r" +
							"\t\t\t\t" + arr[2] + " = new " + arr[1] + "[" + count + "];\r" +
							"\t\t\t\tfor (i = 0; i < " + count + "; i++)\r\t\t\t\t{\r\t\t\t\t\t" +
							(isBaseType(arr[1]) ? "" : arr[2] + "[i] = new " + arr[1] + "();\r\t\t\t\t\t") +
							(isBaseType(arr[1]) ? (arr[2] + "[i] = by.Read" + TypeAttribute.BASE_WRITE[arr[1]] + "();") : (arr[2] + "[i].decode(by);")) +
							"\r\t\t\t\t}\r";
						decodefunc += "\t\t\t}\r";
					} else {
						if (isByteArray(arr[1])) {
							encodefunc += "\t\t\tby.WriteShort((short)" + arr[2] + ".Length);\r";
							encodefunc += "\t\t\tby.WriteBytes(" + arr[2] + ", 0, " + arr[2] + ".Length);\r";
							var length2:String = "__length_" + arr[2];
							decodefunc += "\t\t\tshort " + length2 + " = by.ReadShort();\r";
							decodefunc += "\t\t\t" + arr[2] + " = by.ReadBytes(" + length2 + ");\r";
						} else if (isBaseType(arr[1])) {
							encodefunc += "\t\t\tby.Write" + TypeAttribute.BASE_WRITE[arr[1]] + "(" + arr[2] + ");\r";
							decodefunc += "\t\t\t" + arr[2] + " = by.Read" + TypeAttribute.BASE_WRITE[arr[1]] + "();\r";
						} else {
							encodefunc += "\t\t\t" + arr[2] + ".encode(by);\r";
							decodefunc += "\t\t\t" + arr[2] + " = new " + arr[1] + "();\r" +
							"\t\t\t" + arr[2] + ".decode(by);\r";
						}
					}
					if (arr[0] == "repeated") {
						args += arr[1] + "[] " + arr[2] + ", ";
					} else {
						args += arr[1] + " " + arr[2] + ", ";
					}
					initfunc += "\t\t\tthis." + arr[2] + " = " + arr[2] + ";\r";
				}
			}
			
			result += vardeclare;
			result += "\r";
			result += varChange;
			result += "\r";
			
			if (args.length > 0) {
				args = args.substr(0, -2);
			}
			
			initfunc = initfunc.replace("{args}", args);
			initfunc += "\t\t\treturn this;\r" + "\t\t}\r\r";
			result += initfunc;
			
			if (protocolVo.name.substr(0, 2) != "e_") {
				result += encodefunc+"\t\t}\r\r";
				result += decodefunc+"\t\t}\r\r";
			}
			
			result += varGeterSetter;
			
			result += "\t}\r}";
			
			return result;
		}
		
		/**
		 * 创建CS协议Processer
		 * @param protocolVo
		 * @return 
		 * 
		 */		
		public static function createProtocolCSProcesser(protocolVo:ProtocolVo):String {
			// namespace using
			var result:String = DataCenter.protocolOutputServerImport;
			if (result) {
				result += "\rusing " + DataCenter.protocolOutputServerNameSpace + ";\r\r";
			}
			
			// namespace
			result += "namespace " + DataCenter.protocolOutputServerNameSpace + "\r{\r";
			
			// class
			result += "\tpublic partial class MsgHandle\r\t{\r";
			result += "\t\tstatic public void " + protocolVo.csHandlerName + "(Message msg)\r\t\t{\r\t\t\t\r\t\t}\r";
			
			result += "\t}\r}";
			return result;
		}
		
		/**
		 * 创建AS协议ProtocolConst
		 * @return 
		 * 
		 */		
		public static function createProtocolASProtocolConst():String {
			var protocols:Array = DataCenter.getAllProtocols();
			
			// package
			var result:String = "package";
			var pkgStr:String = "";
			var srcFolderIndex:int = DataCenter.protocolOutputClientPath.indexOf("src/");
			if (srcFolderIndex != -1) {
				result += " ";
				pkgStr = DataCenter.protocolOutputClientPath.substring(srcFolderIndex + "src/".length).replace(/\//g, ".");
			}
			result += pkgStr;
			result += "\r{\r";
			
			// import
			if (DataCenter.protocolOutputClientImport) {
				result += "\t" + DataCenter.protocolOutputClientImport + "\r\r";
			}
			
			// class
			result += "\t" + "public class Protocols\r\t{\r";
			
			for each (var protocolVo:ProtocolVo in protocols) {
				result += "\t\tpublic static const " + protocolVo.name + ":int = " + protocolVo.id + ";\r";
			}
			
			result += "\t}\r}";
			
			return result;
		}
		
		/**
		 * 创建AS协议ProtocolMap
		 * @return 
		 * 
		 */		
		public static function createProtocolASProtocolMap():String {
			var protocols:Array = DataCenter.getAllProtocols();
			
			// package
			var result:String = "package";
			var pkgStr:String = "";
			var srcFolderIndex:int = DataCenter.protocolOutputClientPath.indexOf("src/");
			if (srcFolderIndex != -1) {
				result += " ";
				pkgStr = DataCenter.protocolOutputClientPath.substring(srcFolderIndex + "src/".length).replace(/\//g, ".");
			}
			result += pkgStr;
			result += "\r{\r";
			
			// import
			if (DataCenter.protocolOutputClientImport) {
				result += "\t" + DataCenter.protocolOutputClientImport + "\r";
			}
			result += "\timport flash.utils.Dictionary;\r";
			result += "\timport " + pkgStr + ".protocols.*;\r";
			
			result += "\r";
			
			// class
			result += "\t" + "public class ProtocolMap\r\t{\r";
			
			// attr
			result += "\t\t" + "public static var PROTOCOL_MAP_ID:Dictionary = new Dictionary();\r";
			result += "\t\t" + "public static var PROTOCOL_MAP_NAME:Dictionary = new Dictionary();\r\r";
			
			for each (var protocolVo:ProtocolVo in protocols) {
				result += "\t\tPROTOCOL_MAP_NAME[\"" + protocolVo.name + "\"] = PROTOCOL_MAP_ID[" + protocolVo.id + "] = " + protocolVo.name + ";\r";
			}
			
			result += "\t}\r}";
			
			return result;
		}
		
		/**
		 * 创建AS协议Protocols
		 * @param protocolVo
		 * @return 
		 * 
		 */		
		public static function createProtocolASProtocol(protocolVo:ProtocolVo):String {
			var protocols:Array = DataCenter.getAllProtocols();
			
			// package
			var result:String = "package";
			var srcFolderIndex:int = DataCenter.protocolOutputClientPath.indexOf("src/");
			var pkgImport:String = "";
			if (srcFolderIndex != -1) {
				var pkgStr:String = DataCenter.protocolOutputClientPath.substring(srcFolderIndex + "src/".length);
				pkgImport = pkgStr.replace(/\//g, ".");
				result += " " + pkgImport + ".protocols";
			}
			result += "\r{\r";
			
			// import
			if (DataCenter.protocolOutputClientImport) {
				result += "\t" + DataCenter.protocolOutputClientImport + "\r";
			}
			result += "\timport flash.utils.ByteArray;\r";
			result += "\timport " + pkgImport + ".BaseProtocol;\r";
			
			result += "\r";
			
			// class
			result += "\t/**\r\t* " + protocolVo.desc + "\r\t*/\r";
			result += "\t" + "public class " + protocolVo.name + " extends BaseProtocol\r\t{\r";
			
			var encodefunc:String = "\t\tpublic override function encode(by:ByteArray):void {\r";
			var decodefunc:String = "\t\tpublic override function decode(by:ByteArray):void {\r";
			var initfunc:String = "\t\tpublic function init({args}):" + protocolVo.name + " {\r";
			var resetFunc:String = "\t\tpublic override function reset():void {\r";
			var mergeFunc:String = "\t\tpublic function merge(value:" + protocolVo.name + "):void {\r";
			mergeFunc += "\t\t\tif (value == null) {\r";
			mergeFunc += "\t\t\t\treturn;\r";
			mergeFunc += "\t\t\t}\r";
			
			var lines:Array = protocolVo.content.split(/\r/g);
			var varNames:Array = [];
			var vardeclare:String = "";
			var varChange:String = "";
			var varGeterSetter:String = "";
			var args:String = "";
			var declare:Boolean;
			for (var i:int = 0; i < lines.length;i++) {
				var line:String = lines[i];
				var arr:Array = new Tokens(line).Parse();
				
				if (arr.length > 2) {
					varNames.push("\"" + arr[2] + "\"");
					
					// 属性声明
					if (arr.length == 3) {
						varGeterSetter += "\t\t// <" + arr[0] + ">" + arr[1] + "\r";
					} else {
						varGeterSetter += "\t\t/**\r\t\t* " + arr[3] + "\r\t\t* " + arr[0] + "\r\t\t* " + arr[1] + "\r\t\t*/\r";
					}
					
					var attrType:String = "";
					var defaultValue:String = "";
					
					if (arr[0] == "repeated") {
						attrType = "Array";
					} else {
						attrType = getAttrType(arr[1]);
						if (getAttrType(arr[1]) == "Number") {
							defaultValue = " = 0";
						}
					}
					vardeclare += "\t\tprotected var _" + arr[2] + ":" + attrType + defaultValue + ";\r";
					
					// 属性getter setter
					// getter
					varGeterSetter += "\t\tpublic function get " + arr[2] + "():" + attrType + " {\r";
					varGeterSetter += "\t\t\treturn _" + arr[2] + ";\r";
					varGeterSetter += "\t\t}\r";
					
					varGeterSetter += "\r";
					
					// setter
					varGeterSetter += "\t\tpublic function set " +  arr[2] + "(value:" + attrType + "):void {\r";
					varGeterSetter += "\t\t\t_" + arr[2] + " = " + "value;\r";
					varGeterSetter += "\t\t\t" + arr[2] + "_changed = true;\r";
					varGeterSetter += "\t\t}\r";
					
					varGeterSetter += "\r";
					
					// 变量改变
					varChange += "\t\tpublic var " + arr[2] + "_changed:Boolean;\r";
					
					if (arr[0] == "optional") {
						encodefunc += "\t\t\tif (" + arr[2] + "_changed == true) {\r" +
							"\t\t\t\tby.writeByte(1);\r";
						if (isByteArray(arr[1])) {
							encodefunc += "\t\t\t\tby.writeShort(" + arr[2] + ".length);\r";
							encodefunc += "\t\t\t\tby.writeBytes(" + arr[2] + ");\r";
						} else if (isBaseType(arr[1])) {
							encodefunc += "\t\t\t\tby.write" + TypeAttribute.BASE_WRITE[arr[1]] + "(" + arr[2] + ");\r";
						} else {
							encodefunc += "\t\t\t\t" + arr[2] + ".encode(by);\r";
						}
						encodefunc += "\t\t\t} else {\r" +
							"\t\t\t\tby.writeByte(0);\r" +
							"\t\t\t}\r";
						decodefunc += "\t\t\tif (by.readByte() > 0) {\r";
						if (isByteArray(arr[1])) {
							var length:String = "length_" + arr[2];
							decodefunc += "\t\t\t\tvar " + length + ":int = by.readShort();\r";
							decodefunc += "\t\t\t\t" + arr[2] + " = new ByteArray();\r";
							decodefunc += "\t\t\t\t" + arr[2] + ".endian = \"littleEndian\";\r";
							decodefunc += "\t\t\t\tby.readBytes(" + arr[2] + ", 0, " + length + ");\r";
						} else if (isBaseType(arr[1])) {
							decodefunc += "\t\t\t\t" + arr[2] + " = by.read" + TypeAttribute.BASE_WRITE[arr[1]] + "();\r";
						} else {
							decodefunc += "\t\t\t\t" + arr[2] + " = new " + arr[1] + "();\r";
							decodefunc += "\t\t\t\t" + arr[2] + ".decode(by);\r";
						}
						decodefunc += "\t\t\t}\r";
					} else if (arr[0] == "repeated") {
						if (!declare) {
							encodefunc += "\t\t\tvar i:int = 0;\r";
							decodefunc += "\t\t\tvar i:int = 0;\r";
							declare = true;
						}
						encodefunc += "\t\t\tif (" + arr[2] + "_changed == true) {\r" +
							"\t\t\t\tby.writeByte(1);\r";
						encodefunc += "\t\t\t\tif (" + arr[2] + " != null) {\r" +
							"\t\t\t\t\tby.writeShort(" + arr[2] + ".length);\r" +
							"\t\t\t\t\tfor (i = 0; i < " + arr[2] + ".length; i++) {\r" + "\t\t\t\t\t\t" + 
							(isBaseType(arr[1]) ? ("by.write" + TypeAttribute.BASE_WRITE[arr[1]] + "(" + arr[2] + "[i]);") : (arr[2] + "[i].encode(by);")) +
							"\r\t\t\t\t\t}\r" +
							"\t\t\t\t} else {\r" +
							"\t\t\t\t\tby.writeShort(0);\r" +
							"\t\t\t\t}\r";
						encodefunc += "\t\t\t} else {\r" +
							"\t\t\t\tby.writeByte(0);\r" +
							"\t\t\t}\r";
						decodefunc += "\t\t\tif (by.readByte() > 0) {\r";
						var count:String = "count_" + arr[2];
						decodefunc += "\t\t\t\tvar " + count + ":int = by.readShort();\r" +
							"\t\t\t\t" + arr[2] + " = [];\r" +
							"\t\t\t\tfor (i = 0; i < " + count + "; i++) {\r" + "\t\t\t\t\t" + 
							(isBaseType(arr[1]) ? "" : arr[2] + "[i] = new " + arr[1] + "();\r\t\t\t\t\t") +  
							(isBaseType(arr[1]) ? (arr[2] + "[i] = by.read" + TypeAttribute.BASE_WRITE[arr[1]] + "();") : (arr[2] + "[i].decode(by);")) +
							"\r\t\t\t\t}\r\t\t\t}\r";
					} else {
						if (isByteArray(arr[1])) {
							encodefunc += "\t\t\tby.writeShort(" + arr[2] + ".length);\r";
							encodefunc += "\t\t\tby.writeBytes(" + arr[2] + ");\r";
							var length2:String = "length_" + arr[2];
							decodefunc += "\t\t\tvar " + length2 + ":int = by.readShort();\r";
							decodefunc += "\t\t\t" + arr[2] + " = new ByteArray();\r";
							decodefunc += "\t\t\t" + arr[2] + ".endian = \"littleEndian\";\r";
							decodefunc += "\t\t\tby.readBytes(" + arr[2] + ", 0, " + length2 + ");\r";
						} else if (isBaseType(arr[1])) {
							encodefunc += "\t\t\tby.write" + TypeAttribute.BASE_WRITE[arr[1]] + "(" + arr[2] + ");\r";
							decodefunc += "\t\t\t" + arr[2] + " = by.read" + TypeAttribute.BASE_WRITE[arr[1]] + "();\r";
						} else {
							encodefunc += "\t\t\t" + arr[2] + ".encode(by);\r";
							decodefunc += "\t\t\t" + arr[2] + " = new " + arr[1] + "();\r" +
							"\t\t\t" + arr[2] + ".decode(by);\r";
						}
					}
					if (arr[0] == "repeated") {
						args += arr[2] + ":Array, ";
					} else {
						args += arr[2] + ":" + getAttrType(arr[1]) + ", ";
					}
					initfunc += "\t\t\tthis." + arr[2] + " = " + arr[2] + ";\r";
					mergeFunc += "\t\t\t" + arr[2] + "_changed = false;\r";
					mergeFunc += "\t\t\tif (value." + arr[2] + "_changed == true) {\r";
					if (isByteArray(arr[1]) || isBaseType(arr[1]) || arr[0] == "repeated") {
						mergeFunc += "\t\t\t\t" + arr[2] + " = value." + arr[2] + ";\r";
					} else {
						mergeFunc += "\t\t\t\tif (" + arr[2] + " == null) {\r";
						mergeFunc += "\t\t\t\t\t" + arr[2] + " = new " + arr[1] + "();\r";
						mergeFunc += "\t\t\t\t}\r";
						mergeFunc += "\t\t\t\t" + arr[2] + ".merge(value." + arr[2] + ");\r";
						mergeFunc += "\t\t\t\t" + arr[2] + "_changed = true;\r";
					}
					mergeFunc += "\t\t\t}\r";
					
					resetFunc += "\t\t\t_" + arr[2] + " = ";
					if (arr[0] == "repeated") {
						resetFunc += "null";
					} else if (isInt(arr[1])) {
						resetFunc += "0";
					} else if (isNumber(arr[1])) {
						resetFunc += "NaN";
					} else if (isBool(arr[1])) {
						resetFunc += "false";
					} else {
						resetFunc += "null";
					}
					resetFunc += ";\r";
					resetFunc += "\t\t\t" + arr[2] + "_changed = false;\r";
				}
			}
			
			result += "\t\tpublic static const FIELD_NAMES:Array = [" + varNames.join(", ") + "];\r";
			result += "\r";
			result += vardeclare;
			result += "\r";
			result += varChange;
			result += "\r";
			
			result += "\t\tpublic function " + protocolVo.name + "()\r\t\t{\r\t\t\tprotocol = " + protocolVo.id + ";\r\t\t}\r\r";
			
			if (args.length > 0) {
				args = args.substr(0, -2);
			}
			initfunc = initfunc.replace("{args}", args);
			initfunc += "\t\t\treturn this;\r" + "\t\t}\r\r";
			result += initfunc;
			
			mergeFunc += "\t\t}\r\r";
			result += mergeFunc;
			
			resetFunc += "\t\t}\r\r";
			result += resetFunc;
			
			if (protocolVo.name.substr(0, 2) != "e_") {
				result += encodefunc + "\t\t}\r\r";
				result += decodefunc + "\t\t}\r\r";
			}
			
			result += varGeterSetter;
			
			result += "\t}\r}";
			
			return result;
		}
		
		private static function getAttrType(value:String):String {
			return TypeAttribute.AS_MAP[value] || value;
		}
		
		private static function isBaseType(type:String):Boolean {
			if (TypeAttribute.BASE_TYPE[type.toLowerCase()]) {
				return true;
			}
			return false;
		}
		
		private static function isByteArray(type:String):Boolean {
			return type == TypeAttribute.BYTE_ARRAY;
		}
		
		private static function isInt(type:String):Boolean {
			return getAttrType(type) == "int";
		}
		
		private static function isNumber(type:String):Boolean {
			return getAttrType(type) == "Number";
		}
		
		private static function isBool(type:String):Boolean {
			return getAttrType(type) == "Boolean";
		}
	}
}