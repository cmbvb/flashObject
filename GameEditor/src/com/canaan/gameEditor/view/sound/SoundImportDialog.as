package com.canaan.gameEditor.view.sound
{
	import com.canaan.gameEditor.cfg.SoundResConfigVo;
	import com.canaan.gameEditor.core.AudioHelper;
	import com.canaan.gameEditor.core.DataCenter;
	import com.canaan.gameEditor.core.FileHelper;
	import com.canaan.gameEditor.core.GameRes;
	import com.canaan.gameEditor.core.GameResPath;
	import com.canaan.gameEditor.event.GlobalEvent;
	import com.canaan.gameEditor.ui.sound.SoundImportDialogUI;
	import com.canaan.gameEditor.view.common.Alert;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.core.SysConfig;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.utils.StringUtil;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	public class SoundImportDialog extends SoundImportDialogUI
	{
		private var mFile:File;
		private var mSound:Sound;
		private var mSoundChanel:SoundChannel;
		
		public function SoundImportDialog()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			
			btnPlay.clickHandler = new Method(onPlay);
			btnSave.clickHandler = new Method(onSave);
		}
		
		public function show(file:File):void {
			mFile = file;
			txtFile.text = mFile.name;
		}
		
		private function onPlay():void {
			if (mSoundChanel != null) {
				mSoundChanel.stop();
			}
			mSound = new Sound(new URLRequest(mFile.url));
			mSound.addEventListener(Event.COMPLETE, onSoundLoadComplete);
		}
		
		private function onStop():void {
			if (mSoundChanel != null) {
				mSound = null;
				mSoundChanel.stop();
				mSoundChanel = null;
			}
		}
		
		private function onSoundLoadComplete(event:Event):void {
			mSound = event.target as Sound;
			mSound.removeEventListener(Event.COMPLETE, onSoundLoadComplete);
			mSoundChanel = mSound.play();
		}
		
		private function onSave():void {
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
			if (SysConfig.getConfigVo(GameRes.TBL_SOUND_RES, id) != null) {
				Alert.show("编号已存在");
				return;
			}
			var desc:String = StringUtil.trim(txtDesc.text);
			
			onStop();
			Alert.show("正在处理音频资源，请稍等...", Alert.TYPE_OK, null, null, false);
			FileHelper.copy(mFile.nativePath, GameResPath.file_cfg_audioSource + fileName);
			var config:SoundResConfigVo = new SoundResConfigVo();
			config.id = int(id);
			config.type = cboType.selectedIndex;
			config.fileName = fileName;
			config.desc = desc;
			SysConfig.addConfigVo(GameRes.TBL_SOUND_RES, id, config);
			AudioHelper.saveSound(config);
			DataCenter.saveSoundTableCfg();
			Alert.show("添加成功！");
			
			close();
			EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.SOUND_VIEW_REFRESH_LIST));
		}
		
		override public function close(type:String=null):void {
			super.close(type);
			onStop();
			mFile = null;
			dispose();
		}
	}
}