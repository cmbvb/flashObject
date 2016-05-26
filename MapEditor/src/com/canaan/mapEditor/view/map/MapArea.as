package com.canaan.mapEditor.view.map
{
	import com.canaan.lib.display.BaseSprite;
	import com.canaan.lib.utils.DisplayUtil;
	import com.canaan.mapEditor.contants.GlobalSetting;
	import com.canaan.mapEditor.models.vo.data.MapAreaVo;
	
	import flash.filters.GlowFilter;
	
	public class MapArea extends BaseSprite
	{
		private var _mapAreaVo:MapAreaVo;
		
		public function MapArea()
		{
			super();
		}

		public function get mapAreaVo():MapAreaVo {
			return _mapAreaVo;
		}

		public function set mapAreaVo(value:MapAreaVo):void {
			_mapAreaVo = value;
			refresh();
		}
		
		public function refresh():void {
			graphics.clear();
			graphics.beginFill(GlobalSetting.AREA_COLOR, GlobalSetting.AREA_ALPHA);
			for each (var grid:String in _mapAreaVo.gridData) {
				var gridArray:Array = grid.split("_");
				var x:int = int(gridArray[1]) * GlobalSetting.GRID_WIDTH;
				var y:int = int(gridArray[0]) * GlobalSetting.GRID_HEIGHT;
				graphics.drawRect(x, y, GlobalSetting.GRID_WIDTH, GlobalSetting.GRID_HEIGHT);
			}
			graphics.endFill();
		}
		
		public function showSelect():void {
			hideSelect();
			DisplayUtil.addFilter(this, new GlowFilter(0xFF0000, 1, 2, 2));
		}
		
		public function hideSelect():void {
			DisplayUtil.removeFilter(this, GlowFilter);
		}
	}
}