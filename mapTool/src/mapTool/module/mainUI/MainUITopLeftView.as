package mapTool.module.mainUI
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import manager.EventManager;
	import manager.FileHelper;
	import manager.FileManager;
	import manager.LoaderManager;
	
	import mapTool.MapSetting;
	import mapTool.model.GameModel;
	import mapTool.module.GameModule;
	import mapTool.module.dialogs.SettingDialog;
	import mapTool.module.enum.TypeEvent;
	
	import morn.core.handlers.Handler;
	
	import uiCreate.mainUI.MainUITopLeftViewUI;
	
	public class MainUITopLeftView extends MainUITopLeftViewUI
	{
		private var f:FileReference = new FileReference();
		
		public function MainUITopLeftView()
		{
			super();
		}
		
		override protected function initialize():void {
			btnSet.clickHandler = new Handler(onBtnSet);
			btnOpen.clickHandler = new Handler(onBtnOpen);
			btnSave.clickHandler = new Handler(onBtnSave);
			btnPublish.clickHandler = new Handler(onBtnPublish);
			btnShowGrid.clickHandler = new Handler(onBtnShowGrid);
			btnCutDown.clickHandler = new Handler(onBtnCutDown);
			LoaderManager.ins.mCompleteFunction = onLoadComplete;
			
			EventManager.ins.addEventListener(TypeEvent.FILE_SELECT, onFileSelect);
		}
		
		private function onBtnCutDown():void {
			var i:int;
			var j:int;
			var bit:BitmapData = GameModule.ins.moduleMainUI.mapView.imgMap.bitmapData;
			if (bit == null) {
				return;
			}
			var row:int = Math.ceil(bit.width / 256);
			var col:int = Math.ceil(bit.height / 256);
			var f:File;
			var fs:FileStream;
			var byt:ByteArray;
			for (i = 0; i < col; i++) {
				for (j = 0; j < row; j++) {
					f = new File();
					fs = new FileStream();
					f.cancel();
					f.nativePath = new File(File.applicationDirectory.nativePath).resolvePath("map/assets/mapTile/shameng/" + i + "_" + j + ".jpg").nativePath;
					fs.close();
					fs.open(f, FileMode.WRITE);
					fs.position = 0;
					var title:BitmapData = new BitmapData(256, 256);
					title.copyPixels(bit, new Rectangle(j * 256, i * 256, 256, 256), new Point(0, 0));
					byt = new ByteArray();
					title.encode(title.rect, new JPEGEncoderOptions(), byt);
					fs.writeBytes(byt);
					fs.close();
				}
			}
			f = new File();
			fs = new FileStream();
			f.cancel();
			f.nativePath = new File(File.applicationDirectory.nativePath).resolvePath("map/assets/mapTile/shameng/miniMap.jpg").nativePath;
			fs.close();
			fs.open(f, FileMode.WRITE);
			fs.position = 0;
			var miniMap:BitmapData = new BitmapData(600, 400);
			miniMap.draw(bit, new Matrix(miniMap.width / bit.width, 0, 0, miniMap.height / bit.height, 0, 0));
			byt = new ByteArray();
			miniMap.encode(miniMap.rect, new JPEGEncoderOptions(), byt);
			fs.writeBytes(byt);
			fs.close();
		}
		
		private function onFileSelect(event:TypeEvent):void {
			var file:File = event.data as File;
			var urlArr:Array = file.nativePath.split(".");
			urlArr[urlArr.length - 1] = "mpd";
			var url:String = urlArr.join(".");
			var f:File = new File(url);
			if (f.exists) {
				var bytes:ByteArray = new ByteArray();
				bytes = FileHelper.read(url);
				var obj:Object = bytes.readObject();
				GameModel.modelMap.mapDataVo.setData(obj.mapVo);
				GameModel.modelMap.loaderDic = obj.mapGrid;
			}
			var arr:Array = file.name.split(".");
			GameModel.modelMap.mapDataVo.name = arr[0];
		}
		
		private function onLoadComplete(content:*):void {
			GameModel.modelMap.mapDataVo.mapWidth = (content as Bitmap).bitmapData.width;
			GameModel.modelMap.mapDataVo.mapHeight = (content as Bitmap).bitmapData.height;
			GameModule.ins.moduleMainUI.showMap((content as Bitmap).bitmapData);
		}
		
		private function onBtnShowGrid():void {
			GameModule.ins.moduleMainUI.showGrid();
		}
		
		private function onBtnSet():void {
			App.dialog.popupByClazz(SettingDialog);
		}
		
		private function onBtnOpen():void {
			FileManager.ins.open();
		}
		
		private function onBtnSave():void {
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject({mapVo:GameModel.modelMap.mapDataVo, mapGrid:GameModel.modelMap.mapObjArr});
			var f:File = new File();
			if (MapSetting.clientDataSavePath) {
				f.nativePath = MapSetting.clientDataSavePath;
			}
			if (MapSetting.clientDataSavePath && f.exists) {
				var url:String = f.nativePath + "\\" + GameModel.modelMap.mapDataVo.name + ".mpd";
				FileHelper.save(url, byteArray);
			} else {
				App.dialog.popupByClazz(SettingDialog);
			}
		}
		
		private function onBtnPublish():void {
			
		}
		
	}
}