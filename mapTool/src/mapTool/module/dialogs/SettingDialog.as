package mapTool.module.dialogs
{
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mapTool.MapSetting;
	
	import morn.core.handlers.Handler;
	
	import uiCreate.dialogs.SettingDialogUI;
	
	public class SettingDialog extends SettingDialogUI
	{
		private var mFType:int;
		
		public function SettingDialog()
		{
			super();
		}
		
		override protected function initialize():void {
			super.initialize();
			btnSavePath.clickHandler = new Handler(onClickBtnSavePath);
		}
		
		private function onClickBtnSavePath():void {
			var file:File = File.applicationDirectory;
			file.browseForDirectory("选择客户端数据保存路径");
			file.addEventListener(Event.SELECT, function(event:Event):void {
				MapSetting.clientDataSavePath = file.nativePath;
			});
			setLblSavePath();
		}
		
		private function onInputWChange(event:Event):void {
			var num:int = int(event.target.text);
			MapSetting.gridW = num;
		}
		
		private function onInputHChange(event:Event):void {
			var num:int = int(event.target.text);
			MapSetting.gridH = num;
		}

		private function setLblSavePath():void {
			lblSavePath.text = MapSetting.clientDataSavePath;
		}
		
		override public function update(value:Object = null):void {
			inputW.text = MapSetting.gridW.toString();
			inputH.text = MapSetting.gridH.toString();
			inputW.addEventListener(Event.CHANGE, onInputWChange);
			inputH.addEventListener(Event.CHANGE, onInputHChange);
			setLblSavePath();
		}
		
		override public function close(type:String=null):void {
			super.close(type);
			inputW.removeEventListener(Event.CHANGE, onInputWChange);
			inputH.removeEventListener(Event.CHANGE, onInputHChange);
		}
		
	}
}