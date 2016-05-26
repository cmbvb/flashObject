package com.canaan.lib.display
{
	import com.canaan.lib.core.Method;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class InteractiveSprite extends BaseSprite
	{
		protected var _bitmapEx:BitmapEx;
		protected var _intersect:Boolean;
		protected var _mouseUp:Method;
		protected var _mouseDown:Method;
		protected var _mouseMove:Method;
		protected var _mouseOver:Method;
		protected var _mouseOut:Method;
		protected var _mouseClick:Method;
		
		public function InteractiveSprite()
		{
			initialize();
		}
		
		protected function initialize():void {
			_bitmapEx = new BitmapEx();
			addChild(_bitmapEx);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		protected function onMouseUp(event:MouseEvent):void {
			if (!_intersect) {
				return;
			}
			executeMouseUp();
		}
		
		protected function onMouseDown(event:MouseEvent):void {
			if (!_intersect) {
				return;
			}
			executeMouseDown();
		}
		
		protected function onMouseClick(event:MouseEvent):void {
			if (!_intersect) {
				return;
			}
			executeMouseClick();
		}
		
		protected function onMouseMove(event:MouseEvent):void {
			var currTest:Boolean = getIntersect();
			if (_intersect) {
				executeMouseMove();
			}
			if (!_intersect && currTest) {
				executeMouseOver();
			}
			if (_intersect && !currTest) {
				executeMouseOut();
			}
			_intersect = currTest;
		}
		
		protected function onMouseOut(event:MouseEvent):void {
			if (_intersect) {
				executeMouseOut();
				_intersect = false;
			}
		}
		
		protected function executeMouseUp():void {
			if (_mouseUp != null) {
				_mouseUp.apply();
			}
		}
		
		protected function executeMouseDown():void {
			if (_mouseDown != null) {
				_mouseDown.apply();
			}
		}
		
		protected function executeMouseMove():void {
			if (_mouseMove != null) {
				_mouseMove.apply();
			}
		}
		
		protected function executeMouseOver():void {
			if (_mouseOver != null) {
				_mouseOver.apply();
			}
		}
		
		protected function executeMouseOut():void {
			if (_mouseOut != null) {
				_mouseOut.apply();
			}
		}
		
		protected function executeMouseClick():void {
			if (_mouseClick != null) {
				_mouseClick.apply();
			}
		}
		
		protected function getIntersect():Boolean {
			return _bitmapEx.getIntersect(new Point(_bitmapEx.mouseX, _bitmapEx.mouseY), this);
		}
		
		override public function dispose():void {
			super.dispose();
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			removeEventListener(MouseEvent.CLICK, onMouseClick);
			_mouseUp = null;
			_mouseDown = null;
			_mouseMove = null;
			_mouseOver = null;
			_mouseOut = null;
			_mouseClick = null;
		}
		
		public function get bitmapData():BitmapData {
			return _bitmapEx.bitmapData;
		}
		
		public function set bitmapData(value:BitmapData):void {
			_bitmapEx.bitmapDataEx = new BitmapDataEx(value);
		}

		public function get mouseUp():Method {
			return _mouseUp;
		}

		public function set mouseUp(value:Method):void {
			_mouseUp = value;
		}

		public function get mouseDown():Method {
			return _mouseDown;
		}

		public function set mouseDown(value:Method):void {
			_mouseDown = value;
		}

		public function get mouseMove():Method {
			return _mouseMove;
		}

		public function set mouseMove(value:Method):void {
			_mouseMove = value;
		}
		
		public function get mouseOver():Method {
			return _mouseOver;
		}
		
		public function set mouseOver(value:Method):void {
			_mouseOver = value;
		}

		public function get mouseOut():Method {
			return _mouseOut;
		}

		public function set mouseOut(value:Method):void {
			_mouseOut = value;
		}

		public function get mouseClick():Method {
			return _mouseClick;
		}

		public function set mouseClick(value:Method):void {
			_mouseClick = value;
		}
	}
}