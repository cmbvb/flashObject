package com.canaan.programEditor.data
{
	import com.canaan.lib.abstract.AbstractVo;
	import com.canaan.programEditor.constants.TypeTable;
	import com.canaan.programEditor.utils.TableUtil;
	import com.canaan.programEditor.utils.XmlCodeFilter;
	
	public class TableVo extends AbstractVo
	{
		private var _name:String;
		private var _extension:String;
		private var _type:int;
		private var _content:String;
		
		private var _xmlContent:String;
		private var _jsonContent:String;
		private var _tblFields:Array;
		private var _tblDescs:Array;
		private var _tblTypes:Array;
		private var _tblDatas:Array;
		
		public function TableVo()
		{
			super();
		}
		
		public function get isTable():Boolean {
			return _type == TypeTable.TABLE;
		}
		
		public function get isSetting():Boolean {
			return _type == TypeTable.SETTING;
		}
		
		public function get isJson():Boolean {
			return isSetting && _extension.toLowerCase() == "json";
		}
		
		public function get isXML():Boolean {
			return isSetting && _extension.toLowerCase() == "xml";
		}
		
		public function get asCfgName():String {
			return _name + "ConfigVo";
		}
		
		public function get csFileName():String {
			return _name + ".cs";
		}
		
		public function get asFileName():String {
			return _name + ".as";
		}
		
		public function get asConfigFileName():String {
			return asCfgName + ".as";
		}
		
		public function get xmlContent():String {
			return _xmlContent;
		}
		
		public function get jsonContent():String {
			return _jsonContent;
		}
		
		public function get tblFields():Array {
			return _tblFields;
		}
		
		public function get tblDescs():Array {
			return _tblDescs;
		}
		
		public function get tblTypes():Array {
			return _tblTypes;
		}
		
		public function get tblDatas():Array {
			return _tblDatas;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get extension():String
		{
			return _extension;
		}
		
		public function set extension(value:String):void
		{
			_extension = value;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}

		public function get content():String
		{
			return _content;
		}

		public function set content(value:String):void
		{
			_content = value;
			switch (_type) {
				case TypeTable.TABLE:
					var object:Object = TableUtil.XLSToArray2(_content);
					_tblFields = object.keys;
					_tblDescs = object.descs;
					_tblTypes = object.types;
					_tblDatas = object.datas;
					break;
				case TypeTable.SETTING:
					if (isJson) {
						var jsonObj:Object = JSON.parse(_content);
						_jsonContent = JSON.stringify(jsonObj, null, "\t");
					} else if (isXML) {
						_xmlContent = XmlCodeFilter.filter(_content);
					}
					break;
			}
		}
	}
}