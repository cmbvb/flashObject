package com.canaan.mapEditor.models.vo.data
{
	import com.canaan.lib.utils.ArrayUtil;
	import com.canaan.mapEditor.contants.GlobalSetting;
	
	import flash.geom.Point;

	public class MapAreaVo
	{
		private var _name:String;
		private var _gridData:Array;
		private var _functionIds:Array;
		private var _functionParams:Array;
		private var _extraData:String;
		
		private var _mapDataVo:MapDataVo;
		
		public function MapAreaVo()
		{
			_name = "";
			_gridData = [];
			_functionIds = [];
			_functionParams = [];
			_extraData = "";
		}
		
		public function get mapDataVo():MapDataVo {
			return _mapDataVo;
		}
		
		public function set mapDataVo(mapDataVo:MapDataVo):void {
			_mapDataVo = mapDataVo;
		}
		
		public function remove():void {
			ArrayUtil.removeElements(_mapDataVo.areas, this);
		}
		
		public function setData(value:Object):void {
			_name = value.name;
			_gridData = value.griddata || [];
			_functionIds = value.functionIds || [];
			_functionParams = value.functionParams || [];
			_extraData = value.extraData || "";
		}
		
		public function getData():Object {
			return {
				"name":_name,
				"griddata":_gridData,
				"functionIds":_functionIds,
				"functionParams":_functionParams,
				"extraData":_extraData
			};
		}
		
		public function getAreaPos():Point {
			if (gridData.length > 0) {
				var grid:String = gridData[0];
				var posArray:Array = ArrayUtil.getArrayFromString(grid, "_");
				var mapY:int = int(posArray[0]);
				var mapX:int = int(posArray[1]);
				return new Point(GlobalSetting.GRID_WIDTH * mapX + GlobalSetting.HALF_GRID_WIDTH, GlobalSetting.GRID_HEIGHT * mapY + GlobalSetting.HALF_GRID_HEIGHT);
			}
			return null;
		}
		
		public function clone():MapAreaVo {
			var mapAreaVo:MapAreaVo = new MapAreaVo();
			mapAreaVo.name = _name;
			mapAreaVo.gridData = _gridData.concat();
			mapAreaVo.functionIds = _functionIds.concat();
			mapAreaVo.functionParams = _functionIds.concat();
			mapAreaVo.extraData = _extraData.concat();
			mapAreaVo.mapDataVo = _mapDataVo;
			return mapAreaVo;
		}
		
		public function hasGrid(x:int, y:int):Boolean {
			var grid:String = y + "_" + x;
			return _gridData.indexOf(grid) != -1;
		}
		
		public function addGrid(x:int, y:int):void {
			if (hasGrid(x, y) == false) {
				var grid:String = y + "_" + x;
				_gridData.push(grid);
			}
		}
		
		public function removeGrid(x:int, y:int):void {
			if (hasGrid(x, y) == true) {
				var grid:String = y + "_" + x;
				ArrayUtil.removeElements(_gridData, grid);
			}
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get gridData():Array
		{
			return _gridData;
		}

		public function set gridData(value:Array):void
		{
			_gridData = value;
		}

		public function get functionIds():Array
		{
			return _functionIds;
		}

		public function set functionIds(value:Array):void
		{
			_functionIds = value;
		}
		
		public function get functionParams():Array
		{
			return _functionParams;
		}
		
		public function set functionParams(value:Array):void
		{
			_functionParams = value;
		}

		public function get extraData():String
		{
			return _extraData;
		}

		public function set extraData(value:String):void
		{
			_extraData = value;
		}
	}
}