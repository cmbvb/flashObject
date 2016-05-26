package com.canaan.gameEditor.core
{
	import com.canaan.gameEditor.cfg.ActionTypeConfigVo;
	import com.canaan.gameEditor.data.ActionAnimData;
	import com.canaan.gameEditor.data.ActionAnimSequence;
	import com.canaan.gameEditor.data.ActionRoleData;
	import com.canaan.gameEditor.event.GlobalEvent;
	import com.canaan.gameEditor.view.common.Alert;
	import com.canaan.lib.core.Application;
	import com.canaan.lib.core.DLoader;
	import com.canaan.lib.core.SysConfig;
	import com.canaan.lib.display.BitmapDataEx;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.managers.TimerManager;
	import com.canaan.lib.utils.ArrayUtil;
	import com.canaan.lib.utils.BitmapExUtil;
	import com.canaan.lib.utils.ObjectUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.utils.ByteArray;

	public class ActionImageLoader
	{
		public static var imgAnchor:Point;
		
		private var mLoaders:Vector.<DLoader>;
		private var _roleData:ActionRoleData;
		
		public function ActionImageLoader()
		{
		}
		
		public function startLoad():void {
			var file:File = new File();
			file.addEventListener(Event.SELECT, onSelectDirectory);
			file.browseForDirectory("图片文件夹");
		}
		
		private function onSelectDirectory(event:Event):void {
			var file:File = event.target as File;
			file.removeEventListener(Event.SELECT, onSelectDirectory);
			loadResFolder(file);
		}
		
		/**
		 * 加载资源目录
		 * @param file
		 * @return 
		 * 
		 */		
		private function loadResFolder(file:File):void {
			var folders:Array = file.getDirectoryListing();
			if (folders.length == 0) {
				Alert.show("图片文件夹为空！");
				return;
			}
			
			mLoaders = new Vector.<DLoader>();
			_roleData = new ActionRoleData();
			_roleData.desc = file.name;
			
			var actionTypeList:Array = ObjectUtil.objectToArray(SysConfig.getConfig(GameRes.TBL_ACTION_TYPE));
			for each (var folder:File in folders) {
				if (folder.isDirectory) {
					var actionTypeConfig:ActionTypeConfigVo = ArrayUtil.find(actionTypeList, "name", folder.name);
					if (actionTypeConfig == null) {
						Alert.show("发现未识别动作：\"" + folder.name + "\"，请先添加该动作类型！");
						return;
						continue;
					}
					var actionId:int = actionTypeConfig.id;
					var animData:ActionAnimData = _roleData.actions[actionId];
					if (animData == null) {
						_roleData.actions[actionId] = animData = new ActionAnimData();
						animData.actionId = actionId;
					}
					loadActionFolder(folder, actionId);
				}
			}
			
			if (mLoaders.length == 0) {
				onImagesComplete();
				return;
			}
			Alert.show("正在处理图片资源，请稍等...", Alert.TYPE_OK, null, null, false);
			Application.app.mouseChildren = Application.app.mouseEnabled = false;
		}
		
		/**
		 * 加载动作目录
		 * @param file
		 * @param actionId
		 * @return 
		 * 
		 */		
		private function loadActionFolder(file:File, actionId:int):void {
			var images:Array = file.getDirectoryListing();
			if (images.length == 0) {
				return;
			}
			
			for each (var image:File in images) {
				if (!image.isDirectory) {
					var imageName:String = image.name.substring(0, image.name.lastIndexOf("."));
					var direction:int = int(imageName.substring(0, imageName.length - 4));
					var frameIndex:int = int(imageName.substring(imageName.length - 4, imageName.length));
					var bytes:ByteArray = FileHelper.read(image.nativePath);
					var loader:DLoader = DLoader.fromPool();
					loader.data = {actionId:actionId, direction:direction, frameIndex:frameIndex};
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
					mLoaders.push(loader);
					delayLoad(loader, bytes);
				}
			}
		}
		
		private function delayLoad(loader:Loader, bytes:ByteArray):void {
			TimerManager.getInstance().doOnce(500, function():void {
				loader.loadBytes(bytes);
			});
		}
		
		private function onImageLoaded(event:Event):void {
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			var loader:DLoader = loaderInfo.loader as DLoader;
			loaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);
			
			var actionId:int = loader.data.actionId;
			var direction:int = loader.data.direction;
			var frameIndex:int = loader.data.frameIndex;
			
			var bitmapData:BitmapData = Bitmap(loader.content).bitmapData;
			var anchor:Point = imgAnchor ? imgAnchor : new Point(bitmapData.width / 2, bitmapData.height / 2);
			var bitmapDataEx:BitmapDataEx = BitmapExUtil.createBitmapDataEx2(bitmapData, anchor);
			bitmapDataEx.frameIndex = frameIndex;
			
			var animData:ActionAnimData = _roleData.actions[actionId];
			var sequence:ActionAnimSequence = animData.sequences[direction];
			if (sequence == null) {
				animData.sequences[direction] = sequence = new ActionAnimSequence();
				sequence.direction = direction;
			}
			sequence.bitmapDatas.push(bitmapDataEx);
			sequence.animFrames.push(sequence.animFrames.length);
			sequence.maxAnimFrame += 1;
			
			DLoader.toPool(loader);
			mLoaders.splice(mLoaders.indexOf(loader), 1);
			if (mLoaders.length == 0) {
				onImagesComplete();
			}
		}
		
		private function onImagesComplete():void {
			var animData:ActionAnimData;
			for (var actionId:* in _roleData.actions) {
				animData = _roleData.actions[actionId];
				if (animData.hasSequences() == false) {
					delete _roleData.actions[actionId];
					continue;
				}
				for each (var sequence:ActionAnimSequence in animData.sequences) {
					sequence.bitmapDatas.sort(imageSortFunc);
				}
			}
			if (_roleData.hasActions() == false) {
				Alert.show("图片文件夹格式不正确！");
			} else {
				EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.ACTION_RES_LOAD_COMPLETE));
				Alert.hide();
			}
			Application.app.mouseChildren = Application.app.mouseEnabled = true;
		}
		
		private function imageSortFunc(bitmapDataExA:BitmapDataEx, bitmapDataExB:BitmapDataEx):int {
			return bitmapDataExA.frameIndex > bitmapDataExB.frameIndex ? 1 : -1;
		}

		public function get roleData():ActionRoleData {
			return _roleData;
		}
	}
}