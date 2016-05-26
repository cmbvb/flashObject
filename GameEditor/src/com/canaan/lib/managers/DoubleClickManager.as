package com.canaan.lib.managers
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public class DoubleClickManager
	{
		public var delay:Number = 270;
		
		private static var canInstantiate:Boolean;
		private static var instance:DoubleClickManager;
		
		private var dictionary:Dictionary = new Dictionary();
		
		public function DoubleClickManager()
		{
			if (!canInstantiate) {
				throw new Error("Can not instantiate, use getInstance() instead.");
			}
		}
		
		public static function getInstance():DoubleClickManager {
			if (instance == null) {
				canInstantiate = true;
				instance = new DoubleClickManager();
				canInstantiate = false;
			}
			return instance;
		}
		
		public function register(target:InteractiveObject, listener:Function, args:Array = null):void {
			var doubleClickItem:DoubleClickItem = DoubleClickItem.fromPool();
			doubleClickItem.target = target;
			doubleClickItem.listener = listener;
			doubleClickItem.args = args;
			dictionary[target] = doubleClickItem;
			target.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		public function del(target:InteractiveObject):void {
			var doubleClickItem:DoubleClickItem = dictionary[target];
			if (doubleClickItem != null) {
				target.removeEventListener(MouseEvent.CLICK, onMouseClick);
				delete dictionary[target];
				DoubleClickItem.toPool(doubleClickItem);
			}
		}
		
		private function onMouseClick(event:MouseEvent):void {
			var target:InteractiveObject = event.currentTarget as InteractiveObject;
			var doubleClickItem:DoubleClickItem = dictionary[target];
			var time:Number = getTimer();
			var diff:Number = time - doubleClickItem.time;
			if (doubleClickItem.clicked && diff <= delay) {
				doubleClickItem.apply();
				doubleClickItem.clicked = false;
			} else {
				doubleClickItem.clicked = true;
				doubleClickItem.time = time;
			}
		}
	}
}

import com.canaan.lib.core.ObjectPool;
import com.canaan.lib.interfaces.IPoolableObject;

import flash.display.InteractiveObject;

class DoubleClickItem implements IPoolableObject
{
	public var target:InteractiveObject;
	public var listener:Function;
	public var args:Array;
	public var clicked:Boolean;
	public var time:Number = 0;
	
	public function DoubleClickItem()
	{

	}
	
	public function poolInitialize(data:Object = null):void {
		
	}
	
	public function poolDestory():void {
		target = null;
		listener = null;
		args = null;
		clicked = false;
		time = 0;
	}
	
	public function apply():void {
		if (listener != null) {
			listener.apply(null, args);
		}
	}
	
	public static function fromPool():DoubleClickItem {
		return ObjectPool.get(DoubleClickItem) as DoubleClickItem;
	}
	
	public static function toPool(doubleClickItem:DoubleClickItem):void {
		ObjectPool.put(doubleClickItem);
	}
}