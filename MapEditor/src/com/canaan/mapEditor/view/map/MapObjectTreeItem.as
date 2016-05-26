package com.canaan.mapEditor.view.map
{
	import com.canaan.lib.managers.DoubleClickManager;
	import com.canaan.mapEditor.models.contants.TypeObjectTree;
	import com.canaan.mapEditor.models.vo.data.MapAreaVo;
	import com.canaan.mapEditor.models.vo.data.MapUnitVo;
	import com.canaan.mapEditor.models.vo.table.UnitTempleConfigVo;
	import com.canaan.mapEditor.ui.map.MapObjectTreeItemUI;
	
	public class MapObjectTreeItem extends MapObjectTreeItemUI
	{
		private var mTreeData:Object;
		private var mData:Object;
		private var mType:int;
		private var mUnitConfig:UnitTempleConfigVo;
		private var mAreaVo:MapAreaVo;
		private var mUnitVo:MapUnitVo;
		
		public function MapObjectTreeItem()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			DoubleClickManager.getInstance().register(this, onDoubleClick);
		}
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mTreeData = value;
			mData = mTreeData.data;
			mType = mTreeData.type;
			switch (mType) {
				case TypeObjectTree.TYPE_FOLDER:
					lblName.text = mData.toString();
					imgFolder.url = "png.comp.img_folder";
					break;
				case TypeObjectTree.AREA:
					mAreaVo = mData as MapAreaVo;
					lblName.text = mAreaVo.name;
					imgFolder.url = "png.comp.img_file";
					break;
				case TypeObjectTree.UNIT_FOLDER:
					mUnitConfig = mData as UnitTempleConfigVo;
					lblName.text = mUnitConfig.showText;
					imgFolder.url = "png.comp.img_folder";
					break;
				case TypeObjectTree.UNIT:
					mUnitVo = mData as MapUnitVo;
					lblName.text = mUnitVo.unitConfig.showText;
					imgFolder.url = "png.comp.img_file";
					break;
			}
		}
		
		private function onDoubleClick():void {
			if (mAreaVo != null) {
				MapView.instance.setSelectArea(mAreaVo, true);
			} else if (mUnitVo != null) {
				MapView.instance.setSelectUnit(mUnitVo, true);
			}
		}
	}
}