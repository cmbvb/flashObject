package mapTool.model.vo
{
	import mapTool.MapSetting;

	public class MapDataVo
	{
//		private var _mapBitmapData:BitmapData;
		private var _mapWidth:int;
		private var _mapHeight:int;
		private var _gridW:int;
		private var _gridH:int;
		private var _mapCol:int;
		private var _mapRow:int;
		private var _name:String;
		
		public function MapDataVo()
		{
		}

		public function setData(obj:Object):void {
			if (obj.hasOwnProperty("name")) {
				_name = obj.name;
			}
			if (obj.hasOwnProperty("mapWidth")) {
				_mapWidth = obj.mapWidth;
			}
			if (obj.hasOwnProperty("mapHeight")) {
				_mapHeight = obj.mapHeight;
			}
			if (obj.hasOwnProperty("gridW")) {
				_gridW = obj.gridW;
			}
			if (obj.hasOwnProperty("gridH")) {
				_gridH = obj.gridH;
			}
			if (obj.hasOwnProperty("mapCol")) {
				_mapCol = obj.mapCol;
			}
			if (obj.hasOwnProperty("mapRow")) {
				_mapRow = obj.mapRow;
			}
		}
		
		public function get mapWidth():int
		{
			return _mapWidth;
		}

		public function get mapHeight():int
		{
			return _mapHeight;
		}

		public function get gridW():int
		{
			return MapSetting.gridW;
		}

		public function get gridH():int
		{
			return MapSetting.gridH;
		}

		public function get mapCol():int
		{
			if (_mapCol == 0) {
				_mapCol = mapHeight / gridH;
			}
			return _mapCol;
		}

		public function get mapRow():int
		{
			if (_mapRow == 0) {
				_mapRow = mapWidth / gridW;
			}
			return _mapRow;
		}

		public function set mapWidth(value:int):void
		{
			_mapWidth = value;
		}

		public function set mapHeight(value:int):void
		{
			_mapHeight = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}


	}
}