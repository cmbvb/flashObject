package com.canaan.mapEditor.view.map
{
	import com.canaan.lib.display.BaseSprite;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.managers.StageManager;
	import com.canaan.mapEditor.events.GlobalEvent;
	import com.canaan.mapEditor.models.vo.data.MapDataVo;
	import com.canaan.mapEditor.ui.map.MapMiniViewUI;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class MapMiniView extends MapMiniViewUI
	{
		public static var instance:MapMiniView;
		
		private var mMapDataVo:MapDataVo;
		private var mBorder:BaseSprite;
		private var mMousePos:Point;
		
		public function MapMiniView()
		{
			super();
			instance = this;
		}
		
		override protected function onViewCreated():void {
			EventManager.getInstance().addEventListener(GlobalEvent.UPDATE_MAP_POS, onUpdateMapPos);
			EventManager.getInstance().addEventListener(GlobalEvent.UPDATE_MAP_SIZE, onUpdateMapSize);
			imgMap.addEventListener(MouseEvent.CLICK, onMapMouseClick);
			mBorder = new BaseSprite();
			mBorder.addEventListener(MouseEvent.MOUSE_DOWN, onBorderMouseDown);
			addChild(mBorder);
		}
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mMapDataVo = value as MapDataVo;
			
			lblMapName.text = mMapDataVo.name;
			lblResName.text = mMapDataVo.resName;
			lblMapSize.text = mMapDataVo.mapWidth + "*" + mMapDataVo.mapHeight;
			lblMapGrid.text = mMapDataVo.colCount + "*" + mMapDataVo.rowCount;
			
			var bitmapData:BitmapData = new BitmapData(imgMap.width, imgMap.height, false, 0);
			bitmapData.draw(mMapDataVo.bitmapData, new Matrix(imgMap.width / mMapDataVo.mapWidth, 0, 0, imgMap.height / mMapDataVo.mapHeight));
			imgMap.bitmapData = bitmapData;
		}
		
		private function onUpdateMapPos(event:GlobalEvent):void {
			mBorder.x = imgMap.width * MapView.instance.currentPos.x / mMapDataVo.mapWidth;
			mBorder.y = imgMap.height * MapView.instance.currentPos.y / mMapDataVo.mapHeight;
		}
		
		private function onUpdateMapSize(event:GlobalEvent):void {
			if (mMapDataVo != null) {
				var borderWidth:Number = imgMap.width * (MapView.instance.mapWidth / mMapDataVo.mapWidth);
				var borderHeight:Number = imgMap.height * (MapView.instance.mapHeight / mMapDataVo.mapHeight);
				mBorder.graphics.clear();
				mBorder.graphics.beginFill(0, 0);
				mBorder.graphics.lineStyle(1, 0xff0000);
				mBorder.graphics.drawRect(0, 0, borderWidth, borderHeight);
				mBorder.graphics.endFill();
			}
		}
		
		private function onMapMouseClick(event:MouseEvent):void {
			var offsetX:Number = imgMap.mouseX * (mMapDataVo.mapWidth / imgMap.width);
			var offsetY:Number = imgMap.mouseY * (mMapDataVo.mapHeight / imgMap.height);
			MapView.instance.moveMapTo(offsetX, offsetY);
		}
		
		private function onBorderMouseDown(event:MouseEvent):void {
			mMousePos = new Point(StageManager.getInstance().stage.mouseX, StageManager.getInstance().stage.mouseY);
			StageManager.getInstance().stage.addEventListener(MouseEvent.MOUSE_MOVE, onMapMouseMove);
			StageManager.getInstance().stage.addEventListener(MouseEvent.MOUSE_UP, onMapMouseUp);
		}
		
		private function onMapMouseMove(event:MouseEvent):void {
			var offsetX:Number = (StageManager.getInstance().stage.mouseX - mMousePos.x) * (mMapDataVo.mapWidth / imgMap.width);
			var offsetY:Number = (StageManager.getInstance().stage.mouseY - mMousePos.y) * (mMapDataVo.mapHeight / imgMap.height);
			MapView.instance.moveMapOffset(offsetX, offsetY);
			mMousePos.setTo(StageManager.getInstance().stage.mouseX, StageManager.getInstance().stage.mouseY);
		}
		
		private function onMapMouseUp(event:MouseEvent = null):void {
			StageManager.getInstance().stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMapMouseMove);
			StageManager.getInstance().stage.removeEventListener(MouseEvent.MOUSE_UP, onMapMouseUp);
		}
	}
}