package com.canaan.mapEditor.view.map
{
	import com.canaan.lib.display.BaseSprite;
	import com.canaan.mapEditor.contants.GlobalSetting;
	import com.canaan.mapEditor.models.contants.TypeMapMode;
	
	public class MapMouseGrid extends BaseSprite
	{
		private var mMode:int;
		private var mMouseSize:int;
		
		public function MapMouseGrid()
		{
			super();
			initialize();
		}
		
		private function initialize():void {
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		public function setMode(mode:int, size:int):void {
			mMode = mode;
			mMouseSize = size;
			graphics.clear();
			var gridWidth:Number = mMouseSize * GlobalSetting.GRID_WIDTH;
			var gridHeight:Number = mMouseSize * GlobalSetting.GRID_HEIGHT;
			switch (mMode) {
				case TypeMapMode.SET_NORMAL:
					graphics.beginFill(0x00ff00, 0.3);
					graphics.drawRect(-gridWidth / 2, -gridHeight / 2, gridWidth, gridHeight);
					graphics.endFill();
					break;
				case TypeMapMode.SET_ALPHA:
					graphics.beginFill(0xffffff, 0.3);
					graphics.drawRect(-gridWidth / 2, -gridHeight / 2, gridWidth, gridHeight);
					graphics.endFill();
					break;
				case TypeMapMode.SET_OBSTACLE:
					graphics.beginFill(0xff0000, 0.3);
					graphics.drawRect(-gridWidth / 2, -gridHeight / 2, gridWidth, gridHeight);
					graphics.endFill();
					break;
			}
		}
	}
}