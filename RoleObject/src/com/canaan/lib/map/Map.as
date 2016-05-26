package com.canaan.lib.map
{
	import com.canaan.lib.debug.Log;
	import com.canaan.lib.display.BaseSprite;
	import com.canaan.lib.managers.ResManager;
	import com.canaan.lib.map.data.MapVo;
	import com.canaan.lib.utils.MathUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;

	public class Map
	{
		/**
		 * 资源缓存
		 */
		public static var cache:Dictionary = new Dictionary();
		
		/**
		 * 加载列表
		 */		
		public static var loadList:Array = [];
		
		/**
		 * 最大加载数量
		 */		
		public static var maxLoadCount:int = 2;
		
		/**
		 * 加载数量
		 */		
		public static var loadCount:int;
		
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
		 * 地图block
		 */		
		protected var mapBlocks:Dictionary;
		
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
		protected var _drawBuffer:BaseSprite;
		
		/**
		 * 地图中心点坐标
		 */
		protected var _center:Point;
		
		protected var _leftTop:Point;
		
		public function Map()
		{
			_center = new Point();
			_leftTop = new Point();
			_drawBuffer = new BaseSprite();
			_drawBuffer.mouseChildren = false;
			_drawBuffer.mouseEnabled = false;
			mapBlocks = new Dictionary();
		}
		
		private function loadNext():void {
			if (loadCount >= maxLoadCount) {
				return;
			}
			if (loadList.length > 0) {
				loadCount++;
				var loader:MapLoader = loadList.shift();
				loader.completeCallback = tileComplete;
				loader.errorCallback = tileIoErrorHandler;
				var loaderContext:LoaderContext = new LoaderContext();
				loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
				var tilePath:String = _mapVo.getTilePath(loader.tx, loader.ty);
				loader.load(new URLRequest(tilePath), loaderContext);
			}
		}
		
		/**
		 * 清理加载列表
		 * 
		 */		
		public function clearLoadList():void {
			for each (var loader:MapLoader in loadList) {
				delete cache[loader.key];
				MapLoader.toPool(loader);
			}
			loadList.length = 0;
		}
		
		/**
		 * 初始化地图并开始加载缩略图
		 */
		public function initialize(mapVo:MapVo, x:int, y:int):void {
			if (_mapVo != null) {
				clearCache();
			}
			_mapVo = mapVo;
			_bmpdThumbnail = ResManager.getInstance().getContent(_mapVo.thumbnailRelativePath);
			_center.x = MathUtil.rangeLimit(x, _mapVo.mapRenderWidth * 0.5, _mapVo.mapWidth - _mapVo.mapRenderWidth * 0.5);
			_center.y = MathUtil.rangeLimit(y, _mapVo.mapRenderHeight * 0.5, _mapVo.mapHeight - _mapVo.mapRenderHeight * 0.5);
			resize();
		}
		
		/**
		 * 初始化地块
		 * 
		 */		
		protected function initBlocks():void {
			clearMapBlocks();
			
			tileX = Math.ceil(_mapVo.mapRenderWidth / _mapVo.tileWidth) + 1;
			tileY = Math.ceil(_mapVo.mapRenderHeight / _mapVo.tileHeight) + 1;
			
			var mapBlock:MapBlock;
			for (var i:int = 0; i < tileX; i++) {
				for (var j:int = 0; j < tileY; j++) {
					mapBlock = MapBlock.fromPool();
					mapBlock.x = i * _mapVo.tileWidth;
					mapBlock.y = j * _mapVo.tileHeight;
					_drawBuffer.addChild(mapBlock);
					mapBlocks[i + "_" + j] = mapBlock;
				}
			}
		}
		
		/**
		 * 重绘
		 */
		public function resize():void {
			if (_mapVo == null) {
				return;
			}
			
			initBlocks();
			render(true);
		}
		
		/**
		 * 渲染
		 */
		public function render(redraw:Boolean = false):void {
			var pLeftTop:Point = leftTop;
			var startX:int = int(pLeftTop.x / _mapVo.tileWidth);
			var startY:int = int(pLeftTop.y / _mapVo.tileHeight);
			_drawBuffer.x = -(pLeftTop.x % _mapVo.tileWidth);
			_drawBuffer.y = -(pLeftTop.y % _mapVo.tileHeight);
			
			if (currentStartX == startX && currentStartY == startY && !redraw) {
				return;
			}
			currentStartX = startX;
			currentStartY = startY;
			
			drawTiles = new Dictionary();
			var maxTileX:int = startX + tileX;
			var maxTileY:int = startY + tileY;
			var key:String;
			for (var y:int = startY; y < maxTileY; y++) {
				for (var x:int = startX; x < maxTileX; x++) {
					key = _mapVo.getTileKey(x, y);
					drawTiles[key] = new Point(x, y);
				}
			}
			
			// 移除加载缓存
			var loader:MapLoader;
			for (var i:int = loadList.length - 1; i >= 0; i--) {
				loader = loadList[i];
				key = loader.key;
				if (!drawTiles.hasOwnProperty(key)) {
					MapLoader.toPool(loader);
					loadList.splice(i, 1);
					delete cache[key];
				}
			}
			
			loadTiles();
		}
		
		/**
		 * 加载地图切片
		 */
		protected function loadTiles():void {
			var point:Point;
			var tileXIndex:int;
			var tileYIndex:int;
			var mapBlock:MapBlock;
			var bitmapData:BitmapData;
			var loader:MapLoader;
			for (var key:String in drawTiles) {
				point = drawTiles[key];
				tileXIndex = point.x - currentStartX;
				tileYIndex = point.y - currentStartY;
				mapBlock = getMapBlockAt(tileXIndex, tileYIndex);
				if (point.x < _mapVo.maxTileX && point.y < _mapVo.maxTileY) {
					if (cache[key] != null) {
						bitmapData = cache[key] as BitmapData;
						if (bitmapData != null) {
							if (mapBlock.url != key || mapBlock.loaded != true) {
								mapBlock.loaded = true;
								mapBlock.setBitmapData(key, bitmapData);
							}
							delete drawTiles[key];
						} else {
							if (mapBlock.url != key || mapBlock.loaded != false) {
								mapBlock.loaded = false;
								bitmapData = createTileThumbnailBitmapData(key, point.x, point.y);
								mapBlock.setBitmapData(key, bitmapData);
							}
						}
					} else {
						mapBlock.loaded = false;
						bitmapData = createTileThumbnailBitmapData(key, point.x, point.y);
						mapBlock.setBitmapData(key, bitmapData);
						loader = MapLoader.fromPool();
						loader.mapId = _mapVo.id;
						loader.tx = point.x;
						loader.ty = point.y;
						loader.key = key;
						cache[key] = loader;
						loadList.push(loader);
						loadNext();
					}
				} else {
					mapBlock.loaded = true;
					mapBlock.setBitmapData(key, null);
					delete drawTiles[key];
				}
			}
		}
		
		protected function createTileThumbnailBitmapData(key:String, x:int, y:int):BitmapData {
			var thumbnailKey:String = key + "_t";
			var bitmapData:BitmapData = cache[thumbnailKey];
			if (bitmapData == null) {
				cache[thumbnailKey] = bitmapData = new BitmapData(_mapVo.tileWidth, _mapVo.tileHeight, false, 0x000000);
				var matrix:Matrix = new Matrix(_mapVo.mapWidth / _bmpdThumbnail.width, 0, 0, _mapVo.mapHeight / _bmpdThumbnail.height, -x * _mapVo.tileWidth, -y * _mapVo.tileHeight);
				bitmapData.draw(_bmpdThumbnail, matrix);
			}
			return bitmapData;
		}
		
		/**
		 * 清除地图区块
		 * 
		 */		
		protected function clearMapBlocks():void {
			var mapBlock:MapBlock;
			for (var key:String in mapBlocks) {
				mapBlock = mapBlocks[key];
				MapBlock.toPool(mapBlock);
				delete mapBlocks[key];
			}
			_drawBuffer.removeAllChildren();
		}
		
		/**
		 * 地图切片完成事件
		 */
		protected function tileComplete(loader:MapLoader, event:Event):void {
			if (loader.mapId == _mapVo.id) {
				var tx:int = loader.tx;
				var ty:int = loader.ty;
				var key:String = loader.key;
				var bitmapData:BitmapData = cache[key] = Bitmap(loader.contentLoaderInfo.content).bitmapData;
				if (drawTiles[key]) {
					var mapBlock:MapBlock = getMapBlockAt(tx - currentStartX, ty - currentStartY);
					mapBlock.loaded = true;
					mapBlock.setBitmapData(key, bitmapData);
					delete drawTiles[key];
				}
				var thumbnailKey:String = key + "_t";
				var thumbnail:BitmapData = cache[thumbnailKey];
				if (thumbnail != null) {
					thumbnail.dispose();
					delete cache[thumbnailKey];
				}
			}
			MapLoader.toPool(loader);
			
			loadCount--;
			loadNext();
		}
		
		/**
		 * 切片IO异常
		 */
		protected function tileIoErrorHandler(loader:MapLoader, event:IOErrorEvent):void {
			delete cache[loader.key];
			MapLoader.toPool(loader);
			
			loadCount--;
			loadNext();
			
			Log.getInstance().error("Map load error:" + event.text);
		}
		
		protected function getMapBlockAt(x:int, y:int):MapBlock {
			return mapBlocks[x + "_" + y];
		}
		
		public function moveTo(x:Number, y:Number):void {
			if (_mapVo == null) {
				return;
			}
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
			_leftTop.x = MathUtil.rangeLimit(_center.x - _mapVo.mapRenderWidth * 0.5, 0, _mapVo.mapWidth - _mapVo.mapRenderWidth);
			_leftTop.y = MathUtil.rangeLimit(_center.y - _mapVo.mapRenderHeight * 0.5, 0, _mapVo.mapHeight - _mapVo.mapRenderHeight);
			return _leftTop;
		}
		
		public function get mapVo():MapVo {
			return _mapVo;
		}
		
		public function get bmpdThumbnail():BitmapData {
			return _bmpdThumbnail;
		}
		
		public function get drawBuffer():BaseSprite {
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
		
		public static function setCache(key:String, value:*):void {
			cache[key] = value;
		}
		
		public static function clearCache():void {
			var obj:Object;
			for (var path:String in cache) {
				obj = cache[path];
				if (obj is BitmapData) {
					BitmapData(obj).dispose();
				} else if (obj is MapLoader) {
					MapLoader.toPool(MapLoader(obj));
				}
				obj = null;
				delete cache[path];
			}
			loadList.length = 0;
			loadCount = 0;
		}
	}
}

import com.canaan.lib.interfaces.IPoolableObject;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;

class MapBlock extends Bitmap implements IPoolableObject
{
	private static const mPool:Vector.<MapBlock> = new Vector.<MapBlock>();
	
	public var loaded:Boolean;
	public var url:String;
	
	public function MapBlock()
	{
		super();
	}
	
	public function setBitmapData(url:String, bitmapData:BitmapData):void {
		this.url = url;
		this.bitmapData = bitmapData;
	}
	
	public function poolInitialize(data:Object = null):void {
		
	}
	
	public function poolDestory():void {
		loaded = false;
		url = null;
		bitmapData = null;
	}
	
	public static function fromPool():MapBlock {
		return mPool.length != 0 ? mPool.pop() : new MapBlock();
	}
	
	public static function toPool(block:MapBlock):void {
		block.poolDestory();
		mPool.push(block);
	}
}

class MapLoader extends Loader implements IPoolableObject
{
	private static const mPool:Vector.<MapLoader> = new Vector.<MapLoader>();
	
	public var mapId:String;
	public var tx:int;
	public var ty:int;
	public var key:String;
	public var completeCallback:Function;
	public var errorCallback:Function;
	
	public function MapLoader()
	{
		super();
	}
	
	public function poolInitialize(data:Object = null):void {
		contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
		contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
	}
	
	public function poolDestory():void {
		contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
		contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
		mapId = null;
		tx = 0;
		ty = 0;
		key = null;
		completeCallback = null;
		errorCallback = null;
	}
	
	private function onComplete(event:Event):void {
		if (completeCallback != null) {
			completeCallback.apply(null, [this, event]);
		}
	}
	
	private function onIoError(event:IOErrorEvent):void {
		if (errorCallback != null) {
			errorCallback.apply(null, [this, event]);
		}
	}
	
	public static function fromPool():MapLoader {
		var mapLoader:MapLoader = mPool.length != 0 ? mPool.pop() : new MapLoader();
		mapLoader.poolInitialize();
		return mapLoader;
	}
	
	public static function toPool(loader:MapLoader):void {
		loader.poolDestory();
		mPool.push(loader);
	}
}