package com.canaan.mapEditor.view.map
{
	import com.canaan.lib.display.BaseSprite;
	import com.canaan.mapEditor.contants.GlobalSetting;
	
	public class MapMouseArea extends BaseSprite
	{
		public function MapMouseArea()
		{
			super();
			initialize();
		}
		
		private function initialize():void {
			mouseEnabled = false;
			mouseChildren = false;
			
			graphics.clear();
			graphics.beginFill(0xff9900, 0.5);
			graphics.drawRect(-GlobalSetting.GRID_WIDTH / 2, -GlobalSetting.GRID_HEIGHT / 2, GlobalSetting.GRID_WIDTH, GlobalSetting.GRID_HEIGHT);
			graphics.endFill();
		}
	}
}