package com.canaan.lib.core
{
	import com.canaan.lib.debug.Log;
	import com.canaan.lib.interfaces.IPoolableObject;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	public class BytesLoader implements IPoolableObject
	{
		private static var mPool:Vector.<BytesLoader> = new Vector.<BytesLoader>();
		
		public var loader:Loader;
		public var loaderContext:LoaderContext;
		public var completeHandler:Method;
		
		public function BytesLoader()
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onError);
			
			loaderContext = new LoaderContext();
			loaderContext.allowCodeImport = true;
			loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
		}
		
		public function poolInitialize(data:Object = null):void {
			
		}
		
		public function poolDestory():void {
			loader.unload();
			loader.unloadAndStop(false);
			completeHandler = null;
		}
		
		public function load(bytes:ByteArray, completeHandler:Method):void {
			this.completeHandler = completeHandler;
			loader.loadBytes(bytes, loaderContext);
		}
		
		private function onComplete(event:Event):void {
			var content:DisplayObject = LoaderInfo(event.target).content;
			if (completeHandler != null) {
				completeHandler.applyWith([content]);
			}
		}
		
		private function onError(event:Event):void {
			Log.getInstance().error("BytesLoader load Error.");
		}
		
		public function dispose():void {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onError);
			loader.unloadAndStop(false);
			loader = null;
			loaderContext = null;
			completeHandler = null;
		}
		
		public static function fromPool():BytesLoader {
			return mPool.length != 0 ? mPool.pop() : new BytesLoader();
		}
		
		public static function toPool(loader:BytesLoader):void {
			loader.poolDestory();
			mPool.push(loader);
		}
	}
}