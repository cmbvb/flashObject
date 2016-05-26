package manager
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class LoaderManager
	{
		private static var _ins:LoaderManager;
		private var mLoader:Loader;
		private var mURLload:URLLoader;
		private var mURLreq:URLRequest;
		private var _mCompleteFunction:Function;
		private var _mArg:Array;
		private var _mURLCompleteFunction:Function;
		
		public function LoaderManager()
		{
			mLoader = new Loader();
			mURLload = new URLLoader();
			mURLreq = new URLRequest();
			mLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
			mURLload.addEventListener(Event.COMPLETE, onURLloadComplete);
		}
		
		public function load(url:String):void {
			mLoader.close();
			mURLreq.url = url;
			mLoader.load(mURLreq);
		}
		
		private function onLoaderComplete(event:Event):void {
			var value:Object = event.target.content;
			if (_mCompleteFunction != null) {
				_mCompleteFunction.apply(null, [value]);
			}
		}
		
		public function urlLoad(url:String, dataFormat:String = null):void {
			mURLload.close();
			mURLreq.url = url;
			mURLload.dataFormat = dataFormat;
			mURLload.load(mURLreq);
		}
		
		public function loadBytes(bytes:ByteArray):void {
			mLoader.loadBytes(bytes);
		}
		
		private function onURLloadComplete(event:Event):void {
			var value:URLLoader = event.target as URLLoader;
			if (_mURLCompleteFunction != null) {
				_mURLCompleteFunction.apply(value, mArg);
			}
		}
		
		public static function get ins():LoaderManager {
			if (_ins == null) {
				_ins = new LoaderManager();
			}
			return _ins;
		}

		public function set mCompleteFunction(value:Function):void
		{
			_mCompleteFunction = value;
		}

		public function set mArg(value:Array):void
		{
			_mArg = value;
		}

		public function set mURLCompleteFunction(value:Function):void
		{
			_mURLCompleteFunction = value;
		}

		
	}
}