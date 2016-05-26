package com.canaan.lib.managers
{
	import com.canaan.lib.interfaces.IMouseClient;
	
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class MouseManager
	{
		private static var canInstantiate:Boolean;
		private static var instance:MouseManager;
		
		private var mSections:Dictionary = new Dictionary();
		private var _mousePoint:Point = new Point();
		private var _mouseDownPoint:Point = new Point();
		
		public function MouseManager()
		{
			if (!canInstantiate) {
				throw new Error("Can not instantiate, use getInstance() instead.");
			}
		}
		
		public static function getInstance():MouseManager {
			if (instance == null) {
				canInstantiate = true;
				instance = new MouseManager();
				canInstantiate = false;
			}
			return instance;
		}
		
		public function initialize():void {
			StageManager.getInstance().registerHandler(MouseEvent.MOUSE_MOVE, onMouseMove);
			StageManager.getInstance().registerHandler(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseMove():void {
			_mousePoint.x = StageManager.getInstance().stage.mouseX;
			_mousePoint.y = StageManager.getInstance().stage.mouseY;
		}
		
		private function onMouseDown():void {
			_mouseDownPoint.x = StageManager.getInstance().stage.mouseX;
			_mouseDownPoint.y = StageManager.getInstance().stage.mouseY;
		}
		
		public function setMouseDownPosition(x:Number, y:Number):void {
			_mouseDownPoint.x = x;
			_mouseDownPoint.y = y;
		}
		
		public function registerSection(name:String, target:InteractiveObject):void {
			deleteSection(name);
			mSections[name] = new MouseSection(name, target);
		}
		
		public function deleteSection(name:String):void {
			var section:MouseSection = mSections[name];
			if (section != null) {
				delete mSections[name];
				section.dispose();
				section = null;
			}
		}
		
		public function enableSection(name:String):void {
			var section:MouseSection = mSections[name];
			if (section != null) {
				section.enabled = true;
			}
		}
		
		public function disableSection(name:String):void {
			var section:MouseSection = mSections[name];
			if (section != null) {
				section.enabled = false;
			}
		}
		
		public function addMouseClient(name:String, mouseClient:IMouseClient):void {
			var section:MouseSection = mSections[name];
			if (section != null) {
				section.addMouseClient(mouseClient);
			}
		}
		
		public function removeMouseClient(name:String, mouseClient:IMouseClient):void {
			var section:MouseSection = mSections[name];
			if (section != null) {
				section.removeMouseClient(mouseClient);
			}
		}
		
		public function removeAllMouseClients(name:String):void {
			var section:MouseSection = mSections[name];
			if (section != null) {
				section.removeAllMouseClients();
			}
		}
		
		public function get mousePoint():Point {
			return _mousePoint;
		}
		
		public function get mouseDownPoint():Point {
			return _mouseDownPoint;
		}
	}
}

import com.canaan.lib.interfaces.IMouseClient;
import com.canaan.lib.managers.MouseManager;
import com.canaan.lib.utils.ArrayUtil;

import flash.display.InteractiveObject;
import flash.events.MouseEvent;

class MouseSection
{
	private var _name:String;
	private var _target:InteractiveObject;
	private var _enabled:Boolean;
	private var mMouseClients:Vector.<IMouseClient>;
	private var mCurrentClient:IMouseClient;
	
	public function MouseSection(name:String, target:InteractiveObject)
	{
		_name = name;
		_target = target;
		enabled = true;
		mMouseClients = new Vector.<IMouseClient>();
	}
	
	public function get name():String {
		return _name;
	}
	
	public function set name(value:String):void {
		_name = value;
	}
	
	public function get target():InteractiveObject {
		return _target;
	}
	
	public function set target(value:InteractiveObject):void {
		_target = value;
	}
	
	public function get enabled():Boolean {
		return _enabled;
	}
	
	public function set enabled(value:Boolean):void {
		if (_enabled != value) {
			_enabled = value;
			if (value) {
				_target.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				_target.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				_target.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			} else {
				_target.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				_target.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				_target.removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			}
		}
	}
	
	public function dispose():void {
		enabled = false;
		_name = null;
		_target = null;
		mCurrentClient = null;
		mMouseClients = null;
	}
	
	public function addMouseClient(mouseClient:IMouseClient):void {
		ArrayUtil.addElements(mMouseClients, mouseClient);
	}
	
	public function removeMouseClient(mouseClient:IMouseClient):void {
		ArrayUtil.removeElements(mMouseClients, mouseClient);
	}
	
	public function removeAllMouseClients():void {
		ArrayUtil.dispose(mMouseClients);
	}
	
	private function onMouseMove(event:MouseEvent):void {
		if (_enabled) {
			var minDeep:int = int.MIN_VALUE;
			var deep:int;
			var hitClient:IMouseClient;
			for each (var mouseClient:IMouseClient in mMouseClients) {
				if (mouseClient.mouseClientEnabled && mouseClient.mouseClientHitTest(MouseManager.getInstance().mousePoint)) {
					deep = mouseClient.mouseClientDeep;
					if (deep >= minDeep) {
						minDeep = deep;
						hitClient = mouseClient;
					}
				}
			}
			if (mCurrentClient != hitClient) {
				if (mCurrentClient != null) {
					mCurrentClient.mouseClientMouseOut(new MouseEvent(MouseEvent.MOUSE_OUT, false));
				}
				mCurrentClient = hitClient;
				if (mCurrentClient != null) {
					mCurrentClient.mouseClientMouseOver(new MouseEvent(MouseEvent.MOUSE_OVER, false));
				}
			} else {
				if (mCurrentClient != null) {
					mCurrentClient.mouseClientMouseMove(new MouseEvent(MouseEvent.MOUSE_MOVE, false));
				}
			}
		}
	}
	
	private function onMouseDown(event:MouseEvent):void {
		if (_enabled) {
			if (mCurrentClient != null) {
				event.stopImmediatePropagation();
				MouseManager.getInstance().setMouseDownPosition(event.stageX, event.stageY);
				mCurrentClient.mouseClientMouseDown(new MouseEvent(MouseEvent.MOUSE_DOWN, false));
			}
		}
	}
	
	private function onMouseOut(event:MouseEvent):void {
		if (_enabled) {
			if (mCurrentClient != null) {
				mCurrentClient.mouseClientMouseOut(new MouseEvent(MouseEvent.MOUSE_OUT, false));
				mCurrentClient = null;
			}
		}
	}
}