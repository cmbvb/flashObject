package mapTool
{
	import flash.net.SharedObject;

	public class MapSetting
	{
		private static var _ins:MapSetting;
		private static var shareObj:SharedObject;
		private static var _gridW:int;							// 格子宽
		private static var _gridH:int;							// 格子高
		private static var _clientDataSavePath:String = "";		// 客户端数据保存路径
		
		public function MapSetting():void {
			shareObj = SharedObject.getLocal("MapSetting");
		}
		
		public static function get ins():MapSetting {
			if (_ins == null) {
				_ins = new MapSetting();
			}
			return _ins;
		}

		public function init():Boolean {
			if (gridW && gridH) {
				return true;
			}
			return false;
		}
		
		public static function get gridW():int
		{
			if (shareObj.data.hasOwnProperty("gridW")) {
				_gridW = shareObj.data["gridW"];
			}
			return _gridW;
		}

		public static function set gridW(value:int):void
		{
			shareObj.data["gridW"] = value;
			_gridW = value;
			
		}

		public static function get gridH():int
		{
			if (shareObj.data.hasOwnProperty("gridH")) {
				_gridH = shareObj.data["gridH"];
			}
			return _gridH;
		}

		public static function set gridH(value:int):void
		{
			shareObj.data["gridH"] = value;
			_gridH = value;
		}

		public static function get clientDataSavePath():String
		{
			if (shareObj.data.hasOwnProperty("clientDataSavePath")) {
				_clientDataSavePath = shareObj.data.clientDataSavePath;
			}
			return _clientDataSavePath;
		}

		public static function set clientDataSavePath(value:String):void
		{
			shareObj.data["clientDataSavePath"] = value;
			_clientDataSavePath = value;
		}


	}
}