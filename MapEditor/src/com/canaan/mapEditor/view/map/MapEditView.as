package com.canaan.mapEditor.view.map
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.events.KeyEvent;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.managers.KeyboardManager;
	import com.canaan.lib.utils.ArrayUtil;
	import com.canaan.mapEditor.contants.GlobalSetting;
	import com.canaan.mapEditor.events.GlobalEvent;
	import com.canaan.mapEditor.models.GameModels;
	import com.canaan.mapEditor.models.contants.TypeMapMode;
	import com.canaan.mapEditor.models.contants.TypeObjectTree;
	import com.canaan.mapEditor.models.contants.TypeResLibTree;
	import com.canaan.mapEditor.models.contants.TypeUnit;
	import com.canaan.mapEditor.models.events.ModelUnitEvent;
	import com.canaan.mapEditor.models.vo.data.MapAreaVo;
	import com.canaan.mapEditor.models.vo.data.MapDataVo;
	import com.canaan.mapEditor.models.vo.data.MapUnitVo;
	import com.canaan.mapEditor.models.vo.table.UnitTempleConfigVo;
	import com.canaan.mapEditor.ui.map.MapEditViewUI;
	
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	public class MapEditView extends MapEditViewUI
	{
		public static var instance:MapEditView;
		
		private var mMapDataVo:MapDataVo;
		
		public function MapEditView()
		{
			super();
			instance = this;
		}
		
		override protected function onViewCreated():void {
			rdoGridType.selectHandler = new Method(onGridTypeSelect);
			tabEdit.selectHandler = new Method(onEditSelect);
			cboGridSize.selectHandler = new Method(onGridSelect);
			btnClearAll.clickHandler = new Method(onClearBlock, [0]);
			btnClearObstacle.clickHandler = new Method(onClearBlock, [1]);
			btnClearTransparent.clickHandler = new Method(onClearBlock, [2]);
			btnSetAll.clickHandler = new Method(onSetBlock, [0]);
			btnSetObstacle.clickHandler = new Method(onSetBlock, [1]);
			btnSetTransparent.clickHandler = new Method(onSetBlock, [2]);
			btnCreateArea.clickHandler = new Method(onCreateArea);
			btnSaveArea.clickHandler = new Method(onSaveArea);
			btnClearMonster.clickHandler = new Method(onClearMonster);
			btnClearNPC.clickHandler = new Method(onClearNPC);
			btnClearDecoration.clickHandler = new Method(onClearDecoration);
			
			GameModels.modelUnit.addEventListener(ModelUnitEvent.UPDATE_UNIT, onUpdateUnit);
			EventManager.getInstance().addEventListener(GlobalEvent.UPDATE_MAP_OBJECTS, onUpdateObjects);
			KeyboardManager.getInstance().addEventListener(KeyEvent.KEY_DOWN, onKeyDown);
			
			viewStackArea.selectedIndex = 0;
			onUpdateUnit();
			
			txtSet.text = GlobalSetting.BLOCK_SIZE.toString();
		}
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mMapDataVo = value as MapDataVo;
			tabEdit.selectedIndex = 1;
			onUpdateObjects();
		}
		
		private function onGridTypeSelect():void {
			MapView.instance.setMode(int(rdoGridType.selection.data));
		}
		
		private function onEditSelect(index:int):void {
			viewStack.selectedIndex = tabEdit.selectedIndex;
			switch (viewStack.selectedIndex) {
				case 0:
					onGridTypeSelect();
					break;
				case 1:
					if (MapView.instance.getMode() == TypeMapMode.SET_AREA) {
						return;
					}
					MapView.instance.setMode(TypeMapMode.SELECT);
					break;
			}
		}
		
		private function onGridSelect(index:int):void {
			MapView.instance.setMouseSize(int(cboGridSize.selectedLabel));
		}
		
		private function onClearBlock(blockType:int):void {
			mMapDataVo.createBlocks(blockType);
			MapView.instance.redrawBlocks();
		}
		
		private function onSetBlock(blockType:int):void {
			var rows:int = mMapDataVo.blocks.length;
			var cols:int = mMapDataVo.blocks[0].length;
			var size:int = int(txtSet.text);
			if (size > 0) {
				for (var i:int = 0; i < mMapDataVo.rowCount; i++) {
					for (var j:int = 0; j < mMapDataVo.colCount; j++) {
						if (i < size || i >= rows - size || j < size || j >= cols - size) {
							mMapDataVo.blocks[i][j] = blockType;
						}
					}
				}
				MapView.instance.redrawBlocks();
			}
		}
		
		private function onCreateArea():void {
			MapView.instance.setMode(TypeMapMode.SET_AREA);
			viewStackArea.selectedIndex = 1;
		}
		
		private function onSaveArea():void {
			MapView.instance.saveAreas();
		}
		
		private function onClearMonster():void {
			MapView.instance.clearUnitsByTypes([TypeUnit.MONSTER]);
		}
		
		private function onClearNPC():void {
			MapView.instance.clearUnitsByTypes([TypeUnit.NPC]);
		}
		
		private function onClearDecoration():void {
			MapView.instance.clearUnitsByTypes([TypeUnit.DECORATION]);
		}
		
		private function onUpdateUnit(event:ModelUnitEvent = null):void {
			var treeData:Array = [];
			var unitDict:Dictionary = GameModels.modelUnit.unitDict;
			
			for (var unitType:int in unitDict) {
				var typeData:Object = {};
				typeData.data = unitType;
				typeData.type = TypeResLibTree.TYPE_DIC;
				typeData.children = [];
				treeData.push(typeData);
				var editDict:Dictionary = unitDict[unitType];
				for (var editName:String in editDict) {
					var editData:Object = {};
					editData.data = editName;
					editData.type = TypeResLibTree.EDIT_DIC;
					editData.children = [];
					typeData.children.push(editData);
					var units:Array = editDict[editName];
					for each (var unitConfig:UnitTempleConfigVo in units) {
						var unitData:Object = {};
						unitData.data = unitConfig;
						unitData.type = TypeResLibTree.UNIT;
						editData.children.push(unitData);
					}
				}
				typeData.children.sortOn("data");
			}
			
			treeResLib.array = treeData;
		}
		
		private function onUpdateObjects(event:GlobalEvent = null):void {
			var treeData:Array = [];
			
			// 区域
			var areaFolder:Object = {};
			areaFolder.data = "区域";
			areaFolder.type = TypeObjectTree.TYPE_FOLDER;
			areaFolder.children = [];
			treeData.push(areaFolder);
			for each (var areaVo:MapAreaVo in mMapDataVo.areas) {
				var areaData:Object = {};
				areaData.data = areaVo;
				areaData.type = TypeObjectTree.AREA;
				areaFolder.children.push(areaData);
			}
			// NPC
			var npcFolder:Object = {};
			npcFolder.data = "NPC";
			npcFolder.type = TypeObjectTree.TYPE_FOLDER;
			npcFolder.children = [];
			treeData.push(npcFolder);
			var npcs:Array = mMapDataVo.getUnitsByType(TypeUnit.NPC);
			for each (var npcVo:MapUnitVo in npcs) {
//				var npcTypeFolder:Object = ArrayUtil.find(npcFolder.children, "data", npcVo.unitConfig);
//				if (npcTypeFolder == null) {
//					npcTypeFolder = {};
//					npcTypeFolder.data = npcVo.unitConfig;
//					npcTypeFolder.type = TypeObjectTree.UNIT_FOLDER;
//					npcTypeFolder.children = [];
//					npcFolder.children.push(npcTypeFolder);
//				}
				var npcData:Object = {};
				npcData.data = npcVo;
				npcData.type = TypeObjectTree.UNIT;
				npcFolder.children.push(npcData);
			}
			// 怪物
			var monsterFolder:Object = {};
			monsterFolder.data = "怪物";
			monsterFolder.type = TypeObjectTree.TYPE_FOLDER;
			monsterFolder.children = [];
			treeData.push(monsterFolder);
			var monsters:Array = mMapDataVo.getUnitsByType(TypeUnit.MONSTER);
			for each (var monsterVo:MapUnitVo in monsters) {
				var monsterTypeFolder:Object = ArrayUtil.find(monsterFolder.children, "data", monsterVo.unitConfig);
				if (monsterTypeFolder == null) {
					monsterTypeFolder = {};
					monsterTypeFolder.data = monsterVo.unitConfig;
					monsterTypeFolder.type = TypeObjectTree.UNIT_FOLDER;
					monsterTypeFolder.children = [];
					monsterFolder.children.push(monsterTypeFolder);
				}
				var monsterData:Object = {};
				monsterData.data = monsterVo;
				monsterData.type = TypeObjectTree.UNIT;
				monsterTypeFolder.children.push(monsterData);
			}
			// 怪物
			var decorationFolder:Object = {};
			decorationFolder.data = "场景装饰";
			decorationFolder.type = TypeObjectTree.TYPE_FOLDER;
			decorationFolder.children = [];
			treeData.push(decorationFolder);
			for each (var decorationVo:MapUnitVo in mMapDataVo.decorations) {
				var decorationTypeFolder:Object = ArrayUtil.find(decorationFolder.children, "data", decorationVo.unitConfig);
				if (decorationTypeFolder == null) {
					decorationTypeFolder = {};
					decorationTypeFolder.data = decorationVo.unitConfig;
					decorationTypeFolder.type = TypeObjectTree.UNIT_FOLDER;
					decorationTypeFolder.children = [];
					decorationFolder.children.push(decorationTypeFolder);
				}
				var decorationData:Object = {};
				decorationData.data = decorationVo;
				decorationData.type = TypeObjectTree.UNIT;
				decorationTypeFolder.children.push(decorationData);
			}
			
			treeObjects.array = treeData;
			
			treeObjects.expandAll();
		}
		
		private function onKeyDown(event:KeyEvent):void {
			if (tabEdit.selectedIndex != 0) {
				return;
			}
			switch (event.keyCode) {
				case Keyboard.NUMBER_1:
					rdoGridType.selectedIndex = 0;
					break;
				case Keyboard.NUMBER_2:
					rdoGridType.selectedIndex = 1;
					break;
				case Keyboard.NUMBER_3:
					rdoGridType.selectedIndex = 2;
					break;
				case Keyboard.PAGE_UP:
					if (cboGridSize.selectedIndex > 0) {
						cboGridSize.selectedIndex--;
					}
					break;
				case Keyboard.PAGE_DOWN:
					if (cboGridSize.selectedIndex < cboGridSize.list.length - 1) {
						cboGridSize.selectedIndex++;
					}
					break;
			}
		}
	}
}