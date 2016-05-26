package com.canaan.mapEditor.view.map
{
	import com.canaan.lib.animation.Transitions;
	import com.canaan.lib.animation.Tween;
	import com.canaan.lib.component.controls.Image;
	import com.canaan.lib.component.controls.Label;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.display.BaseSprite;
	import com.canaan.lib.events.KeyEvent;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.managers.KeyboardManager;
	import com.canaan.lib.managers.StageManager;
	import com.canaan.lib.managers.TimerManager;
	import com.canaan.lib.role.constants.TypeRoleDirection;
	import com.canaan.lib.utils.ArrayUtil;
	import com.canaan.lib.utils.DisplayUtil;
	import com.canaan.mapEditor.contants.GlobalSetting;
	import com.canaan.mapEditor.events.GlobalEvent;
	import com.canaan.mapEditor.models.contants.TypeMapBlock;
	import com.canaan.mapEditor.models.contants.TypeMapMode;
	import com.canaan.mapEditor.models.contants.TypeUnit;
	import com.canaan.mapEditor.models.vo.data.MapAreaVo;
	import com.canaan.mapEditor.models.vo.data.MapDataVo;
	import com.canaan.mapEditor.models.vo.data.MapUnitVo;
	import com.canaan.mapEditor.models.vo.table.UnitTempleConfigVo;
	import com.canaan.mapEditor.ui.map.MapViewUI;
	import com.canaan.mapEditor.view.common.Alert;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	
	public class MapView extends MapViewUI
	{
		public static var instance:MapView;
		
		private var mMapDataVo:MapDataVo;
		private var mAreas:Array = [];
		private var mAllUnits:Array = [];
		private var mObjects:Array = [];
		private var mDecorations:Array = [];
		private var mMapWidth:Number;
		private var mMapHeight:Number;
		private var mScrollRect:Rectangle;
		private var mCurrentPos:Point;
		private var mContainerMap:BaseSprite;
		private var mContainerUnit:BaseSprite;
		private var mContainerMouse:BaseSprite;
		private var mImgMap:Image;
		private var mGrid:Shape;
		private var mContainerBlocks:Bitmap;
		private var mBmpdBlocks:BitmapData;
		private var mContainerAreas:BaseSprite;
		private var mContainerObjects:BaseSprite;
		private var mContainerDecorations:BaseSprite;
		private var mIsCtrl:Boolean = false;
		private var mRightDown:Boolean = false;
		private var mMousePos:Point;
		private var mSelectAreaVo:MapAreaVo;
		private var mSelectUnitVo:MapUnitVo;
		private var mSelectArea:MapArea;
		private var mSelectObject:MapObject;
		private var mMouseSelect:MouseSelectView;
		private var mSelectList:Array = [];
		private var mMode:int;
		private var mMouseSize:int = 1;
		private var mMouseTrueSize:int = 0;
		private var mData:Object;
		private var mMouseObject:MapMouseObject;
		private var mMouseGrid:MapMouseGrid;
		private var mMouseArea:MapMouseArea;
		private var mMouseDown:Boolean;
		private var mDrawArea:MapDrawArea;
		private var mEditArea:MapAreaVo;
		private var mAreaEditMode:Boolean;
		private var mLblMousePos:Label;
		
		public function MapView()
		{
			super();
			instance = this;
		}
		
		override protected function onViewCreated():void {
			doubleClickEnabled = true;
			mContainerMap = new BaseSprite();
			mContainerMap.doubleClickEnabled = true;
			addChild(mContainerMap);
			mContainerUnit = new BaseSprite();
			mContainerUnit.doubleClickEnabled = true;
			mContainerMap.addChild(mContainerUnit);
			mContainerMouse = new BaseSprite();
			mContainerMap.addChild(mContainerMouse);
			mImgMap = new Image();
			mContainerUnit.addChild(mImgMap);
			mContainerBlocks = new Bitmap();
//			mContainerBlocks.cacheAsBitmap = true;
			mContainerUnit.addChild(mContainerBlocks);
			mGrid = new Shape();
			mGrid.cacheAsBitmap = true;
			mContainerUnit.addChild(mGrid);
			mContainerAreas = new BaseSprite();
			mContainerUnit.addChild(mContainerAreas);
			mContainerDecorations = new BaseSprite();
			mContainerUnit.addChild(mContainerDecorations);
			mContainerObjects = new BaseSprite();
			mContainerUnit.addChild(mContainerObjects);
			
			mLblMousePos = new Label();
			mLblMousePos.color = 0xffffff;
			mLblMousePos.mouseEnabled = false;
			mLblMousePos.mouseChildren = false;
			mLblMousePos.width = 100;
			mLblMousePos.height = 20;
			mLblMousePos.align = TextFormatAlign.CENTER;
			addChild(mLblMousePos);
			
			mMouseSelect = new MouseSelectView(this);
			addChild(mMouseSelect);
			
			mCurrentPos = new Point();
			mScrollRect = new Rectangle();
			vscroll.target = this;
			vscroll.addEventListener(Event.CHANGE, onVChange);
			hscroll.addEventListener(Event.CHANGE, onHChange);
			
			KeyboardManager.getInstance().addEventListener(KeyEvent.KEY_DOWN, onKeyDown);
			KeyboardManager.getInstance().addEventListener(KeyEvent.KEY_UP, onKeyUp);
			mContainerMap.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			mContainerMap.addEventListener(MouseEvent.MOUSE_DOWN, onMapMouseDown);
			mContainerMap.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onMapRightMouseDown);
			StageManager.getInstance().stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onMapRightMouseUp);
			StageManager.getInstance().registerHandler(Event.DEACTIVATE, onDeactive);
			EventManager.getInstance().addEventListener(GlobalEvent.ON_MOUSE_SELECT, onMouseSelect);
			EventManager.getInstance().addEventListener(GlobalEvent.UPDATE_MAP_OBJECT, onUpdateMapObject);
			
			hideGrid();
		}
		
		private function onMouseMove(event:MouseEvent):void {
			var mapX:int = int(mContainerMap.mouseX / GlobalSetting.GRID_WIDTH);
			var mapY:int = int(mContainerMap.mouseY / GlobalSetting.GRID_HEIGHT);
			mLblMousePos.text = "x:" + mapX + " y:" + mapY;
		}
		
		private function onUpdateMapObject(event:GlobalEvent):void {
			var mapUnitVo:MapUnitVo = event.data as MapUnitVo;
			var mapObject:MapObject = ArrayUtil.find(mAllUnits, "mapUnitVo", mapUnitVo);
			if (mapObject != null) {
				mapObject.refreshObject();
			}
		}
		
		public function setViewSize(width:Number, height:Number):void {
			mMapWidth = width - vscroll.width;;
			mMapHeight = height - hscroll.height;
			vscroll.moveTo(width - vscroll.width, 0);
			hscroll.moveTo(0, height - hscroll.height);
			mLblMousePos.moveTo((width - mLblMousePos.width) / 2, 20);
			resetScroll();
			drawGrid();
			updateMapPos();
			EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.UPDATE_MAP_SIZE));
		}
		
		private function drawGrid():void {
			var row:int = Math.ceil(mMapHeight / GlobalSetting.GRID_HEIGHT);
			var col:int = Math.ceil(mMapWidth / GlobalSetting.GRID_WIDTH);
			mGrid.graphics.clear();
			mGrid.graphics.lineStyle(1, 0xffffff);
			for (var i:int = 0; i <= col; i++) {
				mGrid.graphics.moveTo(i * GlobalSetting.GRID_WIDTH, 0);
				mGrid.graphics.lineTo(i * GlobalSetting.GRID_WIDTH, row * GlobalSetting.GRID_HEIGHT);
			}
			for (var j:int = 0; j <= row; j++) {
				mGrid.graphics.moveTo(0, j * GlobalSetting.GRID_HEIGHT);
				mGrid.graphics.lineTo(col * GlobalSetting.GRID_WIDTH, j * GlobalSetting.GRID_HEIGHT);
			}
		}
		
		public function showMap(mapDataVo:MapDataVo):void {
			MapEditor.intance.disable();
			mMapDataVo = mapDataVo;
			vscroll.value = 0;
			hscroll.value = 0;
			resetScroll();
			mImgMap.bitmapData = mapDataVo.bitmapData;
			clearBlocks();
			showBlocks();
			clearAreas();
			showAreas();
			clearObjects();
			updateMapPos();
			setMode(TypeMapMode.SELECT);
			EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.UPDATE_MAP_SIZE));
			TimerManager.getInstance().doFrameOnce(1, delayShowMapDetail);
		}
		
		private function delayShowMapDetail():void {
			showObjects();
			MapEditor.intance.enable();
		}
		
		private function resetScroll():void {
			if (mMapDataVo != null) {
				vscroll.height = mMapHeight;
				hscroll.width = mMapWidth;
				vscroll.setScroll(0, mMapDataVo.mapGridHeight - mMapHeight, vscroll.value);
				hscroll.setScroll(0, mMapDataVo.mapGridWidth - mMapWidth, hscroll.value);
				vscroll.scrollSize = GlobalSetting.GRID_HEIGHT;
				hscroll.scrollSize = GlobalSetting.GRID_WIDTH;
				vscroll.thumbPercent = mMapHeight / mMapDataVo.mapGridHeight;
				hscroll.thumbPercent = mMapWidth / mMapDataVo.mapGridWidth;
			}
		}
		
		private function showBlocks():void {
			mBmpdBlocks = new BitmapData(mMapDataVo.mapWidth, mMapDataVo.mapHeight, true, 0);
			mContainerBlocks.bitmapData = mBmpdBlocks;
			var rows:int = mMapDataVo.blocks.length;
			var cols:int = mMapDataVo.blocks[0].length;
			for (var i:int = 0; i < rows; i++) {
				for (var j:int = 0; j < cols; j++) {
					var type:int = mMapDataVo.blocks[i][j];
					var x:int = j * GlobalSetting.GRID_WIDTH;
					var y:int = i * GlobalSetting.GRID_HEIGHT;
					mBmpdBlocks.fillRect(new Rectangle(x, y, GlobalSetting.GRID_WIDTH, GlobalSetting.GRID_HEIGHT), GlobalSetting.BLOCK_COLOR_DICT[type]);
				}
			}
		}
		
		private function clearBlocks():void {
			if (mBmpdBlocks != null) {
				mBmpdBlocks.dispose();
			}
		}
		
		public function redrawBlocks():void {
			var rows:int = mMapDataVo.blocks.length;
			var cols:int = mMapDataVo.blocks[0].length;
			for (var i:int = 0; i < rows; i++) {
				for (var j:int = 0; j < cols; j++) {
					var type:int = mMapDataVo.blocks[i][j];
					var x:int = j * GlobalSetting.GRID_WIDTH;
					var y:int = i * GlobalSetting.GRID_HEIGHT;
					mBmpdBlocks.fillRect(new Rectangle(x, y, GlobalSetting.GRID_WIDTH, GlobalSetting.GRID_HEIGHT), GlobalSetting.BLOCK_COLOR_DICT[type]);
				}
			}
		}
		
		private function showAreas():void {
			for each (var mapAreaVo:MapAreaVo in mMapDataVo.areas) {
				addArea(mapAreaVo);
			}
		}
		
		private function addArea(areaVo:MapAreaVo):void {
			var mapArea:MapArea = new MapArea();
			mapArea.doubleClickEnabled = true;
			mapArea.mapAreaVo = areaVo;
			mAreas.push(mapArea);
			addMapAreaEvent(mapArea);
			mContainerAreas.addChild(mapArea);
		}
		
		private function getArea(areaVo:MapAreaVo):MapArea {
			return ArrayUtil.find(mAreas, "mapAreaVo", areaVo);
		}
		
		private function addMapAreaEvent(mapArea:MapArea):void {
			mapArea.addEventListener(MouseEvent.MOUSE_DOWN, onMapAreaMouseDown);
			mapArea.addEventListener(MouseEvent.DOUBLE_CLICK, onMapAreaDoubleClick);
		}
		
		private function onMapAreaMouseDown(event:MouseEvent):void {
			if (mMode == TypeMapMode.SELECT) {
				var mapArea:MapArea = event.currentTarget as MapArea;
				setSelectArea(mapArea.mapAreaVo);
				event.stopPropagation();
			}
		}
		
		private function onMapAreaDoubleClick(event:MouseEvent):void {
			var mapArea:MapArea = event.currentTarget as MapArea;
			if (mMode == TypeMapMode.SELECT) {
				setMode(TypeMapMode.SET_AREA, mapArea.mapAreaVo);
			}
		}
		
		private function clearAreas():void {
			mAreas.length = 0;
			mContainerAreas.removeAllChildren(true);
		}
		
		private function clearObjects():void {
			mAllUnits.length = 0;
			mObjects.length = 0;
			mDecorations.length = 0;
			mContainerObjects.removeAllChildren(true);
			mContainerDecorations.removeAllChildren(true);
			TimerManager.getInstance().clear(sortObjects);
		}
		
		private function showObjects():void {
			// 对象
			for each (var unitVo:MapUnitVo in mMapDataVo.units) {
				addObject(unitVo);
			}
			// 装饰
			for each (var decorationVo:MapUnitVo in mMapDataVo.decorations) {
				addObject(decorationVo);
			}
			TimerManager.getInstance().doLoop(100, sortObjects);
		}
		
		private function addObject(unitVo:MapUnitVo):void {
			var mapObject:MapObject = new MapObject();
			mapObject.mapUnitVo = unitVo;
			addMapObjectEvent(mapObject);
			mAllUnits.push(mapObject);
			if (unitVo.unitConfig.type == TypeUnit.DECORATION) {
				mDecorations.push(mapObject);
				mContainerDecorations.addChild(mapObject);
			} else {
				mObjects.push(mapObject);
				mContainerObjects.addChild(mapObject);
			}
		}
		
		private function sortObjects():void {
			mObjects.sort(objectsSortFunc);
			mDecorations.sort(objectsSortFunc);
			var object:MapObject;
			for (var i:int = 0; i < mObjects.length; i++) {
				object = mObjects[i];
				mContainerObjects.setChildIndex(object, i);
			}
			for (var j:int = 0; j < mDecorations.length; j++) {
				object = mDecorations[j];
				mContainerDecorations.setChildIndex(object, j);
			}
		}
		
		private function objectsSortFunc(objectA:MapObject, objectB:MapObject):int {
			if (objectA.y == objectB.y) {
				return objectA.x > objectB.x ? 1 : -1;
			}
			return objectA.y > objectB.y ? 1 : -1;
		}
		
		private function addMapObjectEvent(mapObject:MapObject):void {
			mapObject.addEventListener(MouseEvent.MOUSE_DOWN, onMapObjectMouseDown);
		}
		
		private function onMapObjectMouseDown(event:MouseEvent):void {
			if (mMode == TypeMapMode.SELECT) {
				var mapObject:MapObject = event.currentTarget as MapObject;
				setSelectUnit(mapObject.mapUnitVo);
				StageManager.getInstance().stage.addEventListener(MouseEvent.MOUSE_MOVE, onObjectMouseMove);
				StageManager.getInstance().stage.addEventListener(MouseEvent.MOUSE_UP, onObjectMouseUp);
				event.stopPropagation();
			}
		}
		
		private function onObjectMouseMove(event:MouseEvent):void {
			var mapX:int = int(mContainerMap.mouseX / GlobalSetting.GRID_WIDTH);
			var mapY:int = int(mContainerMap.mouseY / GlobalSetting.GRID_HEIGHT);
			mSelectUnitVo.mapX = mapX;
			mSelectUnitVo.mapY = mapY;
			mSelectObject.refreshPos();
			EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.UPDATE_UNIT_POS, mSelectUnitVo));
		}
		
		private function onObjectMouseUp(event:MouseEvent):void {
			StageManager.getInstance().stage.removeEventListener(MouseEvent.MOUSE_MOVE, onObjectMouseMove);
			StageManager.getInstance().stage.removeEventListener(MouseEvent.MOUSE_UP, onObjectMouseUp);
		}
		
		private function removeArea(mapArea:MapArea):void {
			ArrayUtil.removeElements(mAreas, mapArea);
			mapArea.mapAreaVo.remove();
			mapArea.remove(true);
		}
		
		private function removeObject(mapObject:MapObject):void {
			if (mSelectObject == mapObject) {
				clearSelectUnit();
			}
			ArrayUtil.removeElements(mAllUnits, mapObject);
			ArrayUtil.removeElements(mObjects, mapObject);
			ArrayUtil.removeElements(mDecorations, mapObject);
			mapObject.mapUnitVo.remove();
			mapObject.remove(true);
		}
		
		private function getAreaByAreaVo(areaVo:MapAreaVo):MapArea {
			return ArrayUtil.find(mAreas, "mapAreaVo", areaVo);
		}
		
		private function getObjectByUnitVo(unitVo:MapUnitVo):MapObject {
			return ArrayUtil.find(mAllUnits, "mapUnitVo", unitVo);
		}

		private function get isGridMode():Boolean {
			return mMode == TypeMapMode.SET_NORMAL || mMode == TypeMapMode.SET_ALPHA || mMode == TypeMapMode.SET_OBSTACLE;
		}
		
		public function onEsc():void {
			MapView.instance.setMode(TypeMapMode.SELECT);
		}
		
		public function showGrid():void {
			mGrid.visible = true;
		}
		
		public function hideGrid():void {
			mGrid.visible = false;
		}
		
		public function showObjectInfo():void {
			if (mSelectAreaVo != null || mSelectUnitVo != null) {
				MapAttrView.instance.visible = !MapAttrView.instance.visible;
			}
		}
		
		public function hideObjectInfo():void {
			MapAttrView.instance.visible = false;
		}
		
		public function showObjectLayer():void {
			mContainerObjects.visible = true;
			mContainerDecorations.visible = true;
		}
		
		public function hideObjectLayer():void {
			mContainerObjects.visible = false;
			mContainerDecorations.visible = false;
		}
		
		public function showAreaLayer():void {
			mContainerAreas.visible = true;
		}
		
		public function hideAreaLayer():void {
			mContainerAreas.visible = false;
		}
		
		public function showBlockLayer():void {
			mContainerBlocks.visible = true;
		}
		
		public function hideBlockLayer():void {
			mContainerBlocks.visible = false;
		}
		
		public function moveMapTo(x:Number, y:Number):void {
			mCurrentPos.x = x;
			mCurrentPos.y = y;
			updateMapPos();
			EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.UPDATE_MAP_POS));
		}
		
		public function moveMapOffset(x:Number, y:Number):void {
			mCurrentPos.x += x;
			mCurrentPos.y += y;
			updateMapPos();
			EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.UPDATE_MAP_POS));
		}
		
		public function moveMapToCenter(x:Number, y:Number):void {
			mCurrentPos.x = x - mMapWidth / 2;
			mCurrentPos.y = y - mMapHeight / 2;
			updateMapPos();
			EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.UPDATE_MAP_POS));
		}
		
		public function moveMapToCenterTween(x:Number, y:Number):void {
			var tx:Number = Math.min(Math.max(x - mMapWidth / 2, 0), mMapDataVo.mapGridWidth - mMapWidth);
			var ty:Number = Math.min(Math.max(y - mMapHeight / 2, 0), mMapDataVo.mapGridHeight - mMapHeight);
			var originalPos:Point = mCurrentPos.clone();
			var tween:Tween = Tween.fromPool(this, 500, Transitions.EASE_OUT);
			tween.onUpdate = function():void {
				var xx:Number = originalPos.x + (tx - originalPos.x) * tween.transitionValue;
				var yy:Number = originalPos.y + (ty - originalPos.y) * tween.transitionValue;
				moveMapTo(xx, yy);
			};
			tween.start();
		}
		
		private function updateMapPos():void {
			if (mMapDataVo != null) {
				mCurrentPos.x = Math.min(Math.max(mCurrentPos.x, 0), mMapDataVo.mapGridWidth - mMapWidth);
				mCurrentPos.y = Math.min(Math.max(mCurrentPos.y, 0), mMapDataVo.mapGridHeight - mMapHeight);
				mScrollRect.setTo(mCurrentPos.x, mCurrentPos.y, mMapWidth, mMapHeight);
				mContainerMap.scrollRect = mScrollRect;
				vscroll.justSetValue(mCurrentPos.y);
				hscroll.justSetValue(mCurrentPos.x);
				mGrid.x = mCurrentPos.x - mCurrentPos.x % GlobalSetting.GRID_WIDTH;
				mGrid.y = mCurrentPos.y - mCurrentPos.y % GlobalSetting.GRID_HEIGHT;
			}
		}
		
		private function onVChange(event:Event):void {
			if (mMapDataVo != null) {
				var yy:Number = (mMapDataVo.mapGridHeight - mMapHeight) * vscroll.value / vscroll.max;
				mCurrentPos.y = yy;
				moveMapTo(mCurrentPos.x, yy);
			}
		}
		
		private function onHChange(event:Event):void {
			if (mMapDataVo != null) {
				var xx:Number = (mMapDataVo.mapGridWidth - mMapWidth) * hscroll.value / hscroll.max;
				moveMapTo(xx, mCurrentPos.y);
			}
		}
		
		public function setSelectArea(mapAreaVo:MapAreaVo, moveMap:Boolean = false):void {
			clearSelectUnit();
			clearSelectList();
			mSelectAreaVo = mapAreaVo;
			MapAttrView.instance.showArea(mSelectAreaVo);
			mSelectArea = getAreaByAreaVo(mSelectAreaVo);
			if (mSelectAreaVo != null) {
				for each (var area:MapArea in mAreas) {
					if (area == mSelectArea) {
						area.showSelect();
					} else {
						area.hideSelect();
					}
				}
			}
			if (moveMap) {
				var areaPos:Point = mSelectAreaVo.getAreaPos();
				if (areaPos != null) {
					moveMapToCenterTween(areaPos.x, areaPos.y);
				}
			}
		}
		
		private function clearSelectArea():void {
			mSelectAreaVo = null;
			if (mSelectArea != null) {
				mSelectArea.hideSelect();
			}
			mSelectArea = null;
		}
		
		public function setSelectUnit(mapUnitVo:MapUnitVo, moveMap:Boolean = false):void {
			clearSelectArea();
			clearSelectList();
			mSelectUnitVo = mapUnitVo;
			MapAttrView.instance.showUnit(mSelectUnitVo);
			mSelectObject = getObjectByUnitVo(mSelectUnitVo);
			if (mSelectObject != null) {
				for each (var obj:MapObject in mAllUnits) {
					if (obj == mSelectObject) {
						obj.showSelect();
					} else {
						obj.hideSelect();
					}
				}
			}
			if (moveMap) {
				moveMapToCenterTween(mapUnitVo.realX, mapUnitVo.realY);
			}
		}
		
		private function clearSelectUnit():void {
			mSelectUnitVo = null;
			if (mSelectObject != null) {
				mSelectObject.hideSelect();
			}
			mSelectObject = null;
		}
		
		private function clearSelectList():void {
			for each (var mapObject:MapObject in mSelectList) {
				mapObject.hideSelect();
			}
			mSelectList.length = 0;
		}
		
		public function clearUnitsByTypes(types:Array):void {
			var mapObjects:Array = [];
			var mapObject:MapObject;
			for each (mapObject in mAllUnits) {
				if (types.indexOf(mapObject.mapUnitVo.type) != -1) {
					mapObjects.push(mapObject);
				}
			}
			for each (mapObject in mapObjects) {
				removeObject(mapObject);
			}
			EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.UPDATE_MAP_OBJECTS));
		}
		
		public function clearSelect():void {
			clearSelectArea();
			clearSelectUnit();
			clearSelectList();
			MapAttrView.instance.visible = false;
		}
		
		public function getMode():int {
			return mMode;
		}
		
		public function setMode(mode:int, value:Object = null):void {
			mMode = mode;
			mData = value;
			
			mMouseDown = false;
			mContainerUnit.transform.colorTransform = new ColorTransform();
			clearSelect();
			removeMouseObject();
			removeMouseGrid();
			removeMouseArea();
			removeDrawArea();
			StageManager.getInstance().stage.removeEventListener(MouseEvent.MOUSE_MOVE, onPlaceObjectMouseMove);
			mContainerMap.removeEventListener(MouseEvent.MOUSE_DOWN, onPlaceObjectMouseDown);
			mContainerMap.removeEventListener(MouseEvent.MOUSE_UP, onPlaceObjectMouseUp);
			
			var objectRealPos:Point;
			
			switch (mMode) {
				case TypeMapMode.SELECT:
					MapEditView.instance.viewStackArea.selectedIndex = 0;
					break;
				case TypeMapMode.PLACE_OBJECT:
					objectRealPos = mouseMapObjectRealPos;
					mMouseObject = new MapMouseObject();
					mMouseObject.unitConfig = value as UnitTempleConfigVo;
					mMouseObject.moveTo(objectRealPos.x, objectRealPos.y);
					mContainerMouse.addChild(mMouseObject);
					StageManager.getInstance().stage.addEventListener(MouseEvent.MOUSE_MOVE, onPlaceObjectMouseMove);
					mContainerMap.addEventListener(MouseEvent.MOUSE_DOWN, onPlaceObjectMouseDown);
					mContainerMap.addEventListener(MouseEvent.MOUSE_UP, onPlaceObjectMouseUp);
					break;
				case TypeMapMode.SET_NORMAL:
				case TypeMapMode.SET_ALPHA:
				case TypeMapMode.SET_OBSTACLE:
					objectRealPos = mouseMapObjectRealPos;
					StageManager.getInstance().stage.addEventListener(MouseEvent.MOUSE_MOVE, onPlaceObjectMouseMove);
					mContainerMap.addEventListener(MouseEvent.MOUSE_DOWN, onPlaceObjectMouseDown);
					mContainerMap.addEventListener(MouseEvent.MOUSE_UP, onPlaceObjectMouseUp);
					mMouseGrid = new MapMouseGrid();
					mMouseGrid.setMode(mode, mMouseSize);
					mMouseGrid.moveTo(objectRealPos.x, objectRealPos.y);
					mContainerMouse.addChild(mMouseGrid);
					break;
				case TypeMapMode.SET_AREA:
					MapEditView.instance.viewStackArea.selectedIndex = 1;
					objectRealPos = mouseMapObjectRealPos;
					StageManager.getInstance().stage.addEventListener(MouseEvent.MOUSE_MOVE, onPlaceObjectMouseMove);
					mContainerMap.addEventListener(MouseEvent.MOUSE_DOWN, onPlaceObjectMouseDown);
					DisplayUtil.setBrightness(mContainerUnit, 0.5);
					mEditArea = value as MapAreaVo;
					
					var mapAreaVo:MapAreaVo = new MapAreaVo();
					if (value != null) {
						mapAreaVo.gridData = mEditArea.gridData.concat();
						mAreaEditMode = true;
					} else {
						mapAreaVo.mapDataVo = mMapDataVo;
					}
					mDrawArea = new MapDrawArea();
					mDrawArea.mapAreaVo = mapAreaVo;
					mContainerMouse.addChild(mDrawArea);
					
					mContainerMap.addEventListener(MouseEvent.MOUSE_UP, onPlaceObjectMouseUp);
					mMouseArea = new MapMouseArea();
					mMouseArea.moveTo(objectRealPos.x, objectRealPos.y);
					mContainerMouse.addChild(mMouseArea);
					break;
			}
		}
		
		public function setMouseSize(size:int):void {
			mMouseSize = size;
			mMouseTrueSize = (mMouseSize - 1) / 2;
			if (isGridMode) {
				mMouseGrid.setMode(mMode, mMouseSize);
			}
		}
		
		private function onPlaceObjectMouseMove(event:MouseEvent = null):void {
			var mapPos:Point = mouseMapPos;
			var objectRealPos:Point = mouseMapObjectRealPos;
			var mapRealPos:Point = mouseMapRealPos;
			switch (mMode) {
				case TypeMapMode.PLACE_OBJECT:
					if (mMouseObject != null) {
						mMouseObject.moveTo(objectRealPos.x, objectRealPos.y);
					}
					break;
				case TypeMapMode.SET_NORMAL:
				case TypeMapMode.SET_ALPHA:
				case TypeMapMode.SET_OBSTACLE:
					if (mMouseGrid != null) {
						mMouseGrid.moveTo(objectRealPos.x, objectRealPos.y);
					}
					if (mMouseDown) {
						var blockType:int = mIsCtrl ? TypeMapBlock.NORMAL : TypeMapMode.BLOCK_MAP[mMode];
						var startX:int = Math.min(Math.max(0, mapPos.x - mMouseTrueSize), mMapDataVo.colCount - 1);
						var startY:int = Math.min(Math.max(0, mapPos.y - mMouseTrueSize), mMapDataVo.rowCount - 1);
						var endX:int = Math.min(Math.max(0, mapPos.x + mMouseTrueSize), mMapDataVo.colCount - 1);
						var endY:int = Math.min(Math.max(0, mapPos.y + mMouseTrueSize), mMapDataVo.rowCount - 1);
						for (var i:int = startX; i <= endX; i++) {
							for (var j:int = startY; j <= endY; j++) {
								mMapDataVo.blocks[j][i] = blockType;
							}
						}
						
						var startRealX:int = startX * GlobalSetting.GRID_WIDTH;
						var startRealY:int = startY * GlobalSetting.GRID_HEIGHT;
						var realWidth:int = (endX - startX + 1) * GlobalSetting.GRID_WIDTH;
						var realHeight:int = (endY - startY + 1) * GlobalSetting.GRID_HEIGHT;
						mBmpdBlocks.fillRect(new Rectangle(startRealX, startRealY, realWidth, realHeight), GlobalSetting.BLOCK_COLOR_DICT[blockType]);
					}
					break;
				case TypeMapMode.SET_AREA:
					if (mMouseArea != null) {
						mMouseArea.moveTo(objectRealPos.x, objectRealPos.y);
					}
					if (mMouseDown) {
						if (mIsCtrl) {
							if (mDrawArea.mapAreaVo.gridData.length != 1) {
								mDrawArea.mapAreaVo.removeGrid(mapPos.x, mapPos.y);
								mDrawArea.refresh();
							}
						} else {
							if (!mDrawArea.mapAreaVo.hasGrid(mapPos.x, mapPos.y)) {
								mDrawArea.mapAreaVo.addGrid(mapPos.x, mapPos.y);
								mDrawArea.refresh();
							}
						}
					}
					break;
			}
		}
		
		private function onPlaceObjectMouseDown(event:MouseEvent):void {
			mMouseDown = true;
			
			switch (mMode) {
				case TypeMapMode.PLACE_OBJECT:
					break;
				case TypeMapMode.SET_NORMAL:
				case TypeMapMode.SET_ALPHA:
				case TypeMapMode.SET_OBSTACLE:
				case TypeMapMode.SET_AREA:
					onPlaceObjectMouseMove();
					break;
			}
		}
		
		private function onPlaceObjectMouseUp(event:MouseEvent):void {
			mMouseDown = false;
			var mapPos:Point = mouseMapPos;
			var mapRealPos:Point = mouseMapRealPos;
			switch (mMode) {
				case TypeMapMode.PLACE_OBJECT:
					var unitConfig:UnitTempleConfigVo = mData as UnitTempleConfigVo;
					var unitVo:MapUnitVo = new MapUnitVo();
					unitVo.mapDataVo = mMapDataVo;
					unitVo.unitId = unitConfig.id;
					unitVo.mapX = mapPos.x;
					unitVo.mapY = mapPos.y;
					if (unitConfig.type == TypeUnit.DECORATION) {
						mMapDataVo.decorations.push(unitVo);
					} else {
						mMapDataVo.units.push(unitVo);
					}
					addObject(unitVo);
					EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.UPDATE_MAP_OBJECTS));
					break;
				case TypeMapMode.SET_NORMAL:
				case TypeMapMode.SET_ALPHA:
				case TypeMapMode.SET_OBSTACLE:
//					var blockType:int = TypeMapMode.BLOCK_MAP[mMode];
//					mMapDataVo.blocks[mapPos.y][mapPos.x] = blockType;
//					mContainerBlocks.graphics.beginFill(0, 0);
//					mContainerBlocks.graphics.drawRect(mapRealPos.x, mapRealPos.y, GlobalSetting.GRID_WIDTH, GlobalSetting.GRID_HEIGHT);
//					mContainerBlocks.graphics.endFill();
//					mContainerBlocks.graphics.beginFill(GlobalSetting.BLOCK_COLOR_DICT[blockType], GlobalSetting.BLOCK_ALPHA_DICT[blockType]);
//					mContainerBlocks.graphics.drawRect(mapRealPos.x, mapRealPos.y, GlobalSetting.GRID_WIDTH, GlobalSetting.GRID_HEIGHT);
//					mContainerBlocks.graphics.endFill();
					break;
			}
		}
		
		private function removeMouseObject():void {
			if (mMouseObject != null) {
				if (mMouseObject.parent) {
					mMouseObject.parent.removeChild(mMouseObject);
				}
				mMouseObject.dispose();
				mMouseObject = null;
			}
		}
		
		private function removeMouseGrid():void {
			if (mMouseGrid != null) {
				if (mMouseGrid.parent) {
					mMouseGrid.parent.removeChild(mMouseGrid);
				}
				mMouseGrid.dispose();
				mMouseGrid = null;
			}
		}
		
		private function removeMouseArea():void {
			if (mMouseArea != null) {
				if (mMouseArea.parent) {
					mMouseArea.parent.removeChild(mMouseArea);
				}
				mMouseArea.dispose();
				mMouseArea = null;
			}
		}
		
		private function removeDrawArea():void {
			if (mDrawArea != null) {
				if (mDrawArea.parent) {
					mDrawArea.parent.removeChild(mDrawArea);
				}
				mDrawArea.dispose();
				mDrawArea = null;
			}
			mAreaEditMode = false;
			mEditArea = null;
		}
		
		public function saveAreas():void {
			var mapAreaVo:MapAreaVo = mDrawArea.mapAreaVo;
			if (mapAreaVo != null) {
				if (mapAreaVo.gridData.length == 0) {
					Alert.show("区域内最少包含一个格子！");
					return;
				}
				if (mAreaEditMode == false) {
					mMapDataVo.areas.push(mapAreaVo);
					addArea(mapAreaVo);
				} else {
					var mapArea:MapArea = getArea(mEditArea);
					mapArea.mapAreaVo.gridData = mapAreaVo.gridData.concat();
					mapArea.refresh();
				}
				setMode(TypeMapMode.SELECT);
				setSelectArea(mapAreaVo);
				showObjectInfo();
				EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.UPDATE_MAP_OBJECTS));
			}
		}
		
		private function onKeyDown(event:KeyEvent):void {
			switch (event.keyCode) {
				case Keyboard.LEFT:
					if (mSelectUnitVo == null) {
						hscroll.value -= GlobalSetting.GRID_WIDTH;
					} else {
						mSelectUnitVo.realX--;
						mSelectObject.refreshPos();
						EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.UPDATE_UNIT_POS, mSelectUnitVo));
					}
					break;
				case Keyboard.RIGHT:
					if (mSelectUnitVo == null) {
						hscroll.value += GlobalSetting.GRID_WIDTH;
					} else {
						mSelectUnitVo.realX++;
						mSelectObject.refreshPos();
						EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.UPDATE_UNIT_POS, mSelectUnitVo));
					}
					break;
				case Keyboard.UP:
					if (mSelectUnitVo == null) {
						vscroll.value -= GlobalSetting.GRID_HEIGHT;
					} else {
						mSelectUnitVo.realY--;
						mSelectObject.refreshPos();
						EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.UPDATE_UNIT_POS, mSelectUnitVo));
					}
					break;
				case Keyboard.DOWN:
					if (mSelectUnitVo == null) {
						vscroll.value += GlobalSetting.GRID_HEIGHT;
					} else {
						mSelectUnitVo.realY++;
						mSelectObject.refreshPos();
						EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.UPDATE_UNIT_POS, mSelectUnitVo));
					}
					break;
				case Keyboard.CONTROL:
					mIsCtrl = true;
					break;
				case Keyboard.TAB:
					if (mSelectUnitVo != null) {
						mSelectUnitVo.direction = TypeRoleDirection.getNextDirection(mSelectUnitVo.direction);
						mSelectObject.refreshObject();
					}
					break;
			}
		}
		
		private function onKeyUp(event:KeyEvent):void {
			switch (event.keyCode) {
				case Keyboard.CONTROL:
					mIsCtrl = false;
					onMapMouseUp();
					break;
				case Keyboard.DELETE:
					if (mSelectArea != null) {
						Alert.show("确定删除区域" + mSelectAreaVo.name + "？", Alert.TYPE_ACCEPT_CANCEL, new Method(function():void {
							removeArea(mSelectArea);
							clearSelectArea();
							EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.UPDATE_MAP_OBJECTS));
						}));
					} else if (mSelectObject != null) {
						Alert.show("确定删除对象" + mSelectUnitVo.unitConfig.showText + "？\n(名称：" + mSelectUnitVo.name + "，坐标：" + mSelectUnitVo.mapX + "*" + mSelectUnitVo.mapY + ")", 
							Alert.TYPE_ACCEPT_CANCEL, new Method(function():void {
							removeObject(mSelectObject);
							EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.UPDATE_MAP_OBJECTS));
						}));
						return;
					} else if (mSelectList.length != 0) {
						Alert.show("确定删除选中对象？", Alert.TYPE_ACCEPT_CANCEL, new Method(function():void {
							for each (var mapObject:MapObject in mSelectList) {
								removeObject(mapObject);
								EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.UPDATE_MAP_OBJECTS));
							}
						}));
						return;
					}
					break;
			}
		}
		
		private function onMapMouseDown(event:MouseEvent = null):void {
			switch (mMode) {
				case TypeMapMode.SELECT:
					mMousePos = new Point(StageManager.getInstance().stage.mouseX, StageManager.getInstance().stage.mouseY);
					StageManager.getInstance().stage.addEventListener(MouseEvent.MOUSE_MOVE, onMapMouseMove);
					StageManager.getInstance().stage.addEventListener(MouseEvent.MOUSE_UP, onMapMouseUp);
					mMouseSelect.show();
					clearSelect();
					break;
				case TypeMapMode.PLACE_OBJECT:
					break;
			}
		}
		
		private function onMapRightMouseDown(event:MouseEvent):void {
			mRightDown = true;
			mMousePos = new Point(StageManager.getInstance().stage.mouseX, StageManager.getInstance().stage.mouseY);
			StageManager.getInstance().stage.addEventListener(MouseEvent.MOUSE_MOVE, onMapMouseMove);
			StageManager.getInstance().stage.addEventListener(MouseEvent.MOUSE_UP, onMapMouseUp);
		}
		
		private function onMapRightMouseUp(evetn:MouseEvent = null):void {
			mRightDown = false;
			onMapMouseUp();
		}
		
		private function onMapMouseMove(event:MouseEvent):void {
			if (mIsCtrl || mRightDown) {
				moveMapOffset(-(StageManager.getInstance().stage.mouseX - mMousePos.x), -(StageManager.getInstance().stage.mouseY - mMousePos.y));
				mMousePos.setTo(StageManager.getInstance().stage.mouseX, StageManager.getInstance().stage.mouseY);
			}
		}
		
		private function onMapMouseUp(event:MouseEvent = null):void {
			StageManager.getInstance().stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMapMouseMove);
			StageManager.getInstance().stage.removeEventListener(MouseEvent.MOUSE_UP, onMapMouseUp);
		}
		
		private function onDeactive():void {
			mIsCtrl = false;
			mRightDown = false;
		}
		
		private function onMouseSelect(event:GlobalEvent):void {
			mSelectList.length = 0;
			var rect:Rectangle = event.data as Rectangle;
			rect.offset(mCurrentPos.x, mCurrentPos.y);
			for each (var mapObject:MapObject in mAllUnits) {
				var objectRect:Rectangle = new Rectangle(mapObject.x - GlobalSetting.HALF_GRID_WIDTH, mapObject.y - GlobalSetting.HALF_GRID_HEIGHT, GlobalSetting.GRID_WIDTH, GlobalSetting.GRID_HEIGHT);
				var intersectionRect:Rectangle = rect.intersection(objectRect);
				if (intersectionRect.isEmpty() == false) {
					mapObject.showSelect();
					mSelectList.push(mapObject);
				}
			}
			if (mSelectList.length == 1) {
				setSelectUnit(mSelectList[0].mapUnitVo);
			}
		}
		
		public function get mouseMapPos():Point {
			var mapX:int = int(mContainerMap.mouseX / GlobalSetting.GRID_WIDTH);
			var mapY:int = int(mContainerMap.mouseY / GlobalSetting.GRID_HEIGHT);
			mapX = Math.min(Math.max(0, mapX), mMapDataVo.colCount - 1);
			mapY = Math.min(Math.max(0, mapY), mMapDataVo.rowCount - 1);
			return new Point(mapX, mapY);
		}
		
		public function get mouseMapRealPos():Point {
			var pos:Point = mouseMapPos;
			pos.x = pos.x * GlobalSetting.GRID_WIDTH;
			pos.y = pos.y * GlobalSetting.GRID_HEIGHT;
			return pos;
		}
		
		public function get mouseMapObjectRealPos():Point {
			var pos:Point = mouseMapPos;
			pos.x = pos.x * GlobalSetting.GRID_WIDTH + GlobalSetting.HALF_GRID_WIDTH;
			pos.y = pos.y * GlobalSetting.GRID_HEIGHT + GlobalSetting.HALF_GRID_HEIGHT;
			return pos;
		}
		
		public function get currentPos():Point {
			return mCurrentPos;
		}
		
		public function get mapWidth():Number {
			return mMapWidth;
		}
		
		public function get mapHeight():Number {
			return mMapHeight;
		}
	}
}