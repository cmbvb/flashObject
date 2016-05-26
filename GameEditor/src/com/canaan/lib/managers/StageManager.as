package com.canaan.lib.managers
{
	import com.canaan.lib.core.Config;
	import com.canaan.lib.core.Methods;
	
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class StageManager
	{
		private static var canInstantiate:Boolean;
		private static var instance:StageManager;
		
		private var _stage:Stage;
		private var _interval:int;
		private var _intervalSecond:Number;
		
		private var methodsDict:Dictionary = new Dictionary();

		public function StageManager()
		{
			if (!canInstantiate) {
				throw new Error("Can not instantiate, use getInstance() instead.");
			}
		}
		
		public static function getInstance():StageManager {
			if (instance == null) {
				canInstantiate = true;
				instance = new StageManager();
				canInstantiate = false;
			}
			return instance;
		}
		
		public function initialize(value:Stage):void {
			if (!value) {
				return;
			}
			_stage = value;
			_stage.align = StageAlign.TOP_LEFT;
			_stage.scaleMode = StageScaleMode.NO_SCALE;
			_stage.tabChildren = false;
			_stage.stageFocusRect = false;
			fps = Config.getConfig("fps");
		}
		
		public function get stage():Stage {
			return _stage;
		}
		
		public function get fps():int {
			return _stage.frameRate;
		}
		
		public function set fps(value:int):void {
			if (value > 0) {
				_stage.frameRate = value;
				_interval = 1000 / fps;
				_intervalSecond = 1 / fps;
			}
		}
		
		public function get interval():int {
			return _interval;
		}
		
		public function get intervalSecond():Number {
			return _intervalSecond;
		}
		
		public function get screenWidth():Number {
			var maxScreenWidth:Number = Config.getConfig("maxScreenWidth") || _stage.stageWidth;
			var minScreenWidth:Number = Config.getConfig("minScreenWidth") || _stage.stageWidth;
			return Math.min(maxScreenWidth, Math.max(minScreenWidth, _stage.stageWidth));
		}
		
		public function get screenHeight():Number {
			var maxScreenHeight:Number = Config.getConfig("maxScreenHeight") || _stage.stageHeight;
			var minScreenHeight:Number = Config.getConfig("minScreenHeight") || _stage.stageHeight;
			return Math.min(maxScreenHeight, Math.max(minScreenHeight, _stage.stageHeight));
		}

		public function registerHandler(type:String, func:Function, args:Array = null):void {
			var methods:Methods = methodsDict[type];
			if (!methods) {
				methods = new Methods();
				methodsDict[type] = methods;
				_stage.addEventListener(type, eventHandler);
			}
			methods.register(func, args);
		}
		
		public function deleteHandler(type:String, func:Function):void {
			var methods:Methods = methodsDict[type];
			if (methods) {
				methods.del(func);
				if (methods.length == 0) {
					delete methodsDict[type];
					_stage.removeEventListener(type, eventHandler);
				}
			}
		}
		
		private function eventHandler(event:Event):void {
			var methods:Methods = methodsDict[event.type];
			if (methods) {
				methods.apply();
			}
		}
	}
}