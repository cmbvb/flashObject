package com.canaan.gameEditor.view.sound
{
	import com.canaan.gameEditor.cfg.SoundResConfigVo;
	import com.canaan.gameEditor.core.AudioHelper;
	import com.canaan.gameEditor.core.GameRes;
	import com.canaan.gameEditor.event.GlobalEvent;
	import com.canaan.gameEditor.ui.sound.SoundChooseDialogUI;
	import com.canaan.gameEditor.view.common.Alert;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.core.SysConfig;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.utils.ObjectUtil;
	import com.canaan.lib.utils.StringUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SoundChooseDialog extends SoundChooseDialogUI
	{
		private var mFilterKeywords:String;
		
		public function SoundChooseDialog()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			btnAccept.clickHandler = new Method(onAccept);
			listSounds.mouseHandler = new Method(onSoundMouseEvent);
			txtSearch.addEventListener(Event.CHANGE, onTextChange);
			
			refreshList();
		}
		
		private function onAccept():void {
			var soundConfig:SoundResConfigVo = listSounds.selectedItem as SoundResConfigVo;
			if (soundConfig == null) {
				Alert.show("未选择音频！");
				return;
			}
			EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.SOUND_CHOOSE_COMPLETE, soundConfig));
			close();
		}
		
		private function onSoundMouseEvent(event:MouseEvent, index:int):void {
			if (event.type == MouseEvent.CLICK) {
				var soundConfig:SoundResConfigVo = listSounds.array[index];
				AudioHelper.playSound(soundConfig.id);
			}
		}
		
		private function onTextChange(event:Event):void {
			mFilterKeywords = StringUtil.trim(txtSearch.text);
			refreshList();
		}
		
		private function refreshList():void {
			var soundList:Array = ObjectUtil.objectToArray(SysConfig.getConfig(GameRes.TBL_SOUND_RES));
			if (mFilterKeywords) {
				soundList = soundList.filter(filterFunc);
			}
			soundList.sort(sortFunc);
			listSounds.array = soundList;
		}
		
		private function filterFunc(element:*, index:int, arr:Array):Boolean {
			var config:SoundResConfigVo = element as SoundResConfigVo;
			if (config.id.toString().indexOf(mFilterKeywords) == -1 && config.desc.indexOf(mFilterKeywords) == -1) {
				return false;
			}
			return true;
		}
		
		private function sortFunc(configA:SoundResConfigVo, configB:SoundResConfigVo):int {
			return configA.id > configB.id ? 1 : -1;
		}
		
		override public function close(type:String=null):void {
			super.close(type);
			txtSearch.removeEventListener(Event.CHANGE, onTextChange);
			AudioHelper.stopSound();
			dispose();
		}
	}
}