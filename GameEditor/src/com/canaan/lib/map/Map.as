package com.canaan.lib.map
{
	import com.canaan.lib.core.DLoader;
	import com.canaan.lib.debug.Log;
	import com.canaan.lib.map.data.MapVo;
	import com.canaan.lib.utils.DisplayUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	public class Map
	{
		/**
		 * 资源缓存
		 */
		public static var cache:Dictionary = new Dictionary();
		
		/**
		 * 源地图缓冲区
		 */
		protected var buffer:BitmapData;
		
		/**
		 * 缩略图缓冲区
		 */
		protected var thumbnailBuffer:BitmapData;
		
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
		 * 缩略图是否已经加载完毕
		 */		
		protected var thumbnailLoaded:Boolean;
		
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
		 * 动画区域
		 */		
		protected var _animation:Sprite;
		
		/**
		 * 地图中心点坐标
		 */
		protected var _center:Point;
		
		/**
		 * 限制区域起始X坐标
		 */		
		protected var _rangeStartX:Number;
		
		/**
		 * 限制区域起始Y坐标
		 */		
		protected var _rangeStartY:Number;
		
		/**
		 * 限制区域结束X坐标
		 */		
		protected var _rangeEndX:Number;
		
		/**
		 * 限制区域结束Y坐标
		 */		
		protected var _rangeEndY:Number;
		
		public function Map()
		{
			_center = new Point();
			//			_drawBuffer = new Shape();
			_drawBuffer = new Bitmap();
			_animation = new Sprite();
			_animation.mouseEnabled = false;
			_animation.mouseChildren = false;
		}
		
		/**
		 * 初始化地图并开始加载缩略图
		 */
		public function initialize(mapVo:MapVo):void {
			clearCache();
			_mapVo = mapVo;
			_center.x = _mapVo.halfRenderWidth;
			_center.y = _mapVo.halfRenderHeight;
			DisplayUtil.removeAllChildren(_animation, true);
			_animation.x = 0;
			_animation.y = 0;
			removeRange();
			resize();
			loadThumbnail();
		}
		
		/**
		 * 加载缩略图
		 */
		protected function loadThumbnail():void {
			var thumbnailPath:String = _mapVo.thumbnailPath;
			if (cache[thumbnailPath] != null) {
				var bmpDataCache:BitmapData = cache[thumbnailPath];
				if (bmpDataCache != null) {
					showThumbnail();
				}
			} else {
				var loader:DLoader = DLoader.fromPool();
				loader.data = thumbnailPath;
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, thumbnailComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, thumbnailIoErrorHandler);
				loader.load(new URLRequest(thumbnailPath));
				thumbnailLoaded = false;
			}
		}

		/**
		 * 加载地图切片
		 */
		protected function loadTiles():void {
			if (!thumbnailLoaded) {
				return;
			}
			//			_drawBuffer.cacheAsBitmap = false;
			var point:Point;
			var tilePath:String;
			var loader:DLoader;
			var bmpDataCache:BitmapData;
			for (var key:String in drawTiles) {
				point = drawTiles[key];
				tilePath = _mapVo.getTilePath(point.x, point.y);
				if (cache[tilePath] != null) {
					bmpDataCache = cache[tilePath] as BitmapData;
					if (bmpDataCache != null) {
						buffer.copyPixels(bmpDataCache, bmpDataCache.rect, new Point(int((point.x - currentStartX) * _mapVo.tileWidth), int((point.y - currentStartY) * _mapVo.tileHeight)));
						delete drawTiles[key];
					}
				} else {
					loader = DLoader.fromPool();
					loader.data = {tx:point.x, ty:point.y, key:key, tilePath:tilePath};
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, tileComplete);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, tileIoErrorHandler);
					loader.load(new URLRequest(tilePath));
					cache[tilePath] = loader;
				}
			}
			//			if (drawTiles.length == 0) {
			//				_drawBuffer.cacheAsBitmap = true;
			//			}
		}
		
		/**
		 * 加载动画
		 * 
		 */		
		protected function loadAnimation():void {
			var loader:DLoader = DLoader.fromPool();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, animationComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, animationErrorHandler);
			loader.load(new URLRequest(_mapVo.animationPath));
		}
		
		/**
		 * 缩略图完成事件
		 */
		protected function thumbnailComplete(event:Event):void {
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, thumbnailComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, thumbnailIoErrorHandler);
			
			var loader:DLoader = loaderInfo.loader as DLoader;
			var thumbnailPath:String = loader.data.toString();
			cache[thumbnailPath] = Bitmap(loaderInfo.content).bitmapData;
			DLoader.toPool(loader);
			showThumbnail();
		}
		
		/**
		 * 显示缩略图
		 */		
		protected function showThumbnail():void {
			_bmpdThumbnail = cache[_mapVo.thumbnailPath];
			if (_bmpdThumbnail) {
				var percentX:Number = _bmpdThumbnail.width / _mapVo.mapRenderWidth;
				var percentY:Number = _bmpdThumbnail.height / _mapVo.mapRenderHeight;
				thumbnailBuffer = new BitmapData(buffer.width * percentX, buffer.height * percentY, false, 0x000000);
				thumbnailLoaded = true;
				update(-1, -1, true);
				if (_mapVo.hasAnimation) {
					loadAnimation();
				}
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
			var tx:int = loader.data.tx;
			var ty:int = loader.data.ty;
			var key:String = loader.data.key;
			var tilePath:String = loader.data.tilePath;
			cache[tilePath] = Bitmap(loaderInfo.content).bitmapData;
			if (drawTiles[key]) {
				buffer.copyPixels(cache[tilePath], cache[tilePath].rect, new Point(int((tx - currentStartX) * _mapVo.tileWidth), int((ty - currentStartY) * _mapVo.tileHeight)));
				delete drawTiles[key];
				//				if (drawTiles.length == 0) {
				//					_drawBuffer.cacheAsBitmap = true;
				//				}
			}
			DLoader.toPool(loader);
		}
		
		/**
		 * 动画完成事件
		 * @param event
		 * 
		 */		
		protected function animationComplete(event:Event):void {
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, animationComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, animationErrorHandler);
			
			var loader:DLoader = loaderInfo.loader as DLoader;
			_animation.addChild(loader.content);
			DLoader.toPool(loader);
		}
		
		/**
		 * 缩略图IO异常
		 * @param event
		 * 
		 */		
		protected function thumbnailIoErrorHandler(event:IOErrorEvent):void {
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, thumbnailComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, thumbnailIoErrorHandler);
			
			var loader:DLoader = loaderInfo.loader as DLoader;
			var thumbnailPath:String = loader.data.toString();
			delete cache[thumbnailPath];
			DLoader.toPool(loader);
			Log.getInstance().error("Map load error:" + event.text);
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
		 * 动画IO异常
		 * @param event
		 * 
		 */		
		protected function animationErrorHandler(event:IOErrorEvent):void {
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, animationComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, animationErrorHandler);
			
			var loader:DLoader = loaderInfo.loader as DLoader;
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
			var pLeftTop:Point = leftTop;
			if (startX == -1) {
				startX = int(pLeftTop.x / _mapVo.tileWidth);
				startY = int(pLeftTop.y / _mapVo.tileHeight);
			}
			if (currentStartX == startX && currentStartY == startY && !redraw) {
				return;
			}
			currentStartX = startX;
			currentStartY = startY;
			
			drawTiles = new Dictionary();
			drawThumbnail(startX, startY);
			
			var maxTileX:int = Math.min(startX + tileX, _mapVo.maxTileX);
			var maxTileY:int = Math.min(startY + tileY, _mapVo.maxTileY);
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
			_animation.x = -pLeftTop.x;
			_animation.y = -pLeftTop.y;
		}
		
		protected function drawThumbnail(startX:int, startY:int):void {
			if (_bmpdThumbnail == null || thumbnailBuffer == null) {
				return;
			}
			var percentX:Number = _bmpdThumbnail.width / _mapVo.mapWidth;
			var percentY:Number = _bmpdThumbnail.height / _mapVo.mapHeight;
			thumbnailBuffer.fillRect(thumbnailBuffer.rect, 0x00000000);
			thumbnailBuffer.copyPixels(_bmpdThumbnail, new Rectangle(startX * _mapVo.tileWidth * percentX, startY * _mapVo.tileHeight * percentY, _bmpdThumbnail.width, _bmpdThumbnail.height), new Point());
			percentX = _mapVo.mapWidth / _bmpdThumbnail.width;
			percentY = _mapVo.mapHeight / _bmpdThumbnail.height;
			buffer.draw(thumbnailBuffer, new Matrix(percentX, 0, 0, percentY), null, null, null, true);
		}
		
		public function moveTo(x:Number, y:Number):void {
			// 区域限制
			if (isNaN(_rangeStartX)) {
				_center.x = Math.max(_mapVo.mapRenderWidth * 0.5, Math.min(_mapVo.mapWidth - _mapVo.mapRenderWidth * 0.5, x));
				_center.y = Math.max(_mapVo.mapRenderHeight * 0.5, Math.min(_mapVo.mapHeight - _mapVo.mapRenderHeight * 0.5, y));
			} else {
				_center.x = Math.max(_rangeStartX + _mapVo.mapRenderWidth * 0.5, Math.min(_rangeEndX - _mapVo.mapRenderWidth * 0.5, x));
				_center.y = Math.max(_rangeStartY + _mapVo.mapRenderHeight * 0.5, Math.min(_rangeEndY - _mapVo.mapRenderHeight * 0.5, y));
			}
			render();
		}
		
		public function moveToOffset(offsetX:Number, offsetY:Number):void {
			moveTo(_center.x + offsetX, _center.y + offsetY);
		}
		
		public function moveToScreen(screenX:Number, screenY:Number):void {
			moveTo(_center.x + screenX - _mapVo.mapRenderWidth * 0.5, _center.y + screenY - _mapVo.mapRenderHeight * 0.5);
		}
		
		public static function clearCache():void {
			var obj:Object;
			for (var path:String in cache) {
				obj = cache[path];
				if (obj is BitmapData) {
					BitmapData(obj).dispose();
				} else if (obj is DLoader) {
					DLoader.toPool(DLoader(obj));
				}
				obj = null;
				delete cache[path];
			}
		}
		
		public function get leftTop():Point {
			var xx:Number;
			var yy:Number;
			// 区域限制
			if (isNaN(_rangeStartX)) {
				xx = Math.min(Math.max(0, _center.x - _mapVo.mapRenderWidth * 0.5), Math.max(0, _mapVo.mapWidth - _mapVo.mapRenderWidth));
				yy = Math.min(Math.max(0, _center.y - _mapVo.mapRenderHeight * 0.5), Math.max(0, _mapVo.mapHeight - _mapVo.mapRenderHeight));
			} else {
				xx = Math.min(Math.max(_rangeStartX, _center.x - _mapVo.mapRenderWidth * 0.5), Math.max(_rangeStartX, _rangeEndX - _mapVo.mapRenderWidth));
				yy = Math.min(Math.max(_rangeStartY, _center.y - _mapVo.mapRenderHeight * 0.5), Math.max(_rangeStartY, _rangeEndY - _mapVo.mapRenderHeight));
			}
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
		
		public function get animation():Sprite {
			return _animation;
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
		
		/**
		 * 设置显示区域限制
		 * @param rangeStartX
		 * @param rangeStartY
		 * @param rangeEndX
		 * @param rangeEndY
		 * 
		 */		
		public function setRange(rangeStartX:Number, rangeStartY:Number, rangeEndX:Number, rangeEndY:Number):void {
			_rangeStartX = rangeStartX;
			_rangeStartY = rangeStartY;
			_rangeEndX = rangeEndX;
			_rangeEndY = rangeEndY;
		}
		
		/**
		 * 移除显示区域限制
		 * 
		 */		
		public function removeRange():void {
			_rangeStartX = NaN;
			_rangeStartY = NaN;
			_rangeEndX = NaN;
			_rangeEndY = NaN;
		}
	}
}