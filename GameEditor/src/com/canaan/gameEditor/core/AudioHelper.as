package com.canaan.gameEditor.core
{
	import com.canaan.gameEditor.cfg.SoundResConfigVo;
	import com.canaan.gameEditor.contants.TypeSound;
	import com.canaan.gameEditor.view.common.Alert;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.core.SysConfig;
	import com.canaan.lib.managers.AudioManager;
	import com.canaan.lib.managers.TimerManager;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.NativeProcessExitEvent;
	import flash.filesystem.File;

	/**
	 * 音频帮助类
	 * @author Administrator
	 * 
	 */	
	public class AudioHelper
	{
		private static var currentMusic:String;
		
		private static var currentList:Array;
		
		public function AudioHelper()
		{
		}
		
		/**
		 * 播放声音
		 * @param id
		 * 
		 */		
		public static function playSound(id:int):void {
			AudioManager.getInstance().stopSound(currentMusic);
			var soundResConfig:SoundResConfigVo = SysConfig.getConfigVo(GameRes.TBL_SOUND_RES, id.toString()) as SoundResConfigVo;
			if (soundResConfig != null) {
				currentMusic = soundResConfig.id.toString();
				AudioManager.getInstance().addSound(TypeSound.MUSIC, soundResConfig.sourcePath, currentMusic);
				AudioManager.getInstance().playEffect(currentMusic);
			}
		}
		
		/**
		 * 停止播放声音
		 * 
		 */		
		public static function stopSound():void {
			AudioManager.getInstance().stopAll(AudioManager.TYPE_MUSIC);
			AudioManager.getInstance().stopAll(AudioManager.TYPE_EFFECT);
		}
		
		/**
		 * 保存音乐
		 * @param soundConfig
		 * 
		 */		
		public static function saveSound(soundConfig:SoundResConfigVo):void {
			if (soundConfig.type == TypeSound.MUSIC) {
				var sourcePath:String = GameResPath.file_cfg_audioSource + soundConfig.fileName;
				FileHelper.copy(sourcePath, GameResPath.file_output_audio + "music\\" + soundConfig.id + ".mp3");
			} else {
				var xml:XML = <lib/>;
				var className:String = "sound_" + soundConfig.id;
				var filePath:String = GameResPath.file_cfg_audioSource + soundConfig.fileName;
				var soundXML:XML = <sound class={className} file={filePath}/>;
				xml.appendChild(soundXML);
				
				var xmlPath:String = GameResPath.file_cfg_audioXML + soundConfig.fileName + ".xml";
				FileHelper.saveXML(xmlPath, xml);
				
				var outputDirectoryPath:String = GameResPath.file_output_audio + "effect\\";
				var ouputPath:String = GameResPath.file_output_audio + "effect\\" + soundConfig.id + ".swf";
				FileHelper.createDirectory(outputDirectoryPath);
				
				var fileOutput:File = new File();
				fileOutput = fileOutput.resolvePath("C:/WINDOWS/system32/cmd.exe");
				var args:Vector.<String> = new <String>["/c", "java", "-jar", GameResPath.file_cfg_lib + "Swift.jar", "xml2lib", 
					xmlPath, ouputPath];
				var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
				nativeProcessStartupInfo.arguments = args;
				nativeProcessStartupInfo.executable = fileOutput;
				var process:NativeProcess = new NativeProcess();
				process.start(nativeProcessStartupInfo);
				process.addEventListener(NativeProcessExitEvent.EXIT, function(event:NativeProcessExitEvent):void {
					if (event.exitCode != 0) {
						Alert.show("保存音效错误，exitCode:" + event.exitCode);
						return;
					}
				});
			}
		}
		
		public static function saveList(sounds:Array, callback:Method = null):void {
			var func:Function = function():void {
				if (sounds.length > 0) {
					saveSound(sounds.shift());
				} else {
					callback.apply();
					TimerManager.getInstance().clear(func);
				}
			};
			TimerManager.getInstance().doLoop(300, func);
		}
	}
}