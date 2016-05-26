package com.canaan.lib.managers
{
	import com.canaan.lib.core.Config;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.core.ResItem;
	import com.canaan.lib.core.ResLoader;
	import com.canaan.lib.core.VersionData;
	import com.canaan.lib.debug.Log;
	import com.canaan.lib.events.ResEvent;
	import com.canaan.lib.utils.ArrayUtil;
	import com.canaan.lib.utils.DisplayUtil;
	import com.canaan.lib.utils.ObjectUtil;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	[Event(name="startLoad", type="com.canaan.lib.events.ResEvent")]
	[Event(name="complete", type="com.canaan.lib.events.ResEvent")]
	[Event(name="progress", type="com.canaan.lib.events.ResEvent")]
	
	public class ResManager extends EventDispatcher
	{
		public static var imageExtensions:Array = ["jpg", "png"];
		
		private static var canInstantiate:Boolean;
		private static var instance:ResManager;
		
		private var bmdCache:Dictionary = new Dictionary();
		private var tilesCache:Dictionary = new Dictionary();
//		private var actionCache:Dictionary = new Dictionary();
		private var loadList:Dictionary = new Dictionary();
		private var resItems:Dictionary = new Dictionary();
		private var _maxLoader:int = 3;
		private var _loaderCount:int = 0;
		private var _maxPriority:int = 5;
		
		public function ResManager()
		{
			if (!canInstantiate) {
				throw new Error("Can not instantiate, use getInstance() instead.");
			}
			for (var i:int = 0; i < _maxPriority; i++) {
				loadList[i] = [];
			}
		}
		
		public static function getInstance():ResManager {
			if (instance == null) {
				canInstantiate = true;
				instance = new ResManager();
				canInstantiate = false;
			}
			return instance;
		}
		
		public function getResItem(url:String):ResItem {
			return resItems[url];
		}
		
		public function load(url:String, id:String = "", name:String = "", completeHandler:Method = null, progressHandler:Method = null, cacheContent:Boolean = true, priority:int = 1):void {
			var resItem:ResItem = new ResItem();
			resItem.url = url;
			resItem.id = id;
			resItem.name = name;
			if (completeHandler != null) {
				resItem.completeHandlers.push(completeHandler);
			}
			if (progressHandler != null) {
				resItem.progressHandlers.push(progressHandler);
			}
			resItem.cacheContent = cacheContent;
			resItem.priority = priority;
			loadItem(resItem);
		}
		
		public function unload(url:String):void {
			var item:ResItem = resItems[url];
			if (item != null) {
				delete resItems[url];
				ArrayUtil.removeElements(loadList[item.priority], item);
			}
		}
		
		public function removeResItemCompleteHandler(url:String, handler:Method):void {
			var item:ResItem = resItems[url];
			if (item != null) {
				item.removeCompleteHandler(handler);
				if (item.completeHandlers.length == 0) {
					delete resItems[url];
					ArrayUtil.removeElements(loadList[item.priority], item);
				}
			}
		}
		
		public function loadItem(resItem:ResItem):void {
			var content:* = ResLoader.getRes(resItem.id);
			if (content != null) {
				endLoad(resItem, content);
			} else {
				var item:ResItem = resItems[resItem.url];
				if (item == null) {
					resItems[resItem.url] = resItem;
					loadList[resItem.priority].push(resItem);
					loadNext();
				} else {
					if (item.priority < resItem.priority) {
						item.priority = resItem.priority;
					}
					item.completeHandlers = item.completeHandlers.concat(resItem.completeHandlers);
					item.progressHandlers = item.progressHandlers.concat(resItem.progressHandlers);
				}
			}
		}
		
		public function loadAssets(resItems:Vector.<ResItem>, completeHandler:Method = null, progressHandler:Method = null, dispatch:Boolean = true):void {
			if (resItems == null || resItems.length == 0) {
				if (completeHandler != null) {
					completeHandler.apply();
				}
				return;
			}
			if (dispatch && hasEventListener(ResEvent.START_LOAD)) {
				dispatchEvent(new ResEvent(ResEvent.START_LOAD, resItems));
			}
			var itemsTotal:int = resItems.length;
			var itemsLoaded:Number = 0;
			for each (var resItem:ResItem in resItems) {
				resItem.bytesLoaded = 0;
				load(resItem.url, resItem.id, resItem.name, new Method(loadAssetsComplete, [resItem]), new Method(loadAssetsProgress, [resItem]), resItem.cacheContent, resItem.priority);
				
				function loadAssetsComplete(item:ResItem, content:*):void {
					itemsLoaded++;
					if (itemsLoaded == itemsTotal) {
						if (completeHandler != null) {
							completeHandler.apply();
						}
						if (dispatch && hasEventListener(ResEvent.COMPLETE)) {
							dispatchEvent(new ResEvent(ResEvent.COMPLETE, resItems));
						}
					}
				}
				
				function loadAssetsProgress(item:ResItem, bytesLoaded:int, bytesTotal:int):void {
					item.bytesLoaded = bytesLoaded;
					item.bytesTotal = bytesTotal;
					var progressTotal:Number = 0;
					for each (var itemObj:ResItem in resItems) {
						progressTotal += itemObj.progress;
					}
					var percent:Number = progressTotal / itemsTotal;
					if (progressHandler != null) {
						progressHandler.applyWith([percent]);
					}
					if (dispatch && hasEventListener(ResEvent.PROGRESS)) {
						dispatchEvent(new ResEvent(ResEvent.PROGRESS, {percent:percent, item:item}));
					}
				}
			}
		}
		
		private function loadNext():void {
			if (_loaderCount >= _maxLoader) {
				return;
			}
			for (var i:int = 0; i < _maxPriority; i++) {
				var resItems:Array = loadList[i];
				while (resItems.length > 0) {
					var resItem:ResItem = resItems.shift();
					var content:* = getContent(resItem.id);
					if (content != null) {
						endLoad(resItem, content);
					} else {
						startLoad(resItem);
						return;
					}
				}
			}
			if (hasEventListener(ResEvent.COMPLETE)) {
				dispatchEvent(new ResEvent(ResEvent.COMPLETE));
			}
		}
		
		private function startLoad(resItem:ResItem):void {
			_loaderCount++;
			var resLoader:ResLoader = ResLoader.fromPool();
			resLoader.load(resItem.url, resItem.id, new Method(loadComplete, [resItem, resLoader]), new Method(loadProgress, [resItem]), new Method(loadError, [resItem]), resItem.cacheContent);
		}
		
		private function endLoad(resItem:ResItem, content:*):void {
			for each (var method:Method in resItem.completeHandlers) {
				method.applyWith([content]);
			}
			delete resItems[resItem.url];
		}
		
		private function loadComplete(resItem:ResItem, resLoader:ResLoader, content:*):void {
			if (resLoader.fileType == ResLoader.FILE_TYPE_ACTION && resLoader.cacheContent == false && resItem.completeHandlers.length == 0) {
				removeAction(resItem.url);
				removeActionLoader(resItem.url);
				delete resItems[resItem.url];
			} else {
				endLoad(resItem, content);
			}
			ResLoader.toPool(resLoader);
			_loaderCount--;
			loadNext();
		}
		
		private function loadProgress(resItem:ResItem, bytesLoaded:int, bytesTotal:int):void {
			for each (var method:Method in resItem.progressHandlers) {
				method.applyWith([bytesLoaded, bytesTotal]);
			}
		}
		
		private function loadError(resItem:ResItem):void {
			_loaderCount--;
			loadNext();
		}
		
		public function get maxLoader():int {
			return _maxLoader;
		}
		
		public function set maxLoader(value:int):void {
			_maxLoader = value;
		}
		
		public function hasClass(name:String):Boolean {
			return ApplicationDomain.currentDomain.hasDefinition(name);
		}
		
		public function getClass(name:String):Class {
			if (ApplicationDomain.currentDomain.hasDefinition(name)) {
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
			ResLoader.removeRes(id, false);
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
		
		public function getActionBitmapData(id:String, name:String):BitmapData {
			var childLoader:Loader = ResLoader.getActionLoader(id);
			if (childLoader != null) {
				var bmdClass:Class = childLoader.contentLoaderInfo.applicationDomain.getDefinition(name) as Class;
				if (bmdClass == null) {
					return null;
				}
				return new bmdClass(0, 0);
			}
			return null;
//			var actionDict:Dictionary = actionCache[id];
//			if (actionDict == null) {
//				actionCache[id] = actionDict = new Dictionary();
//			}
//			var bmd:BitmapData = actionDict[name];
//			if (bmd == null) {
//				var childLoader:Loader = ResLoader.getActionLoader(id);
//				if (childLoader != null) {
//					var bmdClass:Class = childLoader.contentLoaderInfo.applicationDomain.getDefinition(name) as Class;
//					if (bmdClass == null) {
//						return null;
//					}
//					bmd = new bmdClass(0, 0);
//					actionDict[name] = bmd;
//				}
//			}
//			return bmd;
		}
		
		public function removeAllActionLoaders():void {
			ResLoader.removeAllActionLoaders();
		}
		
		public function removeActionLoader(id:String):void {
			ResLoader.removeActionLoader(id);
		}
		
		public function removeAction(id:String):void {
			ResLoader.removeRes(id);
//			var actionDict:Dictionary = actionCache[id];
//			if (actionDict != null) {
//				var bmd:BitmapData;
//				for (var skin:String in actionDict) {
//					bmd = actionDict[skin];
//					bmd.dispose();
//					bmd = null;
//					delete actionDict[skin];
//				}
//			}
//			delete actionCache[id];
		}
		
		public function clearAllBmdCache():void {
			for each (var bmd:BitmapData in bmdCache) {
				bmd.dispose();
			}
			bmdCache = new Dictionary();
		}
		
		public function clearAllActionCache():void {
			for each (var actionDict:Dictionary in bmdCache) {
				for each (var bmd:BitmapData in actionDict) {
					bmd.dispose();
				}
			}
			bmdCache = new Dictionary();
		}
		
		public function cacheBmd(name:String, bmp:BitmapData):void {
			bmdCache[name] = bmp;
		}
		
		public function clearBmdCache(name:String):void {
			var bmp:BitmapData = bmdCache[name];
			if (bmp != null) {
				delete bmdCache[name];
				bmp.dispose();
			}
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
			var realUrl:String = url;
//			if (url.indexOf("http") == -1) {
				var resHost:String = Config.getConfig("resHost");
				if (resHost != null) {
					realUrl = resHost + url;
				}
//			}
//			if (url.indexOf("version") == -1) {
//				var version:String = VersionData.getVersion(url) || Config.getConfig("version");
//				if (version != null) {
//					realUrl += "?version=" + version;
//				}
//			}
			var version:String = VersionData.getVersion(url);
			if (version != null) {
				var flagIndex:int = realUrl.lastIndexOf(".");
				realUrl = realUrl.substring(0, flagIndex) + "_" + version + realUrl.substring(flagIndex);
			}
			var v:String = Config.getConfig("version");
			if (v) {
				realUrl += "?v=" + v;
			}
			return realUrl;
		}
		
		public static function formatExternalImageUrl(url:String):String {
			for each (var extension:String in imageExtensions) {
				var flag:String = extension + ".";
				var flagIndex:int = url.lastIndexOf(flag);
				if (flagIndex != -1) {
//					var preUrl:String = url.substring(0, flagIndex);
//					var imageName:String = url.substring(flagIndex + flag.length);
//					var realPath:String = Config.getConfig("assetsRoot") + preUrl + imageName.split(".").join("/") + "." + extension;
					var imageName:String = url.substring(flagIndex + flag.length);
					var realPath:String = Config.getConfig("assetsRoot") + imageName.split(".").join("/") + "." + extension;
					return realPath;
				}
			}
			return url;
		}
		
		public static function formatExternalSwfUrl(url:String):String {
			return Config.getConfig("externalSwf") + url + ".swf";
		}
	}
}