package com.canaan.lib.map
{
	import com.adobe.utils.AGALMiniAssembler;
	import com.adobe.utils.PerspectiveMatrix3D;
	import com.canaan.lib.core.DLoader;
	import com.canaan.lib.managers.StageManager;
	import com.canaan.lib.map.data.MapVo;
	import com.canaan.lib.utils.MathUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class GpuMap
	{
		public static var cache:Dictionary = new Dictionary();
		
		protected var mTileX:int;
		protected var mTileY:int;
		protected var mCurrentStartX:int;
		protected var mCurrentStartY:int;
		protected var mDrawTiles:Dictionary;	
		protected var mThumbnailLoaded:Boolean;
		protected var mMapTiles:Vector.<Vector.<MapTile>>;
		
		protected var mStage3D:Stage3D;
		protected var mContext3D:Context3D;
		protected var mVertexBuffer3D:VertexBuffer3D;
		protected var mIndexBuffer3D:IndexBuffer3D;
		protected var mTexture:Texture;
		protected var mVAgalCode:ByteArray;
		protected var mFAgalCode:ByteArray;
		protected var mViewMatrix:Matrix3D;
		protected var mProjectionMatrix:PerspectiveMatrix3D;
		protected var mModelViewMatrix:Matrix3D;
		
		protected var _mapVo:MapVo;
		protected var _bmpdThumbnail:BitmapData;
		protected var _center:Point;
		
		public function GpuMap()
		{
			mViewMatrix = new Matrix3D();
			mProjectionMatrix = new PerspectiveMatrix3D();
			mModelViewMatrix = new Matrix3D();
			_center = new Point();
			
			initMapTiles();
			initAGAL();
			initStage3D();
		}
		
		/**
		 * 初始化AGAL
		 * 
		 */		
		protected function initAGAL():void {
			// AGAL
			var vp:String = "m44, op, va0, vc0\n"
				+ "mov v0, va1";
			var vagal:AGALMiniAssembler = new AGALMiniAssembler();
			vagal.assemble(Context3DProgramType.VERTEX, vp);
			
			var fp:String = "tex ft0, v0, fs0<2d, linear, nomip>\n"
				+ "mov oc, ft0";
			var fagal:AGALMiniAssembler = new AGALMiniAssembler();
			fagal.assemble(Context3DProgramType.FRAGMENT, fp);
			
			mVAgalCode = vagal.agalcode;
			mFAgalCode = fagal.agalcode;
		}
		
		/**
		 * 初始化stage3D
		 * 
		 */		
		protected function initStage3D():void {
			var stage:Stage = StageManager.getInstance().stage;
			if (stage.stage3Ds.length > 0) {
				mStage3D = stage.stage3Ds[0];
				mStage3D.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreate);
				mStage3D.requestContext3D();
			}
		}
		
		/**
		 * 初始化地图切片
		 * 
		 */		
		protected function initMapTiles():void {
			var maxTileX:int = 50;
			var maxTileY:int = 50;
			mMapTiles = new Vector.<Vector.<MapTile>>();
			for (var i:int = 0; i < maxTileX; i++) {
				mMapTiles[i] = new Vector.<MapTile>();
				for (var j:int = 0; j < maxTileX; j++) {
					mMapTiles[i][j] = new MapTile(i, j);
				}
			}
		}
		
		/**
		 * Stage3D运行中
		 * @return 
		 * 
		 */		
		protected function checkStage3D():Boolean {
			if (mContext3D == null) {
				initStage3D();
				return false;
			}
			return true;
		}
		
		protected function onContext3DCreate(event:Event):void {
			mStage3D.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreate);
			mContext3D = mStage3D.context3D;
			
			for (var i:int = 0; i < mMapTiles.length; i++) {
				for (var j:int = 0; j < mMapTiles[i].length; j++) {
					mMapTiles[i][j].setContext3D(mContext3D);
				}
			}
			
			resize();
		}
		
		/**
		 * 初始化地图并开始加载缩略图
		 */
		public function initialize(mapVo:MapVo):void {
			clear();
			_mapVo = mapVo;
			_center.x = _mapVo.halfRenderWidth;
			_center.y = _mapVo.halfRenderHeight;
			resize();
			loadThumbnail();
		}
		
		public function clear():void {
			clearCache();
			if (mTexture) {
				mTexture.dispose();
				mTexture = null;
			}
			for (var i:int = 0; i < mMapTiles.length; i++) {
				for (var j:int = 0; j < mMapTiles[i].length; j++) {
					mMapTiles[i][j].dispose();
				}
			}
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
				var loaderContext:LoaderContext = new LoaderContext();
				loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
				loader.load(new URLRequest(thumbnailPath), loaderContext);
				mThumbnailLoaded = false;
			}
		}
		
		/**
		 * 加载地图切片
		 */
		protected function loadTiles():void {
			if (!mThumbnailLoaded) {
				return;
			}
			var point:Point;
			var tilePath:String;
			var loader:DLoader;
			for (var key:String in mDrawTiles) {
				point = mDrawTiles[key];
				tilePath = _mapVo.getTilePath(point.x, point.y);
				if (cache[tilePath] == null) {
					loader = DLoader.fromPool();
					loader.data = {tx:point.x, ty:point.y, key:key, tilePath:tilePath};
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, tileComplete);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, tileIoErrorHandler);
					var loaderContext:LoaderContext = new LoaderContext();
					loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
					loader.load(new URLRequest(tilePath), loaderContext);
					cache[tilePath] = loader;
				}
			}
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
			DLoader.toPool(loader);
			
			mMapTiles[tx][ty].setBitmapData(cache[tilePath]);
			render(true);
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
		}
		
		/**
		 * 显示缩略图
		 */		
		protected function showThumbnail():void {
			_bmpdThumbnail = cache[_mapVo.thumbnailPath];
			if (_bmpdThumbnail) {
				mThumbnailLoaded = true;
				if (checkStage3D()) {
					mTexture = mContext3D.createTexture(_bmpdThumbnail.width, _bmpdThumbnail.height, Context3DTextureFormat.BGRA, true);
					mTexture.uploadFromBitmapData(_bmpdThumbnail);
					
					var vertexBufferData:Vector.<Number> = new <Number>[
						0, 0, 1, 0, 0,
						_mapVo.mapWidth, 0, 1, 1, 0,
						_mapVo.mapWidth, - _mapVo.mapHeight, 1, 1, 1,
						0, - _mapVo.mapHeight, 1, 0, 1
					];
					
					mVertexBuffer3D = mContext3D.createVertexBuffer(4, 5);
					mVertexBuffer3D.uploadFromVector(vertexBufferData, 0, 4);
					
					var indexBufferData:Vector.<uint> = new <uint>[
						0, 1, 2,
						0, 2, 3
					];
					
					mIndexBuffer3D = mContext3D.createIndexBuffer(6);
					mIndexBuffer3D.uploadFromVector(indexBufferData, 0, 6);
					
					render(true);
				}
			}
		}
		
		/**
		 * 重置大小
		 */
		public function resize():void {
			if (_mapVo == null) {
				return;
			}
			
			mTileX = Math.ceil(_mapVo.mapRenderWidth / _mapVo.tileWidth) + 1;
			mTileY = Math.ceil(_mapVo.mapRenderHeight / _mapVo.tileHeight) + 1;
			
			if (checkStage3D()) {
				mContext3D.configureBackBuffer(_mapVo.mapRenderWidth, _mapVo.mapRenderHeight, 0);
				mProjectionMatrix.orthoLH(_mapVo.mapRenderWidth, _mapVo.mapRenderHeight, 1, 10000);
			}
			
			render(true);
		}
		
		/**
		 * 渲染
		 */
		public function render(redraw:Boolean = false):void {
			var pLeftTop:Point = leftTop;
			var startX:int = int(pLeftTop.x / _mapVo.tileWidth);
			var startY:int = int(pLeftTop.y / _mapVo.tileHeight);
			update(startX, startY, redraw);
			
			if (checkStage3D()) {
				mContext3D.clear();
				
				var program3D:Program3D = mContext3D.createProgram();
				program3D.upload(mVAgalCode, mFAgalCode);
				
				mViewMatrix.identity();
//				mViewMatrix.appendTranslation(-_mapVo.mapRenderWidth / 2, _mapVo.mapRenderHeight / 2, 0);
				mViewMatrix.appendTranslation(-_center.x, _center.y, 0);
				mModelViewMatrix.identity();
				mModelViewMatrix.append(mViewMatrix);
				mModelViewMatrix.append(mProjectionMatrix);
				mContext3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, mModelViewMatrix, true);
				mContext3D.setProgram(program3D);
				
				// 绘制切片图
				var maxTileX:int = Math.min(startX + mTileX, _mapVo.maxTileX);
				var maxTileY:int = Math.min(startY + mTileY, _mapVo.maxTileY);
				for (var y:int = startY; y < maxTileY; y++) {
					for (var x:int = startX; x < maxTileX; x++) {
						mMapTiles[x][y].render();
					}
				}
				// 绘制缩略图
				if (mTexture) {
					mContext3D.setTextureAt(0, mTexture);
					mContext3D.setVertexBufferAt(0, mVertexBuffer3D, 0, Context3DVertexBufferFormat.FLOAT_3);
					mContext3D.setVertexBufferAt(1, mVertexBuffer3D, 3, Context3DVertexBufferFormat.FLOAT_2);
					mContext3D.drawTriangles(mIndexBuffer3D);
				}
				
				mContext3D.present();
			}
		}
		
		/**
		 * 更新地图数据
		 */
		protected function update(startX:int, startY:int, redraw:Boolean = false):void {
			if (startX == -1) {
				var pLeftTop:Point = leftTop;
				startX = int(pLeftTop.x / _mapVo.tileWidth);
				startY = int(pLeftTop.y / _mapVo.tileHeight);
			}
			if (mCurrentStartX == startX && mCurrentStartY == startY && !redraw) {
				return;
			}
			mCurrentStartX = startX;
			mCurrentStartY = startY;
			
			mDrawTiles = new Dictionary();
			var maxTileX:int = Math.min(startX + mTileX, _mapVo.maxTileX);
			var maxTileY:int = Math.min(startY + mTileY, _mapVo.maxTileY);
			for (var y:int = startY; y < maxTileY; y++) {
				for (var x:int = startX; x < maxTileX; x++) {
					mDrawTiles[_mapVo.getTileKey(x, y)] = new Point(x, y);
				}
			}
			loadTiles();
		}
		
		public function moveTo(x:Number, y:Number):void {
			_center.x = x;
			_center.y = y;
//			_center.x = MathUtil.rangeLimit(x, _mapVo.mapRenderWidth * 0.5, _mapVo.mapWidth - _mapVo.mapRenderWidth * 0.5);
//			_center.y = MathUtil.rangeLimit(y, _mapVo.mapRenderHeight * 0.5, _mapVo.mapHeight - _mapVo.mapRenderHeight * 0.5);
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
		
		public function get center():Point {
			return _center;
		}
	}
}

