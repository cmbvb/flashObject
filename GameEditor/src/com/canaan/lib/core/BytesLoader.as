package com.canaan.lib.core
{
	import com.canaan.lib.debug.Log;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	public class BytesLoader
	{
		private var loader:Loader;
		private var loaderContext:LoaderContext;
		private var completeHandler:Method;
		private var autoDispose:Boolean;
		
		public function BytesLoader()
		{
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onError);
			
			loaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			loaderContext.allowCodeImport = true;
		}
		
		public function load(bytes:ByteArray, completeHandler:Method, autoDispose:Boolean = false):void {
			this.completeHandler = completeHandler;
			this.autoDispose = autoDispose;
			loader.unloadAndStop();
			loader.loadBytes(bytes, loaderContext);
		}
		
		private function onComplete(event:Event):void {
			var content:DisplayObject = LoaderInfo(event.target).content;
			loader.unloadAndStop();
			if (completeHandler != null) {
				completeHandler.applyWith([content]);
			}
			if (autoDispose) {
				dispose();
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
			loader = null;
			loaderContext = null;
			completeHandler = null;
		}
	}
}