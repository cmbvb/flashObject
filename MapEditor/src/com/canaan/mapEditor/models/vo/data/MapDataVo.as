package com.canaan.mapEditor.models.vo.data
{
	import com.canaan.lib.utils.ArrayUtil;
	import com.canaan.mapEditor.contants.GlobalSetting;
	import com.canaan.mapEditor.core.GameResPath;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	public class MapDataVo
	{
		private var _name:String;
		private var _resName:String;
		private var _bitmapData:BitmapData;
		private var _blocks:Array;
		private var _areas:Array;
		private var _units:Array;
		private var _decorations:Array;
		
		private var _mapWidth:int;
		private var _mapHeight:int;
		private var _mapGridWidth:int;
		private var _mapGridHeight:int;
		private var _rowCount:int;
		private var _colCount:int;
		private var _tileRowCount:int;
		private var _tileColCount:int;
		
		public function MapDataVo()
		{
			_name = "";
			_resName = "";
			_areas = [];
			_units = [];
			_decorations = [];
		}
		
		public function clear():void {
			_name = "";
			_resName = "";
			_areas = [];
			_units = [];
			_decorations = [];
		}
		
		public function setData(value:Object):void {
			// 地图名
			_name = value.name;
			// 资源名
			_resName = value.resName || _name;
			// 地形
			_blocks = value.blocks;
			// 区域
			_areas = [];
			var areaVo:MapAreaVo;
			for each (var areaObj:Object in value.areas) {
				areaVo = new MapAreaVo();
				areaVo.mapDataVo = this;
				areaVo.setData(areaObj);
				_areas.push(areaVo);
			}
			// 单位
			_units = [];
			var unitVo:MapUnitVo;
			for each (var unitObj:Object in value.units) {
				unitVo = new MapUnitVo();
				unitVo.mapDataVo = this;
				unitVo.setData(unitObj);
				_units.push(unitVo);
			}
			// 装饰
			_decorations = [];
			var decorationVo:MapUnitVo;
			for each (var decorationObj:Object in value.ornas) {
				decorationVo = new MapUnitVo();
				decorationVo.mapDataVo = this;
				decorationVo.setData(decorationObj);
				_decorations.push(decorationVo);
			}
		}
		
		/**
		 * 数据对象
		 * @return 
		 * 
		 */		
		public function getData():Object {
			return {
				"name":_name,
				"resName":_resName,
				"mapWidth":_mapWidth,
				"mapHeight":_mapHeight,
				"rowCount":_rowCount,
				"colCount":_colCount,
				"blocks":_blocks,
				"areas":getAreasData(),
				"units":getUnitsData(),
				"ornas":getDecorationsData()
			};
		}
		
		/**
		 * JSON数据
		 * @return 
		 * 
		 */		
		public function getDataJson():String {
			return JSON.stringify(getData());
		}
		
		/**
		 * 客户端数据
		 * @return 
		 * 
		 */		
		public function getClientData():ByteArray {
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(getData());
			bytes.compress();
			return bytes;
		}
		
		private function getAreasData():Array {
			var areaDatas:Array = [];
			for each (var areaVo:MapAreaVo in _areas) {
				areaDatas.push(areaVo.getData());
			}
			return areaDatas;
		}
		
		public function getUnitsData():Array {
			var unitDatas:Array = [];
			for each (var mapUnitVo:MapUnitVo in _units) {
				unitDatas.push(mapUnitVo.getData());
			}
			return unitDatas;
		}
		
		public function getDecorationsData():Array {
			var decorationDatas:Array = [];
			for each (var mapUnitVo:MapUnitVo in _decorations) {
				decorationDatas.push(mapUnitVo.getData());
			}
			return decorationDatas;
		}
		
		/**
		 * 根据类型获取单位
		 * @param type
		 * @return 
		 * 
		 */		
		public function getUnitsByType(type:int):Array {
			return ArrayUtil.findArray(_units, "type", type);
		}
		
		/**
		 * 创建空格子
		 * @param blockType
		 * 
		 */		
		public function createBlocks(blockType:int = 0):void {
			_blocks = [];
			for (var i:int = 0; i < _rowCount; i++) {
				_blocks[i] = [];
				for (var j:int = 0; j < _colCount; j++) {
					_blocks[i][j] = 0;
				}
			}
		}
		
		/**
		 * 图片路径
		 * @return 
		 * 
		 */		
		public function get imagePath():String {
			return GameResPath.file_map_root + _resName + ".jpg";
		}
		
		/**
		 * 切图路径
		 * @return 
		 * 
		 */		
		public function get tilePath():String {
			return GameResPath.file_client_map + "tiles\\" + _resName + "\\";
		}
		
		/**
		 * 缩略图路径
		 * @return 
		 * 
		 */		
		public function get thumbnailsPath():String {
			return GameResPath.file_client_map + "thumbnails\\" + _resName + ".jpg";
		}
		
		/**
		 * 客户端路径
		 * @return 
		 * 
		 */		
		public function get clientPath():String {
			return GameResPath.file_client_map + "data\\" + _name + ".mpd";
		}
		
		/**
		 * 服务器路径
		 * @return 
		 * 
		 */		
		public function get serverPath():String {
			return GameResPath.file_server_path + _name + ".mpt";
		}
		
		/**
		 * 地图宽度
		 * @return 
		 * 
		 */		
		public function get mapWidth():int {
			return _mapWidth;
		}
		
		/**
		 * 地图高度
		 * @return 
		 * 
		 */		
		public function get mapHeight():int {
			return _mapHeight;
		}
		
		/**
		 * 地图格子宽度
		 * @return 
		 * 
		 */		
		public function get mapGridWidth():int {
			return _mapGridWidth;
		}
		
		/**
		 * 地图格子高度
		 * @return 
		 * 
		 */		
		public function get mapGridHeight():int {
			return _mapGridHeight;
		}
		
		/**
		 * 行数量
		 * @return 
		 * 
		 */		
		public function get rowCount():int {
			return _rowCount;
		}
		
		/**
		 * 列数量
		 * @return 
		 * 
		 */		
		public function get colCount():int {
			return _colCount;
		}
		
		/**
		 * 切片行数量
		 * @return 
		 * 
		 */		
		public function get tileRowCount():int {
			return _tileRowCount;
		}
		
		/**
		 * 切片列数量
		 * @return 
		 * 
		 */		
		public function get tileColCount():int {
			return _tileColCount;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get resName():String
		{
			return _resName;
		}
		
		public function set resName(value:String):void
		{
			_resName = value;
		}

		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}

		public function set bitmapData(value:BitmapData):void
		{
			_bitmapData = value;
			_mapWidth = _bitmapData.width;
			_mapHeight = _bitmapData.height;
			
			_colCount = Math.ceil(_mapWidth / GlobalSetting.GRID_WIDTH);
			_rowCount = Math.ceil(_mapHeight / GlobalSetting.GRID_HEIGHT);
			_tileColCount = Math.ceil(_mapWidth / GlobalSetting.TILE_WIDTH);
			_tileRowCount = Math.ceil(_mapHeight / GlobalSetting.TILE_HEIGHT);
			_mapGridWidth = _colCount * GlobalSetting.GRID_WIDTH;
			_mapGridHeight = _rowCount * GlobalSetting.GRID_HEIGHT;
		}

		public function get blocks():Array
		{
			return _blocks;
		}

		public function set blocks(value:Array):void
		{
			_blocks = value;
		}

		public function get areas():Array
		{
			return _areas;
		}

		public function set areas(value:Array):void
		{
			_areas = value;
		}
		
		public function get units():Array
		{
			return _units;
		}
		
		public function set units(value:Array):void
		{
			_units = value;
		}

		public function get decorations():Array
		{
			return _decorations;
		}

		public function set decorations(value:Array):void
		{
			_decorations = value;
		}
	}
}