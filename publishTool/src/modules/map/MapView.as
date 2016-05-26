package modules.map
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import morn.core.components.Box;

	public class MapView extends Box
	{
		private var mapBit:Bitmap;
		private var mapLoadArr:Array = [];
		private var currentNode:Point;
//		private var centerX:int = 10;
//		private var centerY:int = 10;
		private var centerPoint:Point;
		private var mapTileDic:Dictionary = new Dictionary();
		
		public function MapView()
		{
			mapBit = new Bitmap();
			addChild(mapBit);
			mapBit.bitmapData = new BitmapData(App.stage.fullScreenWidth, App.stage.fullScreenHeight);
		}
		
		override protected function resetPosition():void {
			super.resetPosition();
		}
		
		public function showMap(point:Point):void {
			arrSpiralLogic(point);
			centerPoint = new Point(point.x, point.y);
		}
		
		private function arrSpiralLogic(startPoint:Point):void {
			if (startPoint == null) {
				return;
			}
//			if (centerPoint && int(startPoint.x / 256) == int(centerPoint.x / 256) && int(startPoint.y / 256) == int(centerPoint.y / 256)) {
//				return;
//			}
			var i:int;
			var j:int;
			var row:int;
			var col:int;
			var node:Point = new Point(int(startPoint.x / 256), int(startPoint.y / 256));
			var startRow:int = node.x;
			var startCol:int = node.y;
			var index:int = 1;
			var edge:int = Math.max(App.stage.fullScreenWidth / 256, App.stage.fullScreenHeight / 256) + 2;
			mapLoadArr.length = 0;
			mapLoadArr.push(node);
			for (i = 1; i <= edge; i++) {
				index *= -1;
				for (j = 1; j <= i * 2; j++) {
					if (node != null) {
						row = node.x;
						col = node.y;
						if (j <= i) {
							if (Math.abs(col + 1 * index - startCol) <= int(edge * 0.5)) {
								node = new Point(row, col + 1 * index);
							} else {
								node = null;
							}
						} else {
							if (row + 1 * index >= 0) {
								node = new Point(row + 1 * index, col);
							} else {
								node = null;
							}
						}
//						if (node && (node.y - startPoint.y / 256) * 256 + (App.stage.fullScreenWidth - 256) / 2 > -256 && (node.y - startPoint.y / 256) * 256 + (App.stage.fullScreenWidth - 256) / 2 < App.stage.fullScreenWidth && (node.x - startPoint.x / 256) * 256 + (App.stage.fullScreenHeight - 256) / 2 > -256 && (node.x - startPoint.x / 256) * 256 + (App.stage.fullScreenHeight - 256) / 2 < App.stage.fullScreenHeight) {
						if (node) {
							mapLoadArr.push(node);
							trace(node.x, node.y);
						}
//						}
					}
				}
			}
			loadTile();
			trace(mapLoadArr.length);
		}
		
		private function loadTile():void {
			if (mapLoadArr.length > 0) {
				currentNode = mapLoadArr.shift();
				var bit:BitmapData = mapTileDic[currentNode.x + "_" + currentNode.y];
				if (bit) {
//					var point:Point = new Point((currentNode.y - 10) * 256 + (App.stage.fullScreenWidth - 256) / 2, (currentNode.x - 10) * 256 + (App.stage.fullScreenHeight - 256) / 2);
					var point:Point = new Point(currentNode.y * 256 - centerPoint.y + App.stage.fullScreenWidth / 2 - 128, currentNode.x * 256 - centerPoint.x + App.stage.fullScreenHeight / 2 - 128);
					mapBit.bitmapData.copyPixels(bit, bit.rect, point);//, point
					loadTile();
				} else {
					var url:String = "map/assets/mapTile/" + "shameng" + "/" + currentNode.x + "_" + currentNode.y + ".jpg"
					var urlR:URLRequest = new URLRequest(url);
					var load:Loader = new Loader();
					load.load(urlR);
					load.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
				}
			}
		}
		
		private function onLoadComplete(event:Event):void {
			var bitmapData:BitmapData = (event.target.content as Bitmap).bitmapData;
//			var point:Point = new Point((currentNode.y - 10) * 256 + (App.stage.fullScreenWidth - 256) / 2, (currentNode.x - 10) * 256 + (App.stage.fullScreenHeight - 256) / 2);
			var point:Point = new Point(currentNode.y * 256 - centerPoint.y + App.stage.fullScreenWidth / 2 - 128, currentNode.x * 256 - centerPoint.x + App.stage.fullScreenHeight / 2 - 128);
			mapBit.bitmapData.copyPixels(bitmapData, bitmapData.rect, point);
			mapTileDic[currentNode.x + "_" + currentNode.y] = bitmapData;
			loadTile();
		}
		
		
		
	}
}