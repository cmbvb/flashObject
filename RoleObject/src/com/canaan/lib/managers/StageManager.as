package com.canaan.lib.managers
{
	import com.canaan.lib.core.Config;
	import com.canaan.lib.core.Methods;
	import com.canaan.lib.utils.MathUtil;
	import com.canaan.lib.utils.StageUtil;
	
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public class StageManager
	{
		private static var canInstantiate:Boolean;
		private static var instance:StageManager;
		
		private var _stage:Stage;
		private var _screenWidth:int;
		private var _screenHeight:int;
		private var _interval:int;
		private var _intervalSecond:Number;
		private var _baseInterval:int;
		private var _baseIntervalSecond:Number;
		private var _baseFps:int;
		private var _fpsMultiple:Number;
		private var _tmpFps:int;
		private var _currentFps:int;
		private var _currentTime:int;
		
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
			_stage.addEventListener(MouseEvent.RIGHT_CLICK, onMouseRightClick);
			_stage.addEventListener(Event.RESIZE, onResize);
			_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			fps = Config.getConfig("fps");
			baseFps = Config.getConfig("baseFps");
			onResize();
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
				StageUtil.fpsMultiple = fps / baseFps;
				StageUtil.fps = fps;
				StageUtil.interval = _interval;
				_currentFps = value;
			}
		}
		
		public function get baseFps():int {
			return _baseFps;
		}
		
		public function set baseFps(value:int):void {
			if (value > 0) {
				_baseFps = value;
				_baseInterval = 1000 / baseFps;
				_baseIntervalSecond = 1 / baseFps;
				StageUtil.fpsMultiple = fps / _baseFps;
				StageUtil.baseFps = baseFps;
				StageUtil.baseInterval = _baseInterval;
			}
		}
		
		public function get interval():int {
			return _interval;
		}
		
		public function get intervalSecond():Number {
			return _intervalSecond;
		}
		
		public function get baseInterval():int {
			return _baseInterval;
		}
		
		public function get baseIntervalSecond():Number {
			return _baseIntervalSecond;
		}
		
		public function get currentFps():int {
			return _currentFps;
		}
		
		public function get currentTime():int {
			return _currentTime;
		}
		
		public function get screenWidth():int {
			return _screenWidth;
		}
		
		public function get screenHeight():int {
			return _screenHeight;
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
		
		private function onResize(event:Event = null):void {
			var maxScreenWidth:Number = Config.getConfig("maxScreenWidth") || _stage.stageWidth;
			var minScreenWidth:Number = Config.getConfig("minScreenWidth") || _stage.stageWidth;
			var maxScreenHeight:Number = Config.getConfig("maxScreenHeight") || _stage.stageHeight;
			var minScreenHeight:Number = Config.getConfig("minScreenHeight") || _stage.stageHeight;
			_screenWidth = MathUtil.rangeLimit(_stage.stageWidth, minScreenWidth, maxScreenWidth);
			_screenHeight = MathUtil.rangeLimit(_stage.stageHeight, minScreenHeight, maxScreenHeight);
		}
		
		private function onEnterFrame(event:Event):void {
			var time:int = getTimer();
			if (time - 1000 > _currentTime) {
				_currentTime = time;
				_currentFps = _tmpFps;
				_tmpFps = 0;
			}
			_tmpFps++;
		}
		
		private function onMouseRightClick(event:MouseEvent):void {
			
		}
	}
}