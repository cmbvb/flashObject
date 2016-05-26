package com.canaan.mapEditor.view.map
{
	import com.canaan.mapEditor.models.contants.TypeMapMode;
	import com.canaan.mapEditor.models.contants.TypeResLibTree;
	import com.canaan.mapEditor.models.contants.TypeUnit;
	import com.canaan.mapEditor.models.vo.table.UnitTempleConfigVo;
	import com.canaan.mapEditor.ui.map.MapResLibTreeItemUI;
	
	import flash.events.MouseEvent;
	
	public class MapResLibTreeItem extends MapResLibTreeItemUI
	{
		private var mTreeData:Object;
		private var mData:Object;
		private var mType:int;
		private var mUnitConfig:UnitTempleConfigVo;
		
		public function MapResLibTreeItem()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mTreeData = value;
			mData = mTreeData.data;
			mType = mTreeData.type;
			switch (mType) {
				case TypeResLibTree.TYPE_DIC:
					lblName.text = TypeUnit.TYPE_NAME[mData];
					imgFolder.url = "png.comp.img_folder";
					break;
				case TypeResLibTree.EDIT_DIC:
					lblName.text = mData.toString();
					imgFolder.url = "png.comp.img_folder";
					break;
				case TypeResLibTree.UNIT:
					mUnitConfig = mData as UnitTempleConfigVo;
					lblName.text = mUnitConfig.showText;
					imgFolder.url = "png.comp.img_file";
					break;
			}
		}
		
		private function onClick(event:MouseEvent):void {
			if (mUnitConfig) {
				MapView.instance.setMode(TypeMapMode.PLACE_OBJECT, mUnitConfig);
			}
		}
	}
}