import flash.display.BitmapData;
import flash.display3D.Context3D;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.Context3DVertexBufferFormat;
import flash.display3D.IndexBuffer3D;
import flash.display3D.VertexBuffer3D;
import flash.display3D.textures.Texture;

class MapTile
{
	private var mTileX:int;
	private var mTileY:int;
	private var mBitmapData:BitmapData;
	private var mContext3D:Context3D;
	private var mTexture:Texture;
	private var mVertexBuffer3D:VertexBuffer3D;
	private var mIndexBuffer3D:IndexBuffer3D;
	
	public function MapTile(tileX:int, tileY:int)
	{
		mTileX = tileX;
		mTileY = tileY;
	}
	
	public function setContext3D(context:Context3D):void {
		mContext3D = context;
		upload();
	}
	
	public function setBitmapData(bitmapData:BitmapData):void {
		if (mContext3D == null) {
			return;
		}
		if (mBitmapData != bitmapData) {
			mBitmapData = bitmapData;
			if (mTexture != null) {
				mTexture.dispose();
				mTexture = null;
			}
			mTexture = mContext3D.createTexture(bitmapData.width, bitmapData.height, Context3DTextureFormat.BGRA, true);
			mTexture.uploadFromBitmapData(mBitmapData);
		}
	}
	
