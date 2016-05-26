package com.canaan.lib.managers
{
	import com.canaan.lib.core.Config;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.core.Methods;
	import com.canaan.lib.core.ResItem;
	import com.canaan.lib.core.ResLoader;
	import com.canaan.lib.debug.Log;
	import com.canaan.lib.events.ResEvent;
	import com.canaan.lib.utils.DisplayUtil;
	import com.canaan.lib.utils.MathUtil;
	import com.canaan.lib.utils.ObjectUtil;
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	[Event(name="startLoad", type="com.canaan.lib.events.ResEvent")]
	[Event(name="complete", type="com.canaan.lib.events.ResEvent")]
	[Event(name="progress", type="com.canaan.lib.events.ResEvent")]
	
	public class ResManager extends EventDispatcher
	{
		private static var canInstantiate:Boolean;
		private static var instance:ResManager;
		
		private var bmdCache:Dictionary = new Dictionary();
		private var tilesCache:Dictionary = new Dictionary();
		private var asyncCallbackCache:Dictionary = new Dictionary();
		private var loadList:Vector.<ResItem> = new Vector.<ResItem>();
		private var completeHandlers:Methods = new Methods();
		private var progressHandlers:Methods = new Methods();
		private var loaderSync:ResLoader;
		private var _isLoading:Boolean;
		private var _itemsTotal:int;
		private var _itemsLoaded:int;
		private var _current:ResItem;
		
		public function ResManager()
		{
			if (!canInstantiate) {
				throw new Error("Can not instantiate, use getInstance() instead.");
			}
			loaderSync = ResLoader.fromPool();
		}
		
		public static function getInstance():ResManager {
			if (instance == null) {
				canInstantiate = true;
				instance = new ResManager();
				canInstantiate = false;
			}
			return instance;
		}
		
		public function add(url:String, id:String = "", name:String = "", completeHandler:Method = null, progressHandler:Method = null):void {
			var resItem:ResItem = new ResItem(url, id, name, completeHandler, progressHandler);
			addItem(resItem);
		}
		
		public function addItem(resItem:ResItem):void {
			loadList.push(resItem);
			_itemsTotal++;
		}
		
		public function addList(loadList:Vector.<ResItem>):void {
			for each (var resItem:ResItem in loadList) {
				addItem(resItem);			  
			}
		}
		
		public function loadAsync(url:String, id:String = "", name:String = "", completeHandler:Method = null, progressHandler:Method = null):void {
			var resItem:ResItem = new ResItem(url, id, name, completeHandler, progressHandler);
			loadAsyncItem(resItem);
		}
		
		public function loadAsyncItem(resItem:ResItem):void {
			var content:* = ResLoader.getRes(resItem.id);
			if (content != null) {
				if (resItem.completeHandler != null) {
					resItem.completeHandler.applyWith([content]);
				}
			} else {
				var asyncCallbacks:Vector.<ResItem> = asyncCallbackCache[resItem.url];
				if (asyncCallbacks == null) {
					asyncCallbackCache[resItem.url] = asyncCallbacks = new Vector.<ResItem>();
					var loaderAsync:ResLoader = ResLoader.fromPool();
					loaderAsync.load(resItem.url, resItem.id, new Method(onCompleteAsync, [resItem, loaderAsync]), new Method(onProgressAsync, [resItem]));
				}
				asyncCallbacks.push(resItem);
			}
		}
		
		private function onCompleteAsync(resItem:ResItem, loaderAsync:ResLoader, content:*):void {
			for each (var item:ResItem in asyncCallbackCache[resItem.url]) {
				var completeHandler:Method = item.completeHandler;
				if (completeHandler != null) {
					completeHandler.applyWith([content]);
				}
			}
			ResLoader.toPool(loaderAsync);
			delete asyncCallbackCache[resItem.url];
		}
		
		private function onProgressAsync(resItem:ResItem, percent:Number):void {
			for each (var item:ResItem in asyncCallbackCache[resItem.url]) {
				var progressHandler:Method = item.progressHandler;
				if (progressHandler != null) {
					progressHandler.applyWith([percent]);
				}
			}
		}
		
		public function load(completeHandler:Method = null, progressHandler:Method = null):void {
			if (completeHandler != null) {
				completeHandlers.registerMethod(completeHandler);
			}
			if (progressHandler != null) {
				progressHandlers.registerMethod(progressHandler);
			}
			if (_isLoading) {
				return;
			}
			_isLoading = true;
			dispatchEvent(new ResEvent(ResEvent.START_LOAD));
			loadNext();
		}
		
		private function loadNext():void {
			var resItem:ResItem;
			var content:*;
			while (loadList.length > 0) {
				resItem = loadList.shift();
				content = ResLoader.getRes(resItem.id);
				if (content != null) {
					endLoad(resItem, content);
				} else {
					startLoad(resItem);
					return;
				}
			}
			_isLoading = false;
			_itemsTotal = 0;
			_itemsLoaded = 0;
			_current = null;
			if (hasEventListener(ResEvent.COMPLETE)) {
				dispatchEvent(new ResEvent(ResEvent.COMPLETE));
			}
			excuteComplete();
		}
		
		private function startLoad(resItem:ResItem):void {
			_current = resItem;
			loaderSync.load(resItem.url, resItem.id, new Method(onComplete, [resItem]), new Method(onProgress, [resItem]));
		}
		
		private function endLoad(resItem:ResItem, content:*):void {
			var completeHandler:Method = resItem.completeHandler;
			if (completeHandler != null) {
				completeHandler.applyWith([content]);
			}
			_itemsLoaded++;
		}
		
		private function onComplete(resItem:ResItem, content:*):void {
			endLoad(resItem, content);
			loadNext();
		}
		
		private function onProgress(resItem:ResItem, percent:Number):void {
			var progressHandler:Method = resItem.progressHandler;
			if (progressHandler != null) {
				progressHandler.applyWith([percent]);
			}
			progressHandlers.apply();
			if (hasEventListener(ResEvent.PROGRESS)) {
				dispatchEvent(new ResEvent(ResEvent.PROGRESS));
			}
		}
		
		private function excuteComplete():void {
			progressHandlers.clear();
			var methods:Methods = completeHandlers.clone();
			completeHandlers.clear();
			methods.apply();
		}
		
		public function get isLoading():Boolean {
			return _isLoading;
		}
		
		public function get itemsTotal():int {
			return _itemsTotal;
		}
		
		public function get itemsLoaded():int {
			return _itemsLoaded;
		}
		
		public function get percentLoaded():Number {
			return MathUtil.floorFixed(_itemsLoaded / _itemsTotal, 2);
		}
		
		public function get bytesLoadedCurrent():int {
			return loaderSync.bytesLoaded;
		}
		
		public function get bytesTotalCurrent():int {
			return loaderSync.bytesTotal;
		}
		
		public function get percentCurrent():Number {
			return loaderSync.percentLoaded;
		}
		
		public function get current():ResItem {
			return _current;
		}
		
		public function hasClass(name:String):Boolean {
			return ApplicationDomain.currentDomain.hasDefinition(name);
		}
		
		public function getClass(name:String):Class {
			if (hasClass(name)) {
				return ApplicationDomain.currentDomain.getDefinition(name) as Class;
			}
			Log.getInstance().error("ResManager getClass error: Class \"" + name + "\" is not found!");
			return null;
		}
		
		public function hasContent(id:String):Boolean {
			return ResLoader.hasRes(id);
		}
		
		public function getContent(id:String):* {
			return ResLoader.getRes(id);
		}
		
		public function setContent(id:String, content:*):void {
			ResLoader.setRes(id, content);
		}
		
		public function removeContent(id:String):void {
			ResLoader.removeRes(id);
		}
		
		public function getNewInstance(name:String):* {
			var clazz:Class = getClass(name);
			if (clazz != null) {
				return new clazz();
			}
			return null;
		}
		
		public function getBitmapData(name:String):BitmapData {
			var bmd:BitmapData = bmdCache[name];
			if (bmd == null) {
				var bmdClass:Class = getClass(name);
				if (bmdClass == null) {
					return null;
				}
				bmd = new bmdClass(0, 0);
				bmdCache[name] = bmd;
			}
			return bmd;
		}
		
		public function getTiles(name:String, x:int, y:int, cache:Boolean = true):Vector.<BitmapData> {
			var tiles:Vector.<BitmapData> = tilesCache[name];
			if (tiles == null) {
				var bmd:BitmapData = getBitmapData(name);
				if (bmd == null) {
					return null;
				}
				tiles = DisplayUtil.createTiles(bmd, x, y);
				if (cache) {
					tilesCache[name] = tiles;
				}
			}
			return tiles;
		}
		
		public function clearAllBmdCache():void {
			ObjectUtil.dispose(bmdCache);
		}
		
		public function cacheBmd(name:String, bmp:BitmapData):void {
			bmdCache[name] = bmp;
		}
		
		public function clearBmdCache(name:String):void {
			delete bmdCache[name];
		}
		
		public function clearAllTilesCache():void {
			ObjectUtil.dispose(tilesCache);
		}
		
		public function cacheTiles(name:String, tiles:Vector.<BitmapData>):void {
			tilesCache[name] = tiles;
		}
		
		public function clearTilesCache(name:String):void {
			delete tilesCache[name];
		}
		
		public static function formatUrl(url:String):String {
			if (url.indexOf("http") == -1) {
				var resHost:String = Config.getConfig("resHost");
				if (resHost != null) {
					url = resHost + url;
				}
			}
			if (url.indexOf("version") == -1) {
				var version:String = Config.getConfig("version");
				if (version != null) {
					url += "?version=" + version;
				}
			}
			return url;
		}
	}
}