package com.canaan.mapEditor.view
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.utils.StringUtil;
	import com.canaan.mapEditor.core.FileHelper;
	import com.canaan.mapEditor.core.GameResPath;
	import com.canaan.mapEditor.ui.CreateDialogUI;
	import com.canaan.mapEditor.view.common.Alert;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	public class CreateDialog extends CreateDialogUI
	{
		public function CreateDialog()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			
			btnSelect.clickHandler = new Method(onSelect);
			btnCreate.clickHandler = new Method(onCreate);
		}
		
		private function onSelect():void {
			var file:File = new File(GameResPath.file_map_root);
			var fileFilter:FileFilter = new FileFilter("图片(*.jpg)", "*.jpg;");
			file.addEventListener(Event.SELECT, function(event:Event):void {
				var resName:String = file.name.substring(0, file.name.lastIndexOf("."));
				txtResName.text = resName;
			});
			file.browse([fileFilter]);
		}
		
		private function onCreate():void {
			var mapName:String = StringUtil.trim(txtMapName.text);
			if (mapName == "") {
				return;
			}
			var resName:String = StringUtil.trim(txtResName.text);
			if (resName == "") {
				return;
			}
			var resPath:String = GameResPath.file_map_root + resName + ".jpg";
			if (FileHelper.isExist(resPath) == false) {
				Alert.show("图片资源不存在！");
				return;
			}
			var serverPath:String = GameResPath.file_server_path + mapName + ".mpt";
			if (FileHelper.isExist(serverPath)) {
				Alert.show("已存在该地图，是否打开？", Alert.TYPE_ACCEPT_CANCEL, new Method(function():void {
					MainView.instance.openMap();
					close();
				}));
				return;
			}
			MainView.instance.createMap(mapName, resName, resPath);
			close();
		}
	}
}