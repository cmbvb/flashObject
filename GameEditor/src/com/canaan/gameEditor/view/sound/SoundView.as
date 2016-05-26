package com.canaan.gameEditor.view.sound
{
	import com.canaan.gameEditor.cfg.SoundResConfigVo;
	import com.canaan.gameEditor.contants.TypeSound;
	import com.canaan.gameEditor.core.AudioHelper;
	import com.canaan.gameEditor.core.DataCenter;
	import com.canaan.gameEditor.core.FileHelper;
	import com.canaan.gameEditor.core.GameRes;
	import com.canaan.gameEditor.event.GlobalEvent;
	import com.canaan.gameEditor.ui.sound.SoundViewUI;
	import com.canaan.gameEditor.view.common.Alert;
	import com.canaan.lib.core.Application;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.core.SysConfig;
	import com.canaan.lib.events.KeyEvent;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.managers.KeyboardManager;
	import com.canaan.lib.utils.ObjectUtil;
	import com.canaan.lib.utils.StringUtil;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.utils.Dictionary;
	
	public class SoundView extends SoundViewUI
	{
		private var mFilterKeywords:String;
		private var mConfig:SoundResConfigVo;
		
		public function SoundView()
		{
			super();
			container.disabled = true;
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			txtSearch.addEventListener(Event.CHANGE, onTextChange);
			btnImport.clickHandler = new Method(onImport);
			btnSaveAll.clickHandler = new Method(onSaveAll);
			listSounds.selectHandler = new Method(onListSelect);
			btnPlay.clickHandler = new Method(onPlay);
			btnStop.clickHandler = new Method(onStop);
			btnSave.clickHandler = new Method(onSave);
			
			refreshList();
		}
		
		public function onShow():void {
			KeyboardManager.getInstance().addEventListener(KeyEvent.KEY_DOWN, onKeyDown);
			EventManager.getInstance().addEventListener(GlobalEvent.SOUND_VIEW_REFRESH_LIST, refreshList);
		}
		
		public function onHide():void {
			KeyboardManager.getInstance().removeEventListener(KeyEvent.KEY_DOWN, onKeyDown);
			EventManager.getInstance().removeEventListener(GlobalEvent.SOUND_VIEW_REFRESH_LIST, refreshList);
		}
		
		private function onImport():void {
			var file:File = new File();
			var fileFilter:FileFilter = new FileFilter("mp3音频文件", "*.mp3");
			file.addEventListener(Event.SELECT, onSelect);
			file.browse([fileFilter]);
		}
		
		private function onSelect(event:Event):void {
			var file:File = event.target as File;
			var soundImportDialog:SoundImportDialog = new SoundImportDialog();
			soundImportDialog.show(file);
			soundImportDialog.popup(true);
		}
		
		private function onPlay():void {
			if (resIsDelete()) {
				return;
			}
			AudioHelper.playSound(mConfig.id);
		}
		
		private function onStop():void {
			AudioHelper.stopSound();
		}
		
		private function onSave():void {
			if (resIsDelete()) {
				return;
			}
			var id:String = StringUtil.trim(txtID.text);
			if (id == "") {
				Alert.show("编号不能为空");
				return;
			}
			if (isNaN(Number(id))) {
				Alert.show("编号必须为数字");
				return;
			}
			var fileName:String = StringUtil.trim(txtFile.text);
			if (fileName == "") {
				Alert.show("文件名不能为空");
				return;
			}
			if (fileName.toLowerCase().lastIndexOf(".mp3") != fileName.length - 4) {
				Alert.show("文件名格式不正确");
				return;
			}
			if (fileName.search(FileHelper.REG) != -1) {
				Alert.show("文件名含有非法字符");
				return;
			}
			var desc:String = StringUtil.trim(txtDesc.text);
			
			var config:SoundResConfigVo = SysConfig.getConfigVo(GameRes.TBL_SOUND_RES, id) as SoundResConfigVo;
			if (config != null && config != mConfig) {
				Alert.show("编号已存在");
				return;
			}
			
			mConfig.id = int(id);
			mConfig.type = cboType.selectedIndex;
			mConfig.fileName = fileName;
			mConfig.desc = desc;
			DataCenter.saveSoundTableCfg();
			Alert.show("保存成功");
			refreshList();
			listSounds.selectedItem = mConfig;
		}
		
		private function refreshList(event:GlobalEvent = null):void {
			var soundList:Array = ObjectUtil.objectToArray(SysConfig.getConfig(GameRes.TBL_SOUND_RES));
			if (mFilterKeywords) {
				soundList = soundList.filter(filterFunc);
			}
			soundList.sort(sortFunc);
			listSounds.array = soundList;
			onListSelect(listSounds.selectedIndex);
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
		
		private function onTextChange(event:Event):void {
			mFilterKeywords = StringUtil.trim(txtSearch.text);
			refreshList();
		}
		
		private function onListSelect(index:int):void {
			if (index != -1) {
				mConfig = listSounds.array[index];
				txtID.text = mConfig.id.toString();
				cboType.selectedIndex = mConfig.type;
				txtFile.text = mConfig.fileName;
				txtDesc.text = mConfig.desc;
				container.disabled = false;
			} else {
				mConfig = null;
				txtID.text = "";
				cboType.selectedIndex = TypeSound.EFFECT;
				txtFile.text = "";
				txtDesc.text = "";
				container.disabled = true;
			}
		}
		
		private function clearDetail():void {
			mConfig = null;
			txtID.text = "";
			txtFile.text = "";
			txtDesc.text = "";
		}
		
		private function resIsDelete():Boolean {
			if (mConfig == null) {
				return true;
			}
			if (SysConfig.getConfigVo(GameRes.TBL_SOUND_RES, mConfig.id) == null) {
				Alert.show("该音频已删除");
				clearDetail();
				return true;
			}
			return false;
		}
		
		private function onKeyDown(event:KeyEvent):void {
			var keyCode:int = event.keyCode;
			var shift:Boolean = event.shiftKey;
			var ctrl:Boolean = event.ctrlKey;
			switch (keyCode) {
//				case Keyboard.S:
//					if (ctrl) {
//						onSave();
//					}
//					break;
			}
		}
		
		private function onSaveAll():void {
			Alert.show("正在保存中");
			Application.app.mouseEnabled = false;
			Application.app.mouseChildren = false;
			var configs:Dictionary = SysConfig.getConfig(GameRes.TBL_SOUND_RES);
			var list:Array = ObjectUtil.objectToArray(configs);
			AudioHelper.saveList(list, new Method(function():void {
				Application.app.mouseEnabled = true;
				Application.app.mouseChildren = true;
				Alert.show("保存成功！");
			}));
		}
	}
}