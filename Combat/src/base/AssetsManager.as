package base
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import enumeration.EnumEvent;

	public class AssetsManager
	{
		private static var _ins:AssetsManager;		
		private var loader:Loader = new Loader();							// 加载者
		private var assetsDic:Dictionary = new Dictionary();				// 资源字典
		private var loaderArr:Vector.<URLRequest> = new <URLRequest>[];		// 加载队列 
		
		public function AssetsManager()
		{
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
		}
		
		public static function get ins():AssetsManager {
			if (_ins == null) {
				_ins = new AssetsManager();
			}
			return _ins
		}
		
		private function onProgress(event:ProgressEvent):void {
			
		}
		
		private function onComplete(event:Event):void {
			var data:* = event.target.loader.content;
			var url:String = loader.contentLoaderInfo.url;
			if (assetsDic[url] == null) {
				assetsDic[url] = data;
			} else {
				throw new Error("has same name! as " +　url);
			}
			startLoad();
		}
		
		public function addAssetsUrlReq(str:String):void {
			loaderArr.push(new URLRequest(str));
		}
		
		public function startLoad():void {
			if (loaderArr.length > 0) {
				var url:URLRequest = loaderArr.shift();
				loader.load(url);
			} else {
				EventManager.ins.dispatchEvent(new EnumEvent(EnumEvent.ASSETS_LOAD_COMPLETE));
				trace("assets complete!");
			}
		}
		
		public function getAssets(key:String):* {
			return assetsDic[key];
		}
		
	}
}