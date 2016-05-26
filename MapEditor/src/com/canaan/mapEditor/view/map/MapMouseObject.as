package com.canaan.mapEditor.view.map
{
	import com.canaan.lib.display.BaseSprite;
	import com.canaan.lib.role.constants.TypeRoleDirection;
	import com.canaan.mapEditor.contants.TypeRoleAction;
	import com.canaan.mapEditor.models.vo.table.UnitTempleConfigVo;
	
	import flash.display.Shape;
	
	public class MapMouseObject extends BaseSprite
	{
		private var _unitConfig:UnitTempleConfigVo;
		
		private var mBMPLoader:BMPActionLoader;
		private var mShape:Shape;
		
		public function MapMouseObject()
		{
			super();
			initialize();
		}
		
		private function initialize():void {
			mouseEnabled = false;
			mouseChildren = false;
			mBMPLoader = new BMPActionLoader();
			addChild(mBMPLoader);
			
			mShape = new Shape();
			mShape.graphics.beginFill(0x00ff00);
			mShape.graphics.drawCircle(0, 0, 5);
			mShape.graphics.endFill();
			addChild(mShape);
		}

		public function get unitConfig():UnitTempleConfigVo
		{
			return _unitConfig;
		}

		public function set unitConfig(value:UnitTempleConfigVo):void
		{
			_unitConfig = value;
			mBMPLoader.setAction(_unitConfig.model, _unitConfig.roleResConfig.type, TypeRoleAction.IDLE, TypeRoleDirection.DOWN);
			mBMPLoader.play();
		}

		override public function dispose():void {
			super.dispose();
			mBMPLoader.dispose();
		}
	}
}