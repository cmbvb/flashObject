package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import manager.LayerManager;
	
	import mapTool.MapSetting;
	import mapTool.model.GameModel;
	import mapTool.module.GameModule;
	import mapTool.module.dialogs.SettingDialog;
	
	import morn.core.handlers.Handler;
	
	[SWF(width="1440", height="900", backgroundColor="0x999999")]
	public class mapTool extends Sprite
	{
		private var image:Bitmap;
		private var urlArr:Array = [];
		private var load:Loader;
		private var isDown:Boolean;
		
		public function mapTool()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			stage.nativeWindow.maximize();
			stage.nativeWindow.minSize = new Point(1440, 900);
			
			App.init(this);
			App.loader.loadAssets(["map/assets/ui/comp.swf"], new Handler(onLoaderComplete));
			
//			load = new Loader();
//			image = new Bitmap();
//			image.bitmapData = new BitmapData(39 * 256, 23 * 256);
//			addChild(image);
//			loadTiles1();
//			loadMap();
//			loadTiles3();
//			load.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
//			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
//			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onLoaderComplete():void {
			LayerManager.ins.init();
			GameModel.init();
			GameModule.ins.init();
			if (MapSetting.ins.init()) {
				App.stage.addChild(LayerManager.ins);
			} else {
				App.dialog.popupByClazz(SettingDialog);
			}
			var stats:Stats = new Stats();
			LayerManager.ins.notice.addChild(stats);
		}
		
		private function onKeyDown(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.LEFT) {
				image.x -= 5;
			} else if (event.keyCode == Keyboard.RIGHT) {
				image.x += 5;
			} else if (event.keyCode == Keyboard.UP) {
				image.y -= 5;
			} else if (event.keyCode == Keyboard.DOWN) {
				image.y += 5;
			}
		}
		
		private function onMouseDown(evnt:MouseEvent):void {
			isDown = true;
		}
		
		private function onMouseUp(evnt:MouseEvent):void {
			isDown = false;
		}
		
		private function onMouseMove(event:MouseEvent):void {
			if (isDown) {
				image.x = mouseX;
				image.y = mouseY;
			}
			
		}
		
		private function loadMap():void {
			var url:URLRequest = new URLRequest("shameng/shameng.jpg");
			urlArr.push({u:url, x:0, y:0});
			startLoad();
		}
		
		private function loadTiles1():void {
			
			for (var i:int = 0; i < 24; i++) {
				for (var j:int = 0; j < 40; j++) {
					var url:URLRequest = new URLRequest("shameng/" + i + "_" + j + ".jpg");
					urlArr.push({u:url, x:i, y:j});
				}
			}
			startLoad();
		}
		
		private var obj:Object;
		private function startLoad():void {
			if (urlArr.length > 0) {
				obj = urlArr.shift();
				load.load(obj.u);
			} else {
				trace("complete");
				var f:File = new File();
				var fs:FileStream = new FileStream();
				f.cancel();
				f.nativePath = new File(File.applicationDirectory.nativePath).resolvePath("shameng/shameng.jpg").nativePath;
				fs.close();
				fs.open(f, FileMode.WRITE);
				fs.position = 0;
				var byt:ByteArray = new ByteArray();
				image.bitmapData.encode(image.bitmapData.rect, new JPEGEncoderOptions(), byt);
				fs.writeBytes(byt);
				fs.close();
			}
		}
		
		private function onComplete(event:Event):void {
			var bmp:BitmapData = event.target.content.bitmapData as BitmapData;
			trace(getTimer());
			image.bitmapData.copyPixels(bmp, bmp.rect, new Point(obj.y * 256, obj.x * 256), null, null, false);
//			image.bitmapData.draw(event.target.content.bitmapData, new Matrix(1, 0, 0, 1, obj.y * 256, obj.x * 256));
			trace(getTimer());
			startLoad();
		}
		
		private function loadTiles2():void {
			var load:URLLoader = new URLLoader();
			var url:URLRequest = new URLRequest("shameng/0_0.jpg");
			load.dataFormat = URLLoaderDataFormat.BINARY;
			load.load(url);
			load.addEventListener(Event.COMPLETE, onComplete2);
		}
		
		private var streamer:URLStream;
		private function loadTiles3():void {
			streamer = new URLStream();
			var url:URLRequest = new URLRequest("shameng/0_0.jpg");
			streamer.load(url);
			streamer.addEventListener(ProgressEvent.PROGRESS, onComplete3);
		}
		
		private function onComplete1(event:Event):void {
			var data:Object = event.target.content.bitmapData;
			image.bitmapData = data as BitmapData;
		}
		
		private function onComplete2(event:Event):void {
			var data:URLLoader = event.target as URLLoader;
			var load:Loader = new Loader();
			var bty:ByteArray = data.data;
			bty.position = 0;
			load.loadBytes(bty);
			addChild(load);
			image.bitmapData.draw(load);
		}
		
		private function onComplete3(event:ProgressEvent):void {
//			var data:Object = event.target.content.bitmapData;
//			image.bitmapData = data as BitmapData;
			
//			var load:Loader = new Loader();
//			var bty:ByteArray = streamer. readByte();
//			bty.position = 0;
//			load.loadBytes(bty);
//			addChild(load);
//			image.bitmapData.draw(load);
		}
		
	}
}