package com.canaan.lib.display
{
	import com.canaan.lib.interfaces.IDispose;
	import com.canaan.lib.managers.StageManager;
	import com.canaan.lib.utils.DisplayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class BaseSprite extends Sprite implements IDispose
	{
		protected var _resizeHandler:Function;
		
		public function BaseSprite()
		{
			super();
		}
		
		public function center(offsetX:Number = 0, offsetY:Number = 0):void {
			DisplayUtil.center(this, offsetX, offsetY);
		}
		
		public function centerToParent(offsetX:Number = 0, offsetY:Number = 0):void {
			DisplayUtil.centerToParent(this, offsetX, offsetY);
		}
		
		public function moveTo(x:Number, y:Number):void {
			this.x = x;
			this.y = y;
		}
		
		public function setSize(width:Number, height:Number):void {
			this.width = width;
			this.height = height;
		}
		
		public function set scale(value:Number):void {
			scaleX = scaleY = value;
		}
		
		public function get scale():Number {
			return scaleX;
		}
		
		public function removeChildByName(name:String):DisplayObject {
			var child:DisplayObject = getChildByName(name);
			if (child) {
				return removeChild(child);
			}
			return null;
		}
		
		public function remove(dispose:Boolean = false):void {
			DisplayUtil.removeChild(parent, this, dispose);
		}
		
		public function removeAllChildren(dispose:Boolean = false):void {
			DisplayUtil.removeAllChildren(this, dispose);
		}
		
		public function get resizeHandler():Function {
			return _resizeHandler;
		}
		
		public function set resizeHandler(value:Function):void {
			if (_resizeHandler != value) {
				if (_resizeHandler != null) {
					StageManager.getInstance().deleteHandler(Event.RESIZE, _resizeHandler);
				}
				_resizeHandler = value;
				if (_resizeHandler != null) {
					StageManager.getInstance().registerHandler(Event.RESIZE, _resizeHandler);
				}
			}
		}
		
		public function get instanceClass():Class {
			return getDefinitionByName(getQualifiedClassName(this)) as Class;
		}
		
		public function dispose():void {
			removeAllChildren(true);
			remove();
			graphics.clear();
			resizeHandler = null;
		}
	}
}