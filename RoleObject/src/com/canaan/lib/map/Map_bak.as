package com.canaan.lib.map
{
	import com.canaan.lib.core.DLoader;
	import com.canaan.lib.debug.Log;
	import com.canaan.lib.managers.ResManager;
	import com.canaan.lib.managers.TimerManager;
	import com.canaan.lib.map.data.MapVo;
	import com.canaan.lib.utils.MathUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	public class Map_bak
	{
		/**
		 * 资源缓存
		 */
		public static var cache:Dictionary = new Dictionary();
		
		/**
		 * 加载缓存
		 */		
		public static var batchLoadList:Array = [];
		
		/**
		 * 源地图缓冲区
		 */
		protected var buffer:BitmapData;
		
		/**
		 * tile x轴数量
		 */
		protected var tileX:int;
		
		/**
		 * tile y轴数量
		 */
		protected var tileY:int;
		
		/**
		 * 当前绘制起始点x轴坐标
		 */
		protected var currentStartX:int;
		
		/**
		 * 当前绘制起始点y轴坐标
		 */
		protected var currentStartY:int;
		
		/**
		 * 当前绘制的tile
		 */
		protected var drawTiles:Dictionary;
		
		/**
		 * 地图数据
		 */
		protected var _mapVo:MapVo;
		
		/**
		 * 缩略图源数据
		 */
		protected var _bmpdThumbnail:BitmapData;
		
		/**
		 * 地图绘制区
		 */
		//		protected var _drawBuffer:Shape;
		protected var _drawBuffer:Bitmap;
		
		/**
		 * 地图中心点坐标
		 */
		protected var _center:Point;
		
		public function Map_bak()
		{
			_center = new Point();
			//			_drawBuffer = new Shape();
			_drawBuffer = new Bitmap();
			
			TimerManager.getInstance().doFrameLoop(1, batchLoadImage);
		}
		
		private function batchLoadImages():void {
			batchLoadImage();
			batchLoadImage();
		}
		
		private function batchLoadImage():void {
			if (batchLoadList.length > 0) {
				var loader:DLoader = batchLoadList.shift();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, tileComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, tileIoErrorHandler);
				var loaderContext:LoaderContext = new LoaderContext();
				loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
				loader.load(new URLRequest(loader.data.tilePath), loaderContext);
			}
		}
		
		/**
		 * 初始化地图并开始加载缩略图
		 */
		public function initialize(mapVo:MapVo):void {
			clearCache();
			buffer = null;
			_bmpdThumbnail = null;
			_mapVo = mapVo;
			_center.x = _mapVo.halfRenderWidth;
			_center.y = _mapVo.halfRenderHeight;
			resize();
			showThumbnail();
		}

		/**
		 * 加载地图切片
		 */
		protected function loadTiles():void {
			//			_drawBuffer.cacheAsBitmap = false;
			var point:Point;
			var tilePath:String;
			var loader:DLoader;
			var bmpDataCache:BitmapData;
			for (var key:String in drawTiles) {
				point = drawTiles[key];
				if (point.x < _mapVo.maxTileX && point.y < _mapVo.maxTileY) {
					tilePath = _mapVo.getTilePath(point.x, point.y);
					if (cache[tilePath] != null) {
						bmpDataCache = cache[tilePath] as BitmapData;
						if (bmpDataCache != null) {
							buffer.copyPixels(bmpDataCache, bmpDataCache.rect, new Point((point.x - currentStartX) * _mapVo.tileWidth, (point.y - currentStartY) * _mapVo.tileHeight));
							delete drawTiles[key];
						}
					} else {
						loader = DLoader.fromPool();
						loader.data = {mapId:_mapVo.id, tx:point.x, ty:point.y, key:key, tilePath:tilePath};
						cache[tilePath] = loader;
						batchLoadList.push(loader);
						loader = null;
					}
				} else {
					buffer.fillRect(new Rectangle((point.x - currentStartX) * _mapVo.tileWidth, (point.y - currentStartY) * _mapVo.tileHeight, _mapVo.tileWidth, _mapVo.tileHeight), 0);
					delete drawTiles[key];
				}
			}
			//			if (drawTiles.length == 0) {
			//				_drawBuffer.cacheAsBitmap = true;
			//			}
		}
		
		/**
		 * 显示缩略图
		 */		
		protected function showThumbnail():void {
			_bmpdThumbnail = ResManager.getInstance().getContent(_mapVo.thumbnailRelativePath);
			if (_bmpdThumbnail != null) {
				update(-1, -1, true);
			}
		}
		
		/**
		 * 地图切片完成事件
		 */
		protected function tileComplete(event:Event):void {
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, tileComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, tileIoErrorHandler);
			
			var loader:DLoader = loaderInfo.loader as DLoader;
			if (loader.data != null && loader.data.mapId == _mapVo.id) {
				var tx:int = loader.data.tx;
				var ty:int = loader.data.ty;
				var key:String = loader.data.key;
				var tilePath:String = loader.data.tilePath;
				cache[tilePath] = Bitmap(loaderInfo.content).bitmapData;
				if (drawTiles[key]) {
					buffer.copyPixels(cache[tilePath], cache[tilePath].rect, new Point((tx - currentStartX) * _mapVo.tileWidth, (ty - currentStartY) * _mapVo.tileHeight));
					delete drawTiles[key];
					//				if (drawTiles.length == 0) {
					//					_drawBuffer.cacheAsBitmap = true;
					//				}
				}
			}
			loader.data = null;
			DLoader.toPool(loader);
		}
		
		/**
		 * 切片IO异常
		 */
		protected function tileIoErrorHandler(event:IOErrorEvent):void {
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, tileComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, tileIoErrorHandler);
			
			var loader:DLoader = loaderInfo.loader as DLoader;
			var tilePath:String = loader.data.tilePath.toString();
			delete cache[tilePath];
			DLoader.toPool(loader);
			Log.getInstance().error("Map load error:" + event.text);
		}
		
		/**
		 * 重绘
		 */
		public function resize():void {
			if (_mapVo == null) {
				return;
			}
			if (buffer != null) {
				buffer.dispose();
			}
			buffer = new BitmapData(_mapVo.mapRenderWidth + _mapVo.tileWidth, _mapVo.mapRenderHeight + _mapVo.tileHeight, false, 0x000000);
			
			//			_drawBuffer.graphics.clear();
			//			_drawBuffer.graphics.beginBitmapFill(buffer);
			//			_drawBuffer.graphics.drawRect(0, 0, buffer.width, buffer.height);
			_drawBuffer.bitmapData = buffer;
			
			tileX = Math.ceil(_mapVo.mapRenderWidth / _mapVo.tileWidth) + 1;
			tileY = Math.ceil(_mapVo.mapRenderHeight / _mapVo.tileHeight) + 1;
			
			render(true);
		}
		
		/**
		 * 更新地图数据
		 */
		protected function update(startX:int = -1, startY:int = -1, redraw:Boolean = false):void {
			if (startX == -1) {
				var pLeftTop:Point = leftTop;
				startX = int(pLeftTop.x / _mapVo.tileWidth);
				startY = int(pLeftTop.y / _mapVo.tileHeight);
			}
			if (currentStartX == startX && currentStartY == startY && !redraw) {
				return;
			}
			currentStartX = startX;
			currentStartY = startY;
			
			if (_bmpdThumbnail == null) {
				return;
			}
			
			drawThumbnail(startX, startY);
			
			drawTiles = new Dictionary();
//			var maxTileX:int = Math.min(startX + tileX, _mapVo.maxTileX);
//			var maxTileY:int = Math.min(startY + tileY, _mapVo.maxTileY);
			var maxTileX:int = startX + tileX;
			var maxTileY:int = startY + tileY;
			for (var y:int = startY; y < maxTileY; y++) {
				for (var x:int = startX; x < maxTileX; x++) {
					drawTiles[_mapVo.getTileKey(x, y)] = new Point(x, y);
				}
			}
			loadTiles();
		}
		
		/**
		 * 渲染
		 */
		public function render(redraw:Boolean = false):void {
			var pLeftTop:Point = leftTop;
			var startX:int = int(pLeftTop.x / _mapVo.tileWidth);
			var startY:int = int(pLeftTop.y / _mapVo.tileHeight);
			update(startX, startY, redraw);
			if (currentStartX == startX && currentStartY == startY) {
				_drawBuffer.x = -(pLeftTop.x % _mapVo.tileWidth);
				_drawBuffer.y = -(pLeftTop.y % _mapVo.tileHeight);
			}
		}
		
		protected function drawThumbnail(startX:int, startY:int):void {
			var percentX:Number = _mapVo.mapWidth / _bmpdThumbnail.width;
			var percentY:Number = _mapVo.mapHeight / _bmpdThumbnail.height;
			var matrix:Matrix = new Matrix(percentX, 0, 0, percentY, -startX * _mapVo.tileWidth, -startY * _mapVo.tileHeight);
			buffer.draw(_bmpdThumbnail, matrix);
		}
		
		public function moveTo(x:Number, y:Number):void {
			_center.x = MathUtil.rangeLimit(x, _mapVo.mapRenderWidth * 0.5, _mapVo.mapWidth - _mapVo.mapRenderWidth * 0.5);
			_center.y = MathUtil.rangeLimit(y, _mapVo.mapRenderHeight * 0.5, _mapVo.mapHeight - _mapVo.mapRenderHeight * 0.5);
			render();
		}
		
		public function moveToOffset(offsetX:Number, offsetY:Number):void {
			moveTo(_center.x + offsetX, _center.y + offsetY);
		}
		
		public function moveToScreen(screenX:Number, screenY:Number):void {
			moveTo(_center.x + screenX - _mapVo.mapRenderWidth * 0.5, _center.y + screenY - _mapVo.mapRenderHeight * 0.5);
		}
		
		public function get leftTop():Point {
			var xx:Number;
			var yy:Number;
			xx = MathUtil.rangeLimit(_center.x - _mapVo.mapRenderWidth * 0.5, 0, _mapVo.mapWidth - _mapVo.mapRenderWidth);
			yy = MathUtil.rangeLimit(_center.y - _mapVo.mapRenderHeight * 0.5, 0, _mapVo.mapHeight - _mapVo.mapRenderHeight);
			return new Point(xx, yy);
		}
		
		public function get mapVo():MapVo {
			return _mapVo;
		}
		
		public function get bmpdThumbnail():BitmapData {
			return _bmpdThumbnail;
		}
		
		//		public function get drawBuffer():Shape {
		//			return _drawBuffer;
		//		}
		
		public function get drawBuffer():Bitmap {
			return _drawBuffer;
		}
		
		public function get center():Point {
			return _center;
		}
		
		public function getScreenPosition(mapX:Number, mapY:Number):Point {
			var screenPosition:Point = new Point(_mapVo.halfRenderWidth, _mapVo.halfRenderHeight);
			screenPosition.x += mapX - _center.x;
			screenPosition.y += mapY - _center.y;
			return screenPosition;
		}
		
		public function getMapPosition(x:Number, y:Number):Point {
			var mapPosition:Point = _center.clone();
			mapPosition.x += x - _mapVo.halfRenderWidth;
			mapPosition.y += y - _mapVo.halfRenderHeight;
			return mapPosition;
		}
		
		public static function clearCache():void {
			var obj:Object;
			for (var path:String in cache) {
				obj = cache[path];
				if (obj is BitmapData) {
					BitmapData(obj).dispose();
				} else if (obj is DLoader) {
					DLoader(obj).dispose();
				}
				obj = null;
				delete cache[path];
			}
			batchLoadList.length = 0;
		}
	}
}