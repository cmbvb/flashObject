package com.canaan.mapEditor.view.map
{
	import com.canaan.lib.component.controls.Label;
	import com.canaan.lib.display.BaseSprite;
	import com.canaan.mapEditor.contants.GlobalSetting;
	import com.canaan.mapEditor.contants.TypeRoleAction;
	import com.canaan.mapEditor.models.vo.data.MapUnitVo;
	
	import flash.display.Shape;
	import flash.text.TextFormatAlign;
	
	public class MapObject extends BaseSprite
	{
		private var _mapUnitVo:MapUnitVo;
		
		private var mBMPLoader:BMPActionLoader;
		private var mLblName:Label;
		
		public function MapObject()
		{
			super();
			initialize();
		}
		
		private function initialize():void {
			mBMPLoader = new BMPActionLoader();
			addChild(mBMPLoader);
			mLblName = new Label();
			mLblName.width = 100;
			mLblName.height = 20;
			mLblName.align = TextFormatAlign.CENTER;
			mLblName.color = 0xffffff;
			mLblName.moveTo(-50, -55);
			addChild(mLblName);
			graphics.clear();
			graphics.beginFill(0, 0);
			graphics.drawRect(-GlobalSetting.GRID_WIDTH / 2, - GlobalSetting.GRID_HEIGHT / 2, GlobalSetting.GRID_WIDTH, GlobalSetting.GRID_HEIGHT);
			graphics.endFill();
		}
		
		public function get mapUnitVo():MapUnitVo {
			return _mapUnitVo;
		}
		
		public function set mapUnitVo(mapUnitVo:MapUnitVo):void {
			_mapUnitVo = mapUnitVo;
			refreshObject();
			refreshPos();
		}
		
		public function refreshObject():void {
			mBMPLoader.setAction(_mapUnitVo.unitConfig.model, _mapUnitVo.unitConfig.roleResConfig.type, TypeRoleAction.IDLE, _mapUnitVo.direction);
			mBMPLoader.play();
			mLblName.text = _mapUnitVo.showText;
		}
		
		public function refreshPos():void {
			moveTo(_mapUnitVo.realX, _mapUnitVo.realY);
		}
		
		public function showSelect():void {
			var select:Shape = getChildByName("select") as Shape;
			if (select == null) {
				select = new Shape();
				select.name = "select";
				select.graphics.lineStyle(2, 0xff0000);
				select.graphics.drawEllipse(-GlobalSetting.GRID_WIDTH / 2, - GlobalSetting.GRID_HEIGHT / 2, GlobalSetting.GRID_WIDTH, GlobalSetting.GRID_HEIGHT);
			}
			addChildAt(select, 0);
		}
		
		public function hideSelect():void {
			var select:Shape = getChildByName("select") as Shape;
			if (select != null) {
				removeChild(select);
			}
		}
		
		override public function dispose():void {
			super.dispose();
			mBMPLoader.dispose();
		}
	}
}