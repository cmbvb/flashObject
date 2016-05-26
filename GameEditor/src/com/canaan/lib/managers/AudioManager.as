package com.canaan.lib.managers
{
	import com.canaan.lib.debug.Log;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	public class AudioManager
	{
		public static const TYPE_MUSIC:int = 0;
		public static const TYPE_EFFECT:int = 1;
		
		private static var canInstantiate:Boolean;
		private static var instance:AudioManager;
		
		private var mSounds:Dictionary;
		
		private var _musicOn:Boolean = true;
		private var _soundOn:Boolean = true;
		
		public function AudioManager()
		{
			if (!canInstantiate) {
				throw new Error("Can not instantiate, use getInstance() instead.");
			}
		}
		
		public static function getInstance():AudioManager {
			if (instance == null) {
				canInstantiate = true;
				instance = new AudioManager();
				instance.initialize();
				canInstantiate = false;
			}
			return instance;
		}
		
		private function initialize():void {
			mSounds = new Dictionary();
		}
		
		public function get musicOn():Boolean {
			return _musicOn;
		}
		
		public function get soundOn():Boolean {
			return _soundOn;
		}
		
		public function set musicOn(value:Boolean):void {
			_musicOn = value;
		}
		
		public function set soundOn(value:Boolean):void {
			_soundOn = value;
		}
		
		public function addSound(type:int, path:String, name:String = "", buffer:Number = 1000, checkPolicyFile:Boolean = false):Boolean {
			name = name || path;
			if (soundExists(name)) {
				return false;
			}
			var fullPath:String = ResManager.formatUrl(path);
			var sound:Sound = new Sound(new URLRequest(fullPath), new SoundLoaderContext(buffer, checkPolicyFile));
			sound.addEventListener(Event.COMPLETE, onSoundLoadComplete);
			sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			createSound(sound, type, path, name);
			return true;
		}
		
		private function onSoundLoadComplete(event:Event):void {
			var sound:Sound = event.target as Sound;
			for each (var soundObj:Object in mSounds) {
				if (soundObj.sound == sound) {
					soundObj.loaded = true;
					return;
				}
			}
		}
		
		private function createSound(sound:Sound, type:int, path:String, name:String):void {
			var soundObj:Object = {};
			soundObj.sound = sound;
			soundObj.type = type;
			soundObj.path = path;
			soundObj.name = name;
			soundObj.channel = new SoundChannel();
			soundObj.loaded = false;
			soundObj.paused = false;
			soundObj.position = 0;
			mSounds[name] = soundObj;
		}
		
		public function playMusic(name:String, loops:Boolean = false, volume:Number = 1, startTime:Number = 0):void {
			var soundObj:Object = mSounds[name];
			if (soundObj == null) {
				return;
			}
			if (soundObj.type == TYPE_MUSIC && !_musicOn) {
				return;
			}
			if (soundObj.type == TYPE_EFFECT && (!soundObj.loaded || !_soundOn)) {
				return;
			}
			soundObj.volume = volume;
			soundObj.startTime = startTime;
			soundObj.loops = loops;
			var start_time:Number = soundObj.paused ? soundObj.position : soundObj.startTime;
			try {
				soundObj.channel = soundObj.sound.play(start_time, soundObj.loops, new SoundTransform(soundObj.volume));
			} catch (error:Error) {
				Log.getInstance().error("AudioMananger.playMusic:" + error.message);
			}
			soundObj.pause = false;
			if (loops && soundObj.channel != null) {
				soundObj.channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			}
		}
		
		public function playEffect(name:String, volume:Number = 1, startTime:Number = 0):void {
			var soundObj:Object = mSounds[name];
			if (soundObj == null) {
				return;
			}
			if (soundObj.type == TYPE_MUSIC && !_musicOn) {
				return;
			}
			if (soundObj.type == TYPE_EFFECT && (!soundObj.loaded || !_soundOn)) {
				return;
			}
			var fullPath:String = ResManager.formatUrl(soundObj.path);
			var sound:Sound = new Sound(new URLRequest(fullPath), new SoundLoaderContext());
			try {
				sound.play(startTime, 0, new SoundTransform(volume));
			} catch (error:Error) {
				Log.getInstance().error("AudioMananger.playEffect:" + error.message);
			}
		}
		
		private function soundCompleteHandler(event:Event):void {
			var soundChannel:SoundChannel;
			var target:SoundChannel;
			var soundObj:Object;
			for each (soundObj in mSounds) {
				soundChannel = soundObj.channel as SoundChannel;
				target = event.target as SoundChannel;
				if (target == soundChannel) {
					target.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
					soundObj.channel = soundObj.sound.play(soundObj.position, soundObj.loops, new SoundTransform(soundObj.volume));
					soundObj.channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
					break;
				}
			}
		}
		
		public function removeSound(name:String):void {
			delete mSounds[name];
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			Log.getInstance().error("audio load error:" + event.text);
		}
		
		private function soundExists(value:String):Boolean {
			for (var name:String in mSounds) {
				if (name == value) {
					return true;
				}
			}
			return false;
		}
		
		public function stopSound(name:String):void {
			var soundObj:Object = mSounds[name];
			if (soundObj == null) {
				return;
			}
			soundObj.paused = false;
			soundObj.position = 0;
			if (soundObj.channel != null) {
				soundObj.channel.stop();
			}
		}
		
		public function pauseSound(name:String):void {
			var soundObj:Object = mSounds[name];
			if (!soundObj) {
				return;
			}
			soundObj.paused = true;
			if (soundObj.channel != null) {
				soundObj.channel.stop();
				soundObj.position = soundObj.channel.position;
			}
		}
		
		public function setSoundVolume(name:String, volume:Number):void {
			var soundObj:Object = mSounds[name];
			if (soundObj != null && soundObj.channel != null) {
				soundObj.volume = volume;
				var soundTransform:SoundTransform = soundObj.channel.soundTransform;
				soundTransform.volume = volume;
				soundObj.channel.soundTransform = soundTransform;
			}
		}
		
		public function stopAll(type:int):void {
			var soundObj:Object;
			for (var name:String in mSounds) {
				soundObj = mSounds[name];
				if (soundObj.type == type) {
					stopSound(name);
				}
			}
		}
	}
}