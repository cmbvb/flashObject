package com.canaan.mapEditor.models.vo.data
{
	import com.canaan.lib.core.TableConfig;
	import com.canaan.lib.role.constants.TypeRoleDirection;
	import com.canaan.lib.utils.ArrayUtil;
	import com.canaan.mapEditor.contants.GlobalSetting;
	import com.canaan.mapEditor.core.GameRes;
	import com.canaan.mapEditor.models.contants.TypeUnit;
	import com.canaan.mapEditor.models.vo.table.UnitTempleConfigVo;

	public class MapUnitVo
	{
		private var _name:String;
		private var _unitId:int;
		private var _direction:int;
		private var _mapX:int;
		private var _mapY:int;
		private var _realX:int;
		private var _realY:int;
		private var _showText:String;
		private var _showDelay:int;
		private var _extraData:String;
		private var _fixedDir:int;
		private var _cantMove:int;
		
		private var _mapDataVo:MapDataVo;
		private var _unitConfig:UnitTempleConfigVo;
		
		public function MapUnitVo()
		{
			_name = "";
			_extraData = "";
			_showText = "";
			_direction = TypeRoleDirection.DOWN;
		}
		
		public function get mapDataVo():MapDataVo {
			return _mapDataVo;
		}
		
		public function set mapDataVo(mapDataVo:MapDataVo):void {
			_mapDataVo = mapDataVo;
		}
		
		public function remove():void {
			if (_unitConfig.type == TypeUnit.DECORATION) {
				ArrayUtil.removeElements(_mapDataVo.decorations, this);
			} else {
				ArrayUtil.removeElements(_mapDataVo.units, this);
			}
		}
		
		public function setData(value:Object):void {
			_name = value.name || "";
			unitId = value.templeID;
			_direction = value.direction || TypeRoleDirection.DOWN;
			_mapX = value.j;
			_mapY = value.i;
			_realX = value.x;
			_realY = value.y;
			_showText = value.showText || "";
			_showDelay = value.showDelay || 0;
			_extraData = value.extraData || "";
			_fixedDir = value.fixedDir || 0;
			_cantMove = value.cantMove || 0;
		}
		
		public function getData():Object {
			return {
				"name":_name,
				"templeID":_unitId,
				"direction":_direction,
				"j":_mapX,
				"i":_mapY,
				"x":_realX,
				"y":_realY,
				"showText":_showText,
				"showDelay":_showDelay,
				"extraData":_extraData,
				"fixedDir":_fixedDir,
				"cantMove":_cantMove
			};
		}
		
		public function get unitConfig():UnitTempleConfigVo {
			return _unitConfig;
		}
		
		public function get type():int {
			return _unitConfig.type;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get unitId():int
		{
			return _unitId;
		}

		public function set unitId(value:int):void
		{
			_unitId = value;
			_unitConfig = TableConfig.getConfigVo(GameRes.TBL_UNIT, _unitId) as UnitTempleConfigVo;
		}
		
		public function get direction():int
		{
			return _direction;
		}
		
		public function set direction(value:int):void
		{
			_direction = value;
		}

		public function get mapX():int
		{
			return _mapX;
		}

		public function set mapX(value:int):void
		{
			_mapX = Math.min(Math.max(0, value), _mapDataVo.colCount - 1);
			_realX = _mapX * GlobalSetting.GRID_WIDTH + GlobalSetting.HALF_GRID_WIDTH;
		}

		public function get mapY():int
		{
			return _mapY;
		}

		public function set mapY(value:int):void
		{
			_mapY = Math.min(Math.max(0, value), _mapDataVo.rowCount - 1);
			_realY = _mapY * GlobalSetting.GRID_HEIGHT + GlobalSetting.HALF_GRID_HEIGHT;
		}

		public function get realX():int
		{
			return _realX;
		}

		public function set realX(value:int):void
		{
			_realX = Math.min(Math.max(0, value), _mapDataVo.mapGridWidth);
			_mapX = int(_realX / GlobalSetting.GRID_WIDTH);
		}

		public function get realY():int
		{
			return _realY;
		}

		public function set realY(value:int):void
		{
			_realY = Math.min(Math.max(0, value), _mapDataVo.mapGridHeight);
			_mapY = int(_realY / GlobalSetting.GRID_HEIGHT);
		}
		
		public function get showText():String
		{
			return _showText;
		}
		
		public function set showText(value:String):void
		{
			_showText = value;
		}
		
		public function get showDelay():int
		{
			return _showDelay;
		}
		
		public function set showDelay(value:int):void
		{
			_showDelay = value;
		}

		public function get extraData():String
		{
			return _extraData;
		}

		public function set extraData(value:String):void
		{
			_extraData = value;
		}

		public function get fixedDir():int
		{
			return _fixedDir;
		}

		public function set fixedDir(value:int):void
		{
			_fixedDir = value;
		}

		public function get cantMove():int
		{
			return _cantMove;
		}

		public function set cantMove(value:int):void
		{
			_cantMove = value;
		}

	}
}