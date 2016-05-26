package com.canaan.lib.core
{
	import com.canaan.lib.debug.Log;
	import com.canaan.lib.interfaces.IPoolableObject;
	import com.canaan.lib.managers.ResManager;
	import com.canaan.lib.role.utils.ActionUtil;
	import com.canaan.lib.utils.MathUtil;
	import com.canaan.lib.utils.ObjectUtil;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class ResLoader extends EventDispatcher implements IPoolableObject
	{
		public static const FILE_TYPE_SWF:uint = 0;
		public static const FILE_TYPE_IMAGE:uint = 1;
		public static const FILE_TYPE_TEXT:uint = 2;
		public static const FILE_TYPE_BINARY:uint = 3;
		public static const FILE_TYPE_ACTION:uint = 4;
		
		public static var SWF_EXTENSIONS:Array = ["swf"];
		public static var IMAGE_EXTENSIONS:Array = ["jpg", "jpeg", "gif", "png", "bmp"];
		public static var TEXT_EXTENSIONS:Array = ["txt", "xml", "csv"];
		public static var BINARY_EXTENSIONS:Array = ["byte", "mapdata"];
		public static var ACTION_EXTENSIONS:Array = ["action"];
		
		private static var cache:Dictionary = new Dictionary();
		private var loader:Loader;
		private var urlRequest:URLRequest;
		private var urlLoader:URLLoader;
		private var loaderContext:LoaderContext;
		
		private var _url:String;
		private var _id:String;
		private var _fileType:uint;
		private var _completeHandler:Method;
		private var _progressHandler:Method;
		private var _bytesLoaded:int;
		private var _bytesTotal:int;
		
		public function ResLoader()
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
			
			urlLoader = new URLLoader();
			urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatus);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			
			urlRequest = new URLRequest();
			loaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			if (loaderContext.hasOwnProperty("imageDecodingPolicy")) {
				loaderContext["imageDecodingPolicy"] = "onLoad";
			}
		}
		
		public function poolInitialize(data:Object = null):void {
			
		}
		
		public function poolDestory():void {
			loader.unloadAndStop();
			_url = null;
			_id = null;
			_fileType = 0;
			_completeHandler = null;
			_progressHandler = null;
			_bytesLoaded = 0;
			_bytesTotal = 0;
		}
		
		public function load(url:String, id:String, completeHandler:Method, progressHandler:Method):void {
			loader.unloadAndStop();
			_url = url;
			_id = id;
			_fileType = getFileType(url);
			_completeHandler = completeHandler;
			_progressHandler = progressHandler;
			
			var content:* = getRes(_url);
			if (content != null) {
				return endLoad(content);
			}
			
			_bytesLoaded = 0;
			_bytesTotal = 0;
			startLoad();
		}
		
		private function endLoad(content:*):void {
			_completeHandler.applyWith([content]);
		}
		
		private function startLoad():void {
			urlRequest.url = ResManager.formatUrl(_url);
			switch (_fileType) {
				case FILE_TYPE_SWF:
				case FILE_TYPE_IMAGE:
					loader.load(urlRequest, loaderContext);
					break;
				case FILE_TYPE_TEXT:
					urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
					urlLoader.load(urlRequest);
					break;
				case FILE_TYPE_BINARY:
				case FILE_TYPE_ACTION:
					urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
					urlLoader.load(urlRequest);
					break;
			}
		}
		
		public function get bytesLoaded():int {
			return _bytesLoaded;
		}
		
		public function get bytesTotal():int {
			return _bytesTotal;
		}
		
		public function get percentLoaded():Number {
			return MathUtil.floorFixed(bytesLoaded / bytesTotal, 2);
		}
		
		private function onComplete(event:Event):void {
			var content:*;
			switch (_fileType) {
				case FILE_TYPE_SWF:
					content = loader.content;
					break;
				case FILE_TYPE_IMAGE:
					content = Bitmap(loader.content).bitmapData;
					break;
				case FILE_TYPE_TEXT:
					content = urlLoader.data;
					break;
				case FILE_TYPE_BINARY:
				case FILE_TYPE_ACTION:
					var bytes:ByteArray = urlLoader.data as ByteArray;
					bytes.uncompress();
					if (_fileType == FILE_TYPE_BINARY) {
						content = bytes.readObject();
					}
					if (_fileType == FILE_TYPE_ACTION) {
						content = ActionUtil.analysis(bytes);
						var bytesLoader:BytesLoader = new BytesLoader();
						bytesLoader.load(content.swfBytes, new Method(function():void {
							endLoad(cache[_id] = content.headData);
						}), true);
						return;
					}
					break;
			}
			endLoad(cache[_id] = content);
		}
		
		private function onProgress(event:ProgressEvent):void {
			_bytesTotal = event.bytesTotal;
			_bytesLoaded = event.bytesLoaded;
			_progressHandler.applyWith([percentLoaded]);
		}
		
		private function onError(event:Event):void {
			Log.getInstance().error("ResLoader Load Error:\"" + _url + "\"");
		}
		
		private function onStatus(event:HTTPStatusEvent):void {
			
		}
		
		public static function getFileType(url:String):uint {
			var index:int = url.indexOf("?");
			if (index != -1) {
				url = url.substring(0, index);
			}
			url = url.substring(url.lastIndexOf(".") + 1).toLowerCase();
			if (SWF_EXTENSIONS.indexOf(url) != -1) {
				return FILE_TYPE_SWF;
			} else if (IMAGE_EXTENSIONS.indexOf(url) != -1) {
				return FILE_TYPE_IMAGE;
			} else if (TEXT_EXTENSIONS.indexOf(url) != -1) {
				return FILE_TYPE_TEXT;
			} else if (BINARY_EXTENSIONS.indexOf(url) != -1) {
				return FILE_TYPE_BINARY;
			} else if (ACTION_EXTENSIONS.indexOf(url) != -1) {
				return FILE_TYPE_ACTION;
			}
			Log.getInstance().error("ResLoader getFileType Error:Could not find fileType \"" + url + "\"");
			return FILE_TYPE_TEXT;
		}
		
		public static function hasRes(id:String):Boolean {
			return cache.hasOwnProperty(id);
		}
		
		public static function getRes(id:String):* {
			return cache[id];
		}
		
		public static function setRes(id:String, content:*):void {
			cache[id] = content;
		}
		
		public static function removeRes(id:String):void {
			delete cache[id];
		}
		
		public static function clearAllCache():void {
			ObjectUtil.dispose(cache);
		}
		
		public static function fromPool():ResLoader {
			return ObjectPool.get(ResLoader) as ResLoader;
		}
		
		public static function toPool(loader:ResLoader):void {
			ObjectPool.put(loader);
		}
	}
}