	public function render():void {
		if (mContext3D == null) {
			return;
		}
		if (mTexture != null) {
			mContext3D.setTextureAt(0, mTexture);
			mContext3D.setVertexBufferAt(0, mVertexBuffer3D, 0, Context3DVertexBufferFormat.FLOAT_3);
			mContext3D.setVertexBufferAt(1, mVertexBuffer3D, 3, Context3DVertexBufferFormat.FLOAT_2);
			mContext3D.drawTriangles(mIndexBuffer3D);
		}
	}
	
	public function dispose():void {
		mBitmapData = null;
		if (mTexture != null) {
			mTexture.dispose();
			mTexture = null;
		}
	}
	
	private function upload():void {
		if (mContext3D == null) {
			return;
		}
		
		var vertexBufferData:Vector.<Number> = new <Number>[
			(0 + mTileX) * 256, (0 - mTileY) * 256, 1, 0, 0,
			(1 + mTileX) * 256, (0 - mTileY) * 256, 1, 1, 0,
			(1 + mTileX) * 256, (-1 - mTileY) * 256, 1, 1, 1,
			(0 + mTileX) * 256, (-1 - mTileY) * 256, 1, 0, 1
		];
		
		mVertexBuffer3D = mContext3D.createVertexBuffer(4, 5);
		mVertexBuffer3D.uploadFromVector(vertexBufferData, 0, 4);
		
		var indexBufferData:Vector.<uint> = new <uint>[
			0, 1, 2,
			0, 2, 3
		];
		
		mIndexBuffer3D = mContext3D.createIndexBuffer(6);
		mIndexBuffer3D.uploadFromVector(indexBufferData, 0, 6);
	}
}