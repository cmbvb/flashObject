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
		public static const TYPE_SOUND:int = 1;
		
		private static var canInstantiate:Boolean;
        private static var instance:AudioManager;
        
        private var sounds:Dictionary;
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
			this.sounds = new Dictionary();
		}
		
		public function get musicOn():Boolean {
			return this._musicOn;
		}
		
		public function get soundOn():Boolean {
			return this._soundOn;
		}
		
		public function set musicOn(value:Boolean):void {
			this._musicOn = value;
		}
		
		public function set soundOn(value:Boolean):void {
			this._soundOn = value;
		}
		
		public function addSound(type:int, path:String, name:String = "", buffer:Number = 1000, checkPolicyFile:Boolean = false):Boolean {
			name = name || path;
			if (this.soundExists(name)) {
				return false;
			}
			var fullPath:String = ResManager.formatUrl(path);
			var sound:Sound = new Sound(new URLRequest(fullPath), new SoundLoaderContext(buffer, checkPolicyFile));
			sound.addEventListener(Event.COMPLETE, onSoundLoadComplete);
			sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this.createSound(sound, type, path, name);
			return true;
		}
		
		private function onSoundLoadComplete(event:Event):void {
			var sound:Sound = event.target as Sound;
			for each (var soundObj:Object in this.sounds) {
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
            this.sounds[name] = soundObj;
		}
		
		public function playSound(name:String, loops:Boolean = false, volume:Number = 1, startTime:Number = 0):void {
			var sound:Object = this.sounds[name];
			if (sound == null) {
				return;
			}
			if (sound.type == TYPE_MUSIC && !this._musicOn) {
				return;
			}
			if (sound.type == TYPE_SOUND && (!sound.loaded || !this._soundOn)) {
				return;
			}
			sound.volume = volume;
			sound.startTime = startTime;
			sound.loops = loops;
			var start_time:Number = sound.paused ? sound.position : sound.startTime;
			try {
				sound.channel = sound.sound.play(start_time, sound.loops, new SoundTransform(sound.volume));
			} catch (error:Error) {
				Log.getInstance().error("AudioMananger.playSound:" + error.message);
			}
			sound.pause = false;
			if (loops && sound.channel != null) {
				sound.channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			}
		}
		
		private function soundCompleteHandler(event:Event):void {
			var soundChannel:SoundChannel;
            var target:SoundChannel;
            var sound:Object;
            for each (sound in this.sounds) {
                soundChannel = sound.channel as SoundChannel;
                target = event.target as SoundChannel;
                if (target == soundChannel) {
                    target.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
                    sound.channel = sound.sound.play(sound.position, sound.loops, new SoundTransform(sound.volume));
                    sound.channel.addEventListener(Event.SOUND_COMPLETE, this.soundCompleteHandler);
                    break;
                }
            }
		}
		
		public function removeSound(name:String):void {
            delete this.sounds[name];
        }
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			Log.getInstance().error("audio load error:" + event.text);
		}
		
		private function soundExists(value:String):Boolean {
            for (var name:String in this.sounds) {
            	if (name == value) {
            		return true;
            	}
            }
            return false;
        }
        
        public function stopSound(name:String):void {
        	var sound:Object = this.sounds[name];
        	if (sound == null) {
        		return;
        	}
        	sound.paused = false;
			sound.position = 0;
        	if (sound.channel != null) {
        		sound.channel.stop();
        	}
        }
        
        public function pauseSound(name:String):void {
        	var sound:Object = this.sounds[name];
        	if (!sound) {
        		return;
        	}
			sound.paused = true;
			if (sound.channel != null) {
				sound.channel.stop();
				sound.position = sound.channel.position;
			}
        }
        
        public function setSoundVolume(name:String, volume:Number):void {
        	var sound:Object = this.sounds[name];
        	if (sound != null && sound.channel != null) {
				sound.volume = volume;
        		var soundTransform:SoundTransform = sound.channel.soundTransform;
	            soundTransform.volume = volume;
	            sound.channel.soundTransform = soundTransform;
        	}
        }
        
        public function stopAll(type:int):void {
        	var sound:Object;
        	for (var name:String in this.sounds) {
        		sound = this.sounds[name];
        		if (sound.type == type) {
        			this.stopSound(name);
        		}
        	}
        }
	}
}