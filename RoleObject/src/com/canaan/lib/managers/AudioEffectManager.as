package com.canaan.lib.managers
{
	import com.canaan.lib.core.Method;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;

	public class AudioEffectManager
	{
		public static const STATE_LOADING:String = "loading";
		public static const LOADED:String = "loaded";
		
		private static var canInstantiate:Boolean;
		private static var instance:AudioEffectManager;
		
		private var _enable:Boolean;
		private var mEffectState:Dictionary;
		private var mEffectPlaying:Dictionary;
		private var mEffectChannels:Dictionary;
		
		public function AudioEffectManager()
		{
			if (!canInstantiate) {
				throw new Error("Can not instantiate, use getInstance() instead.");
			}
			_enable = true;
			mEffectState = new Dictionary();
			mEffectPlaying = new Dictionary();
			mEffectChannels = new Dictionary();
		}
		
		public function get enable():Boolean {
			return _enable;
		}

		public function set enable(value:Boolean):void {
			_enable = value;
		}

		public static function getInstance():AudioEffectManager {
			if (instance == null) {
				canInstantiate = true;
				instance = new AudioEffectManager();
				canInstantiate = false;
			}
			return instance;
		}
		
		public function playEffect(path:String, className:String, volume:Number = 1, startTime:Number = 0):void {
			if (_enable == false) {
				return;
			}
			var state:String = mEffectState[path];
			if (state == LOADED) {
				var sound:Sound = ResManager.getInstance().getNewInstance(className) as Sound;
				if (sound != null) {
					var soundChannel:SoundChannel = sound.play(startTime, 0, new SoundTransform(volume));
					if (soundChannel != null) {
						soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
						mEffectChannels[soundChannel] = className;
						mEffectPlaying[className] = soundChannel;
					}
				}
				return;
			}
			if (state == null) {
				mEffectState[path] = STATE_LOADING;
				ResManager.getInstance().load(path, path, path, new Method(function():void {
					mEffectState[path] = LOADED;
				}), null, true, 4);
			}
		}
		
		private function onSoundComplete(event:Event):void {
			var soundChannel:SoundChannel = event.target as SoundChannel;
			soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			var className:String = mEffectChannels[soundChannel];
			delete mEffectChannels[soundChannel];
			delete mEffectPlaying[className];
		}
		
		public function isPlaying(className:String):Boolean {
			return mEffectPlaying.hasOwnProperty(className);
		}
	}
}