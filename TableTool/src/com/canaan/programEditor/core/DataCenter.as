package com.canaan.programEditor.core
{
	import com.canaan.lib.utils.ArrayUtil;
	import com.canaan.programEditor.constants.TypeAttribute;
	import com.canaan.programEditor.constants.TypeTable;
	import com.canaan.programEditor.data.EnumFieldVo;
	import com.canaan.programEditor.data.EnumVo;
	import com.canaan.programEditor.data.ProtocolPackageVo;
	import com.canaan.programEditor.data.ProtocolVo;
	import com.canaan.programEditor.data.TableVo;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class DataCenter
	{
		public static var tableInputTablePath:String = "";
		public static var tableInputSettingPath:String = "";
		public static var tableOutputServerPath:String = "";
		public static var tableOutputClientPath:String = "";
		public static var tableOutputSettingPath:String = "";
		
		public static var templeOutputServerPath:String = "";
		public static var templeOutputClientPath:String = "";
		public static var templeOutputServerNameSpace:String = "";
		public static var templeOutputServerImport:String = "";
		public static var templeOutputClientImport:String = "";
		
		public static var enumOutputServerPath:String = "";
		public static var enumOutputClientPath:String = "";
		public static var enumOutputServerNameSpace:String = "";
		public static var enumOutputServerImport:String = "";
		public static var enumOutputClientImport:String = "";
		
		public static var protocolOutputServerPath:String = "";
		public static var protocolOutputClientPath:String = "";
		public static var protocolOutputServerNameSpace:String = "";
		public static var protocolOutputServerImport:String = "";
		public static var protocolOutputClientImport:String = "";
		
		public static var tables:Array;
		public static var enums:Array;
		public static var protocolPackages:Array;
		
		public function DataCenter()
		{
		}
		
		public static function initialize():void {
			readSetting();
			readTables();
			readEnums();
			readProtocols();
		}
		
		public static function readSetting():void {
			var xmlSetting:XML = FileHelper.readXML(GameResPath.file_cfg_data_setting);
			if (xmlSetting == null) {
				saveSetting();
			} else {
				tableInputTablePath = xmlSetting.tableInputTablePath.@path.toString();
				tableInputSettingPath = xmlSetting.tableInputSettingPath.@path.toString();
				tableOutputServerPath = xmlSetting.tableOutputServerPath.@path.toString();
				tableOutputClientPath = xmlSetting.tableOutputClientPath.@path.toString();
				tableOutputSettingPath = xmlSetting.tableOutputSettingPath.@path.toString();
				templeOutputServerPath = xmlSetting.templeOutputServerPath.@path.toString();
				templeOutputClientPath = xmlSetting.templeOutputClientPath.@path.toString();
				templeOutputServerNameSpace = xmlSetting.templeOutputServerNameSpace.@path.toString();
				templeOutputServerImport = xmlSetting.templeOutputServerImport.@path.toString();
				templeOutputClientImport = xmlSetting.templeOutputClientImport.@path.toString();
				enumOutputServerPath = xmlSetting.enumOutputServerPath.@path.toString();
				enumOutputClientPath = xmlSetting.enumOutputClientPath.@path.toString();
				enumOutputServerNameSpace = xmlSetting.enumOutputServerNameSpace.@path.toString();
				enumOutputServerImport = xmlSetting.enumOutputServerImport.@path.toString();
				enumOutputClientImport = xmlSetting.enumOutputClientImport.@path.toString();
				protocolOutputServerPath = xmlSetting.protocolOutputServerPath.@path.toString();
				protocolOutputClientPath = xmlSetting.protocolOutputClientPath.@path.toString();
				protocolOutputServerNameSpace = xmlSetting.protocolOutputServerNameSpace.@path.toString();
				protocolOutputServerImport = xmlSetting.protocolOutputServerImport.@path.toString();
				protocolOutputClientImport = xmlSetting.protocolOutputClientImport.@path.toString();
			}
		}
		
		public static function saveSetting():void {
			var xmlSetting:XML = <setting/>;
			xmlSetting.appendChild(<tableInputTablePath path={tableInputTablePath}/>);
			xmlSetting.appendChild(<tableInputSettingPath path={tableInputSettingPath}/>);
			xmlSetting.appendChild(<tableOutputServerPath path={tableOutputServerPath}/>);
			xmlSetting.appendChild(<tableOutputClientPath path={tableOutputClientPath}/>);
			xmlSetting.appendChild(<tableOutputSettingPath path={tableOutputSettingPath}/>);
			xmlSetting.appendChild(<templeOutputServerPath path={templeOutputServerPath}/>);
			xmlSetting.appendChild(<templeOutputClientPath path={templeOutputClientPath}/>);
			xmlSetting.appendChild(<templeOutputServerNameSpace path={templeOutputServerNameSpace}/>);
			xmlSetting.appendChild(<templeOutputServerImport path={templeOutputServerImport}/>);
			xmlSetting.appendChild(<templeOutputClientImport path={templeOutputClientImport}/>);
			xmlSetting.appendChild(<enumOutputServerPath path={enumOutputServerPath}/>);
			xmlSetting.appendChild(<enumOutputClientPath path={enumOutputClientPath}/>);
			xmlSetting.appendChild(<enumOutputServerNameSpace path={enumOutputServerNameSpace}/>);
			xmlSetting.appendChild(<enumOutputServerImport path={enumOutputServerImport}/>);
			xmlSetting.appendChild(<enumOutputClientImport path={enumOutputClientImport}/>);
			xmlSetting.appendChild(<protocolOutputServerPath path={protocolOutputServerPath}/>);
			xmlSetting.appendChild(<protocolOutputClientPath path={protocolOutputClientPath}/>);
			xmlSetting.appendChild(<protocolOutputServerNameSpace path={protocolOutputServerNameSpace}/>);
			xmlSetting.appendChild(<protocolOutputServerImport path={protocolOutputServerImport}/>);
			xmlSetting.appendChild(<protocolOutputClientImport path={protocolOutputClientImport}/>);
			FileHelper.saveXML(GameResPath.file_cfg_data_setting, xmlSetting);
		}
		
		public static function readTables():void {
			tables = [];
			var file:File;
			if (tableInputTablePath) {
				tables = tables.concat(readTableByPath(tableInputTablePath, TypeTable.TABLE));
			}
			if (tableInputSettingPath) {
				tables = tables.concat(readTableByPath(tableInputSettingPath, TypeTable.SETTING));
			}
			tables.sortOn("type", Array.NUMERIC);
		}
		
		private static function readTableByPath(path:String, type:int):Array {
			var tables:Array = [];
			var folder:File = new File(File.applicationDirectory.nativePath).resolvePath(path);
			if (folder.exists) {
				var files:Array = folder.getDirectoryListing();
				var tableVo:TableVo;
				for each (var file:File in files) {
					var fileName:String = file.name.substring(0, file.name.lastIndexOf("."));
					var extension:String = file.extension;
					tableVo = new TableVo();
					tableVo.name = fileName;
					tableVo.extension = extension;
					tableVo.type = type;
					tableVo.content = FileHelper.readText(file.nativePath);
					tables.push(tableVo);
				}
			}
			return tables;
		}
		
		public static function readEnums():void {
			enums = [];
			var xmlEnums:XML = FileHelper.readXML(GameResPath.file_cfg_data_enums);
			if (xmlEnums == null) {
				saveEnums();
			} else {
				var enumVo:EnumVo;
				for each (var xmlEnum:XML in xmlEnums.children()) {
					enumVo = new EnumVo();
					enumVo.name = xmlEnum.@name.toString();
					var filedVo:EnumFieldVo;
					for each (var xmlField:XML in xmlEnum.field) {
						filedVo = new EnumFieldVo();
						filedVo.value = int(xmlField.@value);
						filedVo.name = xmlField.@name.toString();
						filedVo.desc = xmlField.@desc.toString();
						enumVo.fields.push(filedVo);
					}
					enumVo.sortFields();
					enums.push(enumVo);
				}
			}
		}
		
		public static function saveEnums():void {
			var xmlEnums:XML = <enums/>;
			for each (var enumVo:EnumVo in enums) {
				var xmlEnum:XML = <enum name={enumVo.name}/>;
				for each (var fieldVo:EnumFieldVo in enumVo.fields) {
					xmlEnum.appendChild(<field value={fieldVo.value} name={fieldVo.name} desc={fieldVo.desc}/>);
				}
				xmlEnums.appendChild(xmlEnum);
			}
			FileHelper.saveXML(GameResPath.file_cfg_data_enums, xmlEnums);
		}
		
		/**
		 * 删除枚举
		 * @param enumVo
		 * 
		 */		
		public static function deleteEnum(enumVo:EnumVo):void {
			ArrayUtil.removeElements(enums, enumVo);
		}
		
		public static function readProtocols():void {
			protocolPackages = [];
			var xmlProtocols:XML = FileHelper.readXML(GameResPath.file_cfg_data_protocols);
			if (xmlProtocols == null) {
				saveProtocols();
			} else {
				var protocolPackageVo:ProtocolPackageVo;
				for each (var xmlProtocolPackage:XML in xmlProtocols.children()) {
					protocolPackageVo = new ProtocolPackageVo();
					protocolPackageVo.name = xmlProtocolPackage.@name.toString();
					var protocolVo:ProtocolVo;
					for each (var xmlProtocol:XML in xmlProtocolPackage.protocol) {
						protocolVo = new ProtocolVo();
						protocolVo.id = int(xmlProtocol.@value);
						protocolVo.name = xmlProtocol.@name.toString();
						protocolVo.desc = xmlProtocol.@desc.toString();
						protocolVo.content = xmlProtocol.@content.toString();
						protocolPackageVo.protocols.push(protocolVo);
					}
					protocolPackageVo.sortProtocols();
					protocolPackages.push(protocolPackageVo);
				}
			}
		}
		
		public static function saveProtocols():void {
			var xmlProtocols:XML = <protocolPackages/>;
			for each (var protocolPackageVo:ProtocolPackageVo in protocolPackages) {
				var xmlProtocolPackage:XML = <protocolPackage name={protocolPackageVo.name}/>;
				for each (var protocolVo:ProtocolVo in protocolPackageVo.protocols) {
					xmlProtocolPackage.appendChild(<protocol value={protocolVo.id} name={protocolVo.name} desc={protocolVo.desc} content={protocolVo.content}/>);
				}
				xmlProtocols.appendChild(xmlProtocolPackage);
			}
			FileHelper.saveXML(GameResPath.file_cfg_data_protocols, xmlProtocols);
		}
		
		/**
		 * 删除协议目录
		 * @param protocolPackageVo
		 * 
		 */			
		public static function deleteProtocols(protocolPackageVo:ProtocolPackageVo):void {
			ArrayUtil.removeElements(protocolPackages, protocolPackageVo);
		}
		
		/**
		 * 验证协议ID是否重复
		 * @param id
		 * @return 
		 * 
		 */		
		public static function validateProtocolId(id:int):Boolean {
			for each (var protocolPackageVo:ProtocolPackageVo in protocolPackages) {
				for each (var protocolVo:ProtocolVo in protocolPackageVo.protocols) {
					if (protocolVo.id == id) {
						return false;
					}
				}
			}
			return true;
		}
		
		/**
		 * 验证协议名称是否重复
		 * @param name
		 * @return 
		 * 
		 */		
		public static function validateProtocolName(name:String):Boolean {
			for each (var protocolPackageVo:ProtocolPackageVo in protocolPackages) {
				for each (var protocolVo:ProtocolVo in protocolPackageVo.protocols) {
					if (protocolVo.name == name) {
						return false;
					}
				}
			}
			return true;
		}
		
		public static function getNextProtocolId():int {
			var max:int = -1;
			for each (var protocolPackageVo:ProtocolPackageVo in protocolPackages) {
				for each (var protocolVo:ProtocolVo in protocolPackageVo.protocols) {
					if (protocolVo.id > max) {
						max = protocolVo.id;
					}
				}
			}
			return max + 1;
		}
		
		/**
		 * 获取所有协议
		 * @return 
		 * 
		 */		
		public static function getAllProtocols():Array {
			var protocols:Array = [];
			var protocolPackages:Array = DataCenter.protocolPackages;
			for each (var protocolPackageVo:ProtocolPackageVo in protocolPackages) {
				protocols = protocols.concat(protocolPackageVo.protocols);
			}
			protocols.sortOn("number#", Array.NUMERIC);
			return protocols;
		}
		
		/**
		 * 发布
		 * 
		 */		
		public static function release():void {
			if (tableOutputServerPath) {
				var serverInputFile:File = new File(File.applicationDirectory.nativePath).resolvePath(tableInputTablePath);
				var serverOutputFile:File = new File(File.applicationDirectory.nativePath).resolvePath(tableOutputServerPath);
				FileHelper.copy(serverInputFile.nativePath, serverOutputFile.nativePath);
			}
			if (tableOutputClientPath) {
				createConfigAS();
			}
			if (tableOutputSettingPath) {
				var settingInputFile:File = new File(File.applicationDirectory.nativePath).resolvePath(tableInputSettingPath);
				var settingOutputFile:File = new File(File.applicationDirectory.nativePath).resolvePath(tableOutputSettingPath);
				FileHelper.copy(settingInputFile.nativePath, settingOutputFile.nativePath);
			}
			if (templeOutputServerPath) {
				releaseAllTempleCS();
			}
			if (templeOutputClientPath) {
				releaseAllTempleAS();
			}
			if (enumOutputServerPath) {
				releaseAllEnumCS();
			}
			if (enumOutputClientPath) {
				releaseAllEnumAS();
			}
			if (protocolOutputServerPath) {
				releaseAllProtocolsCS();
			}
			if (protocolOutputClientPath) {
				releaseAllProtocolsAS();
			}
		}
		
		/**
		 * 创建AS数据包
		 * 
		 */		
		private static function createConfigAS():void {
			var result:Object = {};
			
			var config:Object = {};
			var json:Object = {};
			var xml:Object = {};
			var text:Object = {};
			for each (var tableVo:TableVo in tables) {
				if (tableVo.isTable) {
					var types:Object = {};
					for (var i:int = 0; i < tableVo.tblFields.length; i++) {
						types[tableVo.tblFields[i]] = TypeAttribute.AS_MAP[tableVo.tblTypes[i]];
					}
					config[tableVo.name] = {types:types, data:ArrayUtil.arrayToObject(tableVo.tblDatas, "number#")};
				} else if (tableVo.isJson) {
					json[tableVo.name] = tableVo.content;
				} else if (tableVo.isXML) {
					xml[tableVo.name] = tableVo.content;
				} else {
					text[tableVo.name] = tableVo.content;
				}
			}
			
			result.config = config;
			result.json = json;
			result.xml = xml;
			result.text = text;
			
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(result);
			bytes.compress();
			
			var clientOutputFile:File = new File(File.applicationDirectory.nativePath).resolvePath(tableOutputClientPath + "\\config.byte");
			FileHelper.save(clientOutputFile.nativePath, bytes);
		}
		
		/**
		 * 发布CS模板
		 * 
		 */		
		private static function releaseAllTempleCS():void {
			for each (var tableVo:TableVo in tables) {
				if (tableVo.isTable) {
					var csStr:String = CodeHelper.createTempleCS(tableVo);
					var csFile:File = new File(File.applicationDirectory.nativePath).resolvePath(templeOutputServerPath + "\\" + tableVo.csFileName);
					FileHelper.saveText(csFile.nativePath, csStr);
				}
			}
		}
		
		/**
		 * 发布AS模板
		 * 
		 */		
		private static function releaseAllTempleAS():void {
			for each (var tableVo:TableVo in tables) {
				if (tableVo.isTable) {
					var asTempleStr:String = CodeHelper.createTempleAS(tableVo);
					var asTempleFile:File = new File(File.applicationDirectory.nativePath).resolvePath(templeOutputClientPath + "\\temple\\" + tableVo.asFileName);
					FileHelper.saveText(asTempleFile.nativePath, asTempleStr);
					var asCfgFile:File = new File(File.applicationDirectory.nativePath).resolvePath(templeOutputClientPath + "\\" + tableVo.asConfigFileName);
					if (!FileHelper.isExist(asCfgFile.nativePath)) {
						var asCfgStr:String = CodeHelper.createConfigAS(tableVo);
						FileHelper.saveText(asCfgFile.nativePath, asCfgStr);
					}
				}
			}
		}
		
		/**
		 * 发布CS枚举
		 * 
		 */		
		private static function releaseAllEnumCS():void {
			for each (var enumVo:EnumVo in enums) {
				var csStr:String = CodeHelper.createEnumCS(enumVo);
				var csFile:File = new File(File.applicationDirectory.nativePath).resolvePath(enumOutputServerPath + "\\" + enumVo.csFileName);
				FileHelper.saveText(csFile.nativePath, csStr);
			}
		}
		
		/**
		 * 发布AS枚举
		 * 
		 */		
		private static function releaseAllEnumAS():void {
			var enumFolder:File = new File(File.applicationDirectory.nativePath).resolvePath(enumOutputClientPath);
			if (enumFolder.exists) {
				FileHelper.deleteFile(enumFolder.nativePath);
			}
			for each (var enumVo:EnumVo in enums) {
				var asStr:String = CodeHelper.createEnumAS(enumVo);
				var asFile:File = new File(File.applicationDirectory.nativePath).resolvePath(enumOutputClientPath + "\\" + enumVo.asFileName);
				FileHelper.saveText(asFile.nativePath, asStr);
			}
		}
		
		/**
		 * 发布CS协议
		 * 
		 */		
		private static function releaseAllProtocolsCS():void {
			var msgCodeIdStr:String = CodeHelper.createProtocolCSMsgCodeId();
			var msgCodeIdFile:File = new File(File.applicationDirectory.nativePath).resolvePath(protocolOutputServerPath + "\\MsgCodeId.cs");
			FileHelper.saveText(msgCodeIdFile.nativePath, msgCodeIdStr);
			var msgHandlerStr:String = CodeHelper.createProtocolCSMsgProcessor();
			var msgHandlerFile:File = new File(File.applicationDirectory.nativePath).resolvePath(protocolOutputServerPath + "\\MsgProcessor.cs");
			FileHelper.saveText(msgHandlerFile.nativePath, msgHandlerStr);
			
			var protocols:Array = getAllProtocols();
			for each (var protocolVo:ProtocolVo in protocols) {
				var protocolStr:String = CodeHelper.createProtocolCSProtocol(protocolVo);
				var protocolFile:File = new File(File.applicationDirectory.nativePath).resolvePath(protocolOutputServerPath + "\\Protocols\\" + protocolVo.csFileName);
				FileHelper.saveText(protocolFile.nativePath, protocolStr);
				if (protocolVo.canCreateCSProcesser) {
					var processerFile:File = new File(File.applicationDirectory.nativePath).resolvePath(protocolOutputServerPath + "\\Processors\\" + protocolVo.csProcesserName);
					if (!FileHelper.isExist(processerFile.nativePath)) {
						var processerStr:String = CodeHelper.createProtocolCSProcesser(protocolVo);
						FileHelper.saveText(processerFile.nativePath, processerStr);
					}
				}
			}
		}
		
		/**
		 * 发布AS协议
		 * 
		 */		
		private static function releaseAllProtocolsAS():void {
			var protocolsFolder:File = new File(File.applicationDirectory.nativePath).resolvePath(protocolOutputClientPath + "\\protocols");
			if (protocolsFolder.exists) {
				FileHelper.deleteFile(protocolsFolder.nativePath);
			}
			var protocolConstStr:String = CodeHelper.createProtocolASProtocolConst();
			var protocolConstFile:File = new File(File.applicationDirectory.nativePath).resolvePath(protocolOutputClientPath + "\\Protocols.as");
			FileHelper.saveText(protocolConstFile.nativePath, protocolConstStr);
			var protocolMapStr:String = CodeHelper.createProtocolASProtocolMap();
			var protocolMapFile:File = new File(File.applicationDirectory.nativePath).resolvePath(protocolOutputClientPath + "\\ProtocolMap.as");
			FileHelper.saveText(protocolMapFile.nativePath, protocolMapStr);
			
			var protocols:Array = getAllProtocols();
			for each (var protocolVo:ProtocolVo in protocols) {
				var protocolStr:String = CodeHelper.createProtocolASProtocol(protocolVo);
				var protocolFile:File = new File(File.applicationDirectory.nativePath).resolvePath(protocolOutputClientPath + "\\protocols\\" + protocolVo.asFileName);
				FileHelper.saveText(protocolFile.nativePath, protocolStr);
			}
		}
	}
}