package com.canaan.gameEditor.cfg
{
	import com.canaan.gameEditor.core.GameResPath;
	import com.canaan.lib.abstract.AbstractVo;

	public class SoundResConfigVo extends AbstractVo
	{
		public static const TITLES:Array = ["id", "type", "desc", "fileName"];
		public static const OUTPUT_DESC:Array = ["编号", "类型", "文件名"];
		public static const OUTPUT_TITLES:Array = ["id", "type", "fileName"];
		public static const OUTPUT_TYPE:Array = ["int", "int", "string"];
		
		private var _id:int;
		private var _type:int;
		private var _desc:String;
		private var _fileName:String;
		
		public function SoundResConfigVo()
		{
			super();
		}
		
		public function get cfgData():Object {
			var data:Object = {};
			data["id"] = _id;
			data["type"] = _type;
			data["desc"] = _desc;
			data["fileName"] = _fileName;
			return data;
		}
		
		public function get sourcePath():String {
			return GameResPath.cfg_audioSource + _fileName;
		}
		
		public function get fullPath():String {
			return GameResPath.audio + _fileName;
		}
		
		public function get showText():String {
			return _id + (_desc ? "(" + _desc + ")" : "(未备注)");
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function set type(value:int):void
		{
			_type = value;
		}

		public function get desc():String
		{
			return _desc;
		}

		public function set desc(value:String):void
		{
			_desc = value;
		}

		public function get fileName():String
		{
			return _fileName;
		}

		public function set fileName(value:String):void
		{
			_fileName = value;
		}
	}
}