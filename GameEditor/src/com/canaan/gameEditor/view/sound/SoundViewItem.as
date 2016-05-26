package com.canaan.gameEditor.view.sound
{
	import com.canaan.gameEditor.cfg.SoundResConfigVo;
	import com.canaan.gameEditor.core.DataCenter;
	import com.canaan.gameEditor.contants.TypeSound;
	import com.canaan.gameEditor.event.GlobalEvent;
	import com.canaan.gameEditor.ui.sound.SoundViewItemUI;
	import com.canaan.gameEditor.view.common.Alert;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.EventManager;
	
	import flash.events.MouseEvent;
	
	public class SoundViewItem extends SoundViewItemUI
	{
		private var mConfig:SoundResConfigVo;
		
		public function SoundViewItem()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			btnDelete.visible = false;
			btnDelete.clickHandler = new Method(onDelete);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mConfig = value as SoundResConfigVo;
			lblSound.text = mConfig.showText;
			imgIcon.url = mConfig.type == TypeSound.MUSIC ? "png.comp.img_music" : "png.comp.img_effect";
		}
		
		private function onDelete():void {
			Alert.show("确定要删除吗？", Alert.TYPE_ACCEPT_CANCEL, new Method(function():void {
				DataCenter.deleteSound(mConfig.id);
				EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.SOUND_VIEW_REFRESH_LIST));
			}));
		}
		
		private function onMouseOver(event:MouseEvent):void {
			btnDelete.visible = true;
		}
		
		private function onMouseOut(event:MouseEvent):void {
			btnDelete.visible = false;
		}
		
		override public function dispose():void {
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			super.dispose();
		}
	}
}