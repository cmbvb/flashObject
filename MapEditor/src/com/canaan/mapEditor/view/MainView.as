package com.canaan.mapEditor.view
{
	import com.adobe.images.JPGEncoder;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.events.KeyEvent;
	import com.canaan.lib.managers.KeyboardManager;
	import com.canaan.lib.managers.StageManager;
	import com.canaan.mapEditor.contants.GlobalSetting;
	import com.canaan.mapEditor.core.FileHelper;
	import com.canaan.mapEditor.core.GameResPath;
	import com.canaan.mapEditor.models.vo.data.MapDataVo;
	import com.canaan.mapEditor.ui.MainViewUI;
	import com.canaan.mapEditor.view.common.Alert;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.net.FileFilter;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	public class MainView extends MainViewUI
	{
		public static var instance:MainView;
		
		private var mMapDataVo:MapDataVo;
		
		public function MainView()
		{
			super();
			instance = this;
			mMapDataVo = new MapDataVo();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			
			btnSetting.clickHandler = new Method(showSetting);
			btnCreate.clickHandler = new Method(onButtonCreate);
			btnOpen.clickHandler = new Method(onButtonOpen);
			btnSave.clickHandler = new Method(onButtonSave);
			btnOutput.clickHandler = new Method(onButtonOutput);
			btnOutputMini.clickHandler = new Method(onButtonOutputMini);
			chkShowGrid.clickHandler = new Method(onShowGrid);
			chkShowObjectInfo.clickHandler = new Method(onShowObjectInfo);
			chkShowObjectLayer.clickHandler = new Method(onShowObjectLayer);
			chkShowAreaLayer.clickHandler = new Method(onShowAreaLayer);
			
			KeyboardManager.getInstance().addEventListener(KeyEvent.KEY_DOWN, onKeyDown);
			
			mapView.visible = false;
			containerEdit.visible = false;
			mapAttrView.visible = false;
			
			resizeHandler = onResize;
			onResize();
		}
		
		private function onResize():void {
			var screenWidth:Number = StageManager.getInstance().screenWidth;
			var screenHeight:Number = StageManager.getInstance().screenHeight;
			containerSetting.x = screenWidth - containerSetting.width - 10;
			containerEdit.x = screenWidth - containerEdit.width - 5;
			mapAttrView.y = screenHeight - mapAttrView.height - 20;
			mapView.setViewSize(containerEdit.x, screenHeight - mapView.y);
		}
		
		private function showSetting():void {
			var settingDialog:SettingDialog = new SettingDialog();
			settingDialog.popup(true, false);
		}
		
		private function onButtonCreate():void {
			onCreate();
		}
		
		private function onButtonOpen():void {
			openMap();
		}
		
		private function onButtonSave():void {
			if (mMapDataVo.bitmapData != null && !Alert.isPopup) {
				onSave();
			}
		}
		
		private function onButtonOutput():void {
			if (mMapDataVo.bitmapData != null) {
				var encoder:JPGEncoder = new JPGEncoder(GlobalSetting.TILE_IMAGE_QUALITY);
				var bitmapData:BitmapData = new BitmapData(GlobalSetting.TILE_WIDTH, GlobalSetting.TILE_HEIGHT, false, 0);
				var bytes:ByteArray;
				for (var i:int = 0; i < mMapDataVo.tileRowCount; i++) {
					for (var j:int = 0; j < mMapDataVo.tileColCount; j++) {
						bitmapData.fillRect(bitmapData.rect, 0);
						bitmapData.draw(mMapDataVo.bitmapData, new Matrix(1, 0, 0, 1, -j * GlobalSetting.TILE_WIDTH, -i * GlobalSetting.TILE_HEIGHT));
						bytes = encoder.encode(bitmapData);
						FileHelper.save(mMapDataVo.tilePath + i + "_" + j + ".jpg", bytes);
					}
				}
				Alert.show("切图成功！");
			}
		}
		
		private function onButtonOutputMini():void {
			if (mMapDataVo.bitmapData != null) {
				var encoder:JPGEncoder = new JPGEncoder(GlobalSetting.TILE_IMAGE_QUALITY);
				var bitmapData:BitmapData = new BitmapData(GlobalSetting.THUMBNAIL_WIDTH, GlobalSetting.THUMBNAIL_HEIGHT, false, 0);
				bitmapData.draw(mMapDataVo.bitmapData, new Matrix(GlobalSetting.THUMBNAIL_WIDTH / mMapDataVo.mapWidth, 0, 0, GlobalSetting.THUMBNAIL_HEIGHT / mMapDataVo.mapHeight));
//				bitmapData.applyFilter(bitmapData, bitmapData.rect, new Point(), new BlurFilter(1.5, 1.5));
				var bytes:ByteArray = encoder.encode(bitmapData);
				FileHelper.save(mMapDataVo.thumbnailsPath, bytes);
				Alert.show("生成缩略图成功！");
			}
		}
		
		private function onShowGrid():void {
			if (chkShowGrid.selected) {
				mapView.showGrid();
			} else {
				mapView.hideGrid();
			}
		}
		
		private function onShowObjectInfo():void {
			if (chkShowObjectInfo.selected) {
				mapView.showObjectInfo();
			} else {
				mapView.hideObjectInfo();
			}
		}
		
		private function onShowObjectLayer():void {
			if (chkShowObjectLayer.selected) {
				mapView.showObjectLayer();
			} else {
				mapView.hideObjectLayer();
			}
		}
		
		private function onShowAreaLayer():void {
			if (chkShowAreaLayer.selected) {
				mapView.showAreaLayer();
			} else {
				mapView.hideAreaLayer();
			}
		}
		
		private function onShowBlockLayer():void {
			if (chkShowBlockLayer.selected) {
				mapView.showBlockLayer();
			} else {
				mapView.hideBlockLayer();
			}
		}
		
		private function onCreate():void {
			var createDialog:CreateDialog = new CreateDialog();
			createDialog.popup(true, false);
			return;
			
			var file:File = new File(GameResPath.file_map_root);
			var fileFilter:FileFilter = new FileFilter("图片(*.jpg)", "*.jpg;");
			file.addEventListener(Event.SELECT, function(event:Event):void {
				var imageName:String = file.name.substring(0, file.name.lastIndexOf("."));
				var serverPath:String = GameResPath.file_server_path + imageName + ".mpt";
				if (FileHelper.isExist(serverPath)) {
					Alert.show("已存在该地图，是否打开？", Alert.TYPE_ACCEPT_CANCEL, new Method(function():void {
						openMap();
					}));
					return;
				}
				readImage(file.nativePath, new Method(function(bitmapData:BitmapData):void {
					mMapDataVo.clear();
					mMapDataVo.name = imageName;
					mMapDataVo.bitmapData = bitmapData;
					mMapDataVo.createBlocks();
					showMap();
				}));
			});
			file.browse([fileFilter]);
		}
		
		public function createMap(mapName:String, resName:String, path:String):void {
			readImage(path, new Method(function(bitmapData:BitmapData):void {
				mMapDataVo.clear();
				mMapDataVo.name = mapName;
				mMapDataVo.resName = resName;
				mMapDataVo.bitmapData = bitmapData;
				mMapDataVo.createBlocks();
				showMap();
			}));
		}
		
		public function openMap():void {
			var file:File;
			if (FileHelper.isExist(GameResPath.file_server_path)) {
				file = new File(GameResPath.file_server_path);
			} else {
				file = File.applicationDirectory;
			}
			var fileFilter:FileFilter = new FileFilter("地图配置文件(*.mpt)", "*.mpt;");
			file.addEventListener(Event.SELECT, function(event:Event):void {
				var imageName:String = file.name.substring(0, file.name.lastIndexOf("."));
				var jsonString:String = FileHelper.readText(file.nativePath);
				var jsonObj:Object = JSON.parse(jsonString);
				mMapDataVo.setData(jsonObj);
				mMapDataVo.name = imageName;
				readImage(mMapDataVo.imagePath, new Method(function(bitmapData:BitmapData):void {
					mMapDataVo.bitmapData = bitmapData;
					showMap();
				}));
			});
			file.browse([fileFilter]);
		}
		
		private function readImage(path:String, onComplete:Method):void {
			var bytes:ByteArray = FileHelper.read(path);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void {
				var bitmapData:BitmapData = Bitmap(loader.content).bitmapData.clone();
				onComplete.applyWith([bitmapData]);
			});
			loader.loadBytes(bytes);
		}
		
		private function showMap():void {
			miniView.dataSource = mMapDataVo;
			editView.dataSource = mMapDataVo;
			mapView.showMap(mMapDataVo);
			containerEdit.visible = true;
			mapView.visible = true;
		}
		
		private function onSave(onComplete:Method = null):void {
			FileHelper.save(mMapDataVo.clientPath, mMapDataVo.getClientData());
			FileHelper.saveText(mMapDataVo.serverPath, mMapDataVo.getDataJson());
			if (onComplete != null) {
				onComplete.apply();
			}
			Alert.show("保存成功！");
		}
		
		private function onKeyDown(event:KeyEvent):void {
			var keyCode:int = event.keyCode;
			var shift:Boolean = event.shiftKey;
			var ctrl:Boolean = event.ctrlKey;
			if (ctrl) {
				if (keyCode == Keyboard.D) {
					openMap();
					return;
				} else if (keyCode == Keyboard.F) {
					onCreate();
					return;
				}
			}
			
			if (mMapDataVo.bitmapData == null) {
				return;
			}
			switch (keyCode) {
				case Keyboard.S:
					if (ctrl) {
						onButtonSave();
					}
					break;
				case Keyboard.ESCAPE:
					mapView.onEsc();
					break;
				case Keyboard.F1:
					chkShowGrid.selected = !chkShowGrid.selected;
					onShowGrid();
					break;
				case Keyboard.F2:
					chkShowObjectInfo.selected = !chkShowObjectInfo.selected;
					onShowObjectInfo();
					break;
				case Keyboard.F3:
					chkShowObjectLayer.selected = !chkShowObjectLayer.selected;
					onShowObjectLayer();
					break;
				case Keyboard.F4:
					chkShowAreaLayer.selected = !chkShowAreaLayer.selected;
					onShowAreaLayer();
					break;
				case Keyboard.F5:
					chkShowBlockLayer.selected = !chkShowBlockLayer.selected;
					onShowBlockLayer();
					break;
			}
		}
	}
}