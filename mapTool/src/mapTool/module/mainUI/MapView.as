package mapTool.module.mainUI
{
	import flash.display.BitmapData;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsSolidFill;
	import flash.display.GraphicsStroke;
	import flash.display.IGraphicsData;
	import flash.display.Shape;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import mapTool.MapSetting;
	import mapTool.model.GameModel;
	import mapTool.model.vo.MapDataVo;
	import mapTool.model.vo.MapObjVo;
	
	import uiCreate.mainUI.MapViewUI;
	

	public class MapView extends MapViewUI
	{
		private const maxShapMouseScale:Array = [1, 3, 5, 7];
		private var mMapDataVo:MapDataVo;
		private var shapGrid:Shape;
		private var shapMouse:Shape;
		private var shapMap:Shape;
		private var mRightDown:Boolean;
		private var mRightMousePos:Point;
		private var isCtrl:Boolean;
		private var isShift:Boolean;
		private var isAlt:Boolean;
		private var mShapMouseScale:int = 0;
		private var drawPathDic:Dictionary = new Dictionary();
		
		public function MapView()
		{
			shapGrid = new Shape();
			shapMouse = new Shape();
			shapMap = new Shape();
			addChild(imgMap);
			imgMap.addChild(shapMap);
			addChild(shapGrid);
			addChild(shapMouse);
			App.stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown);
			App.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			App.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			App.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			imgMap.addEventListener(MouseEvent.CLICK, onMouseClick);
			imgMap.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function drawShapMap(row:int, col:int, color:uint):void {
			var stroke:GraphicsStroke = new GraphicsStroke();
			stroke.fill = new GraphicsSolidFill(color, 0.3);
			var path:GraphicsPath = new GraphicsPath();
			path.moveTo(row * MapSetting.gridW, col * MapSetting.gridH);
			path.lineTo((row + 1) * MapSetting.gridW, col * MapSetting.gridH);
			path.lineTo((row + 1) * MapSetting.gridW, (col + 1) * MapSetting.gridH);
			path.lineTo(row * MapSetting.gridW, (col + 1) * MapSetting.gridH);
			path.lineTo(row * MapSetting.gridW, col * MapSetting.gridH);
			var commands:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
			commands.push(stroke);
			commands.push(path);
			if (drawPathDic[row] == null) {
				drawPathDic[row] = new Dictionary();
			}
			drawPathDic[row][col] = commands;
		}
		
		private function onMouseDown(event:MouseEvent):void {
			imgMap.addEventListener(MouseEvent.MOUSE_MOVE, onMouseDownMove);
			imgMap.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseUp(event:MouseEvent):void {
			imgMap.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseDownMove);
			imgMap.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function updateMap():void {
			var i:int = 0;
			var j:int = 0;
			var mapObjVo:MapObjVo;
			var gridW:int = GameModel.modelMap.mapDataVo.gridW;
			var gridH:int = GameModel.modelMap.mapDataVo.gridH;
			var row:int = GameModel.modelMap.mapDataVo.mapRow;
			var col:int = GameModel.modelMap.mapDataVo.mapCol;
			shapMap.graphics.clear();
			for (i = 0; i < row; i++) {
				for (j = 0; j < col; j++) {
					mapObjVo = GameModel.modelMap.getMapObjByRowAndCol(i, j);
					if (mapObjVo.walkAble == 0) {
						shapMap.graphics.beginFill(0xff0000, 0.3);
						shapMap.graphics.drawRect(i * gridW, j * gridH, gridW, gridH);
					}
					if (mapObjVo.hideAble == 1) {
						shapMap.graphics.beginFill(0x00ff00, 0.3);
						shapMap.graphics.drawRect(i * gridW, j * gridH, gridW, gridH);
					}
				}
			}
			shapMap.graphics.endFill();
//			var commands:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
//			var dic:Dictionary;
//			var data:Vector.<IGraphicsData>;
//			shapMap.graphics.clear();
//			shapMap.graphics.beginFill(0xff0000, 0.3);
//			for each (dic in drawPathDic) {
//				for each (data in dic) {
//					commands.concat(data);
//				}
//			}
//			shapMap.graphics.drawGraphicsData(commands);
//			shapMap.graphics.endFill();
		}
		
		private function showShapMap():void {
			shapMap.visible = true;
		}
		
		private function hideShapMap():void {
			shapMap.visible = false;
		}
		
		private function onMouseDownMove(event:MouseEvent):void {
			var row:int = (Math.abs(imgMap.x) + mouseX) / MapSetting.gridW;
			var col:int = (Math.abs(imgMap.y) + mouseY) / MapSetting.gridH;
			var imgPoint:Point = imgMap.globalToLocal(new Point(mouseX, mouseY));
			if (imgPoint.x - row * MapSetting.gridW > 8 && imgPoint.y - col * MapSetting.gridH > 8 && imgPoint.x - (row + 1) * MapSetting.gridW < -8 && imgPoint.y - (col + 1) * MapSetting.gridH < -8) {
				var mapObjVo:MapObjVo = GameModel.modelMap.getMapObjByRowAndCol(row, col);
				arrSpiralLogic(mapObjVo);
			}
		}
		
		private function onMouseClick(event:MouseEvent):void {
			var row:int;
			var col:int;
			var mapObjVo:MapObjVo;
			row = (Math.abs(imgMap.x) + mouseX) / MapSetting.gridW;
			col = (Math.abs(imgMap.y) + mouseY) / MapSetting.gridH;
			var obj:Object = GameModel.modelMap.getMapObjByRowAndCol(row, col);
			mapObjVo = GameModel.modelMap.getMapObjByRowAndCol(row, col);
			arrSpiralLogic(mapObjVo);
		}
		
		private function arrSpiralLogic(startNode:MapObjVo):void {
			if (startNode == null) {
				return;
			}
			var i:int;
			var j:int;
			var row:int;
			var col:int;
			var node:MapObjVo = startNode;
			var startRow:int = node.row;
			var startCol:int = node.col;
			var index:int = 1;
			var edge:int = maxShapMouseScale[mShapMouseScale];
			for (i = 1; i <= edge; i++) {
				index *= -1;
				for (j = 1; j <= i * 2; j++) {
					if (node != null) {
						row = node.row;
						col = node.col;
						if (j <= i) {
							if (Math.abs(col + 1 * index - startCol) <= int(edge * 0.5)) {
								node = GameModel.modelMap.getMapObjByRowAndCol(row, col + 1 * index);
							} else {
								node = null;
							}
						} else {
							if (row + 1 * index >= 0) {
								node = GameModel.modelMap.getMapObjByRowAndCol(row + 1 * index, col);
							} else {
								node = null;
							}
						}
						if (node != null) {
							if (isAlt) {
								if (isCtrl && !isShift && node.walkAble == 0) {
									node.walkAble = 1;
								} else if (!isCtrl && isShift && node.hideAble == 1) {
									node.hideAble = 0;
								}
							} else {
								if (isCtrl && !isShift && node.walkAble == 1) {
									node.walkAble = 0;
								} else if (!isCtrl && isShift && node.hideAble == 0) {
									node.hideAble = 1;
								}
							}
						}
					}
				}
			}
			if (isAlt) {
				if (isCtrl && !isShift && startNode.walkAble == 0) {
					startNode.walkAble = 1;
				} else if (!isCtrl && isShift && startNode.hideAble == 1) {
					startNode.hideAble = 0;
				}
			} else {
				if (isCtrl && !isShift && startNode.walkAble == 1) {
					startNode.walkAble = 0;
				} else if (!isCtrl && isShift && startNode.hideAble == 0) {
					startNode.hideAble = 1;
				}
			}
			updateMap();
		}
		
		private function onMouseMove(event:MouseEvent):void {
			if (isCtrl || isShift) {
				shapMouse.x = mouseX;
				shapMouse.y = mouseY;
			}
		}
		
		private function onRightMouseDown(event:MouseEvent):void {
			mRightMousePos = new Point(mouseX, mouseY);
			mRightDown = true;
			addEventListener(MouseEvent.MOUSE_MOVE, onRightMouseMove);
			addEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightMouseUp);
		}
		
		private function onKeyDown(event:KeyboardEvent):void {
			var keyCode:int = event.keyCode;
			switch (keyCode) {
				case Keyboard.CONTROL:
					isCtrl = true;
					drawShapMouse(MapSetting.gridW, MapSetting.gridH);
					showShapMouse();
					break;
				case Keyboard.SHIFT:
					isShift = true;
					drawShapMouse(MapSetting.gridW, MapSetting.gridH);
					showShapMouse();
					break;
				case Keyboard.UP:
					if (isCtrl || isShift) {
						if (maxShapMouseScale[mShapMouseScale] < 7) {
							mShapMouseScale++;
						}
						drawShapMouse(MapSetting.gridW, MapSetting.gridH);
					}
					break;
				case Keyboard.DOWN:
					if (isCtrl || isShift) {
						if (maxShapMouseScale[mShapMouseScale] > 1) {
							mShapMouseScale--;
						}
						drawShapMouse(MapSetting.gridW, MapSetting.gridH);
					}
					break;
				case Keyboard.ALTERNATE:
					isAlt = true;
					drawShapMouse(MapSetting.gridW, MapSetting.gridH);
					showShapMouse();
					break;
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void {
			var keyCode:int = event.keyCode;
			switch (keyCode) {
				case Keyboard.CONTROL:
					isCtrl = false;
					hideShapMouse();
					break;
				case Keyboard.SHIFT:
					isShift = false;
					hideShapMouse();
					break;
				case Keyboard.ALTERNATE:
					isAlt = false;
					if (isCtrl && !isShift) {
						drawShapMouse(MapSetting.gridW, MapSetting.gridH);
						showShapMouse();
					} else if (!isCtrl && isShift) {
						drawShapMouse(MapSetting.gridW, MapSetting.gridH);
						showShapMouse();
					}
					break;
			}
		}
		
		private function drawShapMouse(width:int, height:int):void {
			shapMouse.graphics.clear();
			if (isAlt) {
				if (isCtrl && !isShift) {
					shapMouse.graphics.beginFill(0xff0099, 0.3);
				} else if (!isCtrl && isShift) {
					shapMouse.graphics.beginFill(0x00ff99, 0.3);
				}
			} else {
				if (isCtrl && !isShift) {
					shapMouse.graphics.beginFill(0xff0000, 0.3);
				} else if (!isCtrl && isShift) {
					shapMouse.graphics.beginFill(0x00ff00, 0.3);
				}
			}
			var scale:int = maxShapMouseScale[mShapMouseScale];
			shapMouse.graphics.drawRect(-width * scale * 0.5, -height * scale * 0.5, width * scale, height * scale);
			shapMouse.graphics.endFill();
		}
		
		private function showShapMouse():void {
			shapMouse.visible = true;
			shapMouse.x = mouseX;
			shapMouse.y = mouseY;
		}
		
		private function hideShapMouse():void {
			shapMouse.visible = false;
		}
		
		private function onRightMouseMove(event:MouseEvent):void {
			mapMoveTo(mouseX - mRightMousePos.x, mouseY - mRightMousePos.y);
			mRightMousePos.setTo(mouseX, mouseY);
		}
		
		private function mapMoveTo(dx:int, dy:int):void {
			if (imgMap.x + dx < App.stage.fullScreenWidth - imgMap.width) {
				imgMap.x = App.stage.fullScreenWidth - imgMap.width;
			} else if (imgMap.x + dx > 0) {
				imgMap.x = 0;
			} else {
				imgMap.x += dx;
			}
			if (imgMap.y + dy < App.stage.fullScreenHeight - imgMap.height) {
				imgMap.y = App.stage.fullScreenHeight - imgMap.height;
			} else if (imgMap.y + dy > 0) {
				imgMap.y = 0;
			} else {
				imgMap.y += dy;
			}
			shapGrid.x = imgMap.x % MapSetting.gridW;
			shapGrid.y = imgMap.y % MapSetting.gridH;
		}
		
		private function onRightMouseUp(event:MouseEvent):void {
			mRightDown = false;
			removeEventListener(MouseEvent.MOUSE_MOVE, onRightMouseMove);
			removeEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightMouseUp);
		}
		
		public function show(bitmapData:BitmapData):void {
			mMapDataVo = GameModel.modelMap.mapDataVo;
			imgMap.bitmapData = bitmapData;
			imgMap.width = bitmapData.width;
			imgMap.height = bitmapData.height;
			drawGrid();
			hideGrid();
			hideShapMap();
			hideShapMouse();
			updateMap();
		}
		
		private function drawGrid():void {
			shapGrid.graphics.clear();
			shapGrid.graphics.lineStyle(1, 0xffffff);
			var i:int = 0;
			for (i = 0; i < mMapDataVo.mapRow; i++) {
				shapGrid.graphics.moveTo(i * mMapDataVo.gridW, 0);
				shapGrid.graphics.lineTo(i * mMapDataVo.gridW, mMapDataVo.mapHeight);
			}
			for (i = 0; i < mMapDataVo.mapCol; i++) {
				shapGrid.graphics.moveTo(0, i * mMapDataVo.gridH);
				shapGrid.graphics.lineTo(mMapDataVo.mapWidth, i * mMapDataVo.gridH);
			}
			
		}
		
		public function showGrid():void {
			shapGrid.visible = true;
		}
		
		public function hideGrid():void {
			shapGrid.visible = false;
		}
		
		public function setGridVisible():void {
			shapGrid.visible = !shapGrid.visible;
			shapMap.visible = !shapMap.visible;
		}
		
	}
}