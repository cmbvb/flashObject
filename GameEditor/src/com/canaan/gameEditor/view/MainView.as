package com.canaan.gameEditor.view
{
	import com.canaan.gameEditor.core.DataCenter;
	import com.canaan.gameEditor.core.GameResPath;
	import com.canaan.gameEditor.ui.MainViewUI;
	import com.canaan.gameEditor.view.common.Alert;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.events.KeyEvent;
	import com.canaan.lib.managers.KeyboardManager;
	
	import flash.ui.Keyboard;
	
	public class MainView extends MainViewUI
	{
		public function MainView()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			
			BMPActionLoader.actionRoot = GameResPath.action;
			
			btnRelease.clickHandler = new Method(onRelease);
			btnSetting.clickHandler = new Method(showSetting);
			tab.selectHandler = new Method(changeTab);
			Object(viewStack.selection).onShow();
			
			KeyboardManager.getInstance().addEventListener(KeyEvent.KEY_DOWN, onKeyDown);
		}
		
		private function changeTab(index:int):void {
			var lastView:Object = viewStack.selection;
			if (lastView != null) {
				lastView.onHide();
			}
			viewStack.setIndexHandler.applyWith([index]);
			lastView = viewStack.selection;
			lastView.onShow();
		}
		
		private function onRelease():void {
			DataCenter.release();
			Alert.show("发布成功！");
		}
		
		private function showSetting():void {
			var settingDialog:SettingDialog = new SettingDialog();
			settingDialog.popup(true, false);
		}
		
		private function onKeyDown(event:KeyEvent):void {
			var keyCode:int = event.keyCode;
			var shift:Boolean = event.shiftKey;
			var ctrl:Boolean = event.ctrlKey;
			switch (keyCode) {
				case Keyboard.F12:
					onRelease();
					break;
			}
		}
	}
}