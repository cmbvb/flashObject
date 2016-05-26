package com.canaan.lib.component.controls
{
	import com.canaan.lib.component.UIComponent;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.DialogManager;
	import com.canaan.lib.managers.DragManager;
	import com.canaan.lib.utils.ArrayUtil;
	import com.canaan.lib.utils.StringUtil;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class Dialog extends View
	{
		public static const CLOSE:String = "close";
		public static const CANCEL:String = "cancel";
		public static const SURE:String = "sure";
		public static const NO:String = "no";
		public static const OK:String = "ok";
		public static const YES:String = "yes";
		
		protected var _dragArea:Rectangle;
		protected var _isPopup:Boolean;
		protected var _popupCenter:Boolean = true;
		protected var _isParallelDisplay:Boolean;
		protected var _closeHandler:Method;
		
		public function Dialog()
		{
			super();
		}
		
		override protected function initialize():void {
			super.initialize();
			var dragTarget:DisplayObject = getChildByName("drag");
			if (dragTarget) {
				dragArea = dragTarget.x + "," + dragTarget.y + "," + dragTarget.width + "," + dragTarget.height;
				removeChild(dragTarget);
			}
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onClick(event:MouseEvent):void {
			var component:UIComponent = event.target as UIComponent;
			if (component) {
				switch (component.name) {
					case CLOSE: 
					case CANCEL: 
					case SURE: 
					case NO: 
					case OK: 
					case YES: 
						close(component.name);
						break;
				}
			}
		}
		
		public function get isPopup():Boolean {
			return _isPopup;
		}
		
		public function set isPopup(value:Boolean):void {
			_isPopup = value;
		}
		
		public function get popupCenter():Boolean {
			return _popupCenter;
		}
		
		public function set popupCenter(value:Boolean):void {
			_popupCenter = value;
		}
		
		public function get isParallelDisplay():Boolean {
			return _isParallelDisplay;
		}
		
		public function set isParallelDisplay(value:Boolean):void {
			_isParallelDisplay = value;
		}
		
		public function get closeHandler():Method {
			return _closeHandler;
		}
		
		public function set closeHandler(value:Method):void {
			_closeHandler = value;
		}
		
		public function get dragArea():String {
			return StringUtil.rectToString(_dragArea);
		}
		
		public function set dragArea(value:String):void {
			if (value) {
				var a:Array = ArrayUtil.copyAndFill([0, 0, 0, 0], value);
				_dragArea = new Rectangle(a[0], a[1], a[2], a[3]);
				addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			} else {
				_dragArea = null;
				removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			}
		}
		
		protected function mouseDownHandler(event:MouseEvent):void {
			bringToFrong();
			if (event.target == this) {
				doDrag();
				return;
			}
			if (_dragArea.contains(mouseX, mouseY)) {
				doDrag();
			}
		}
		
		public function popup(modal:Boolean = false, closeOthers:Boolean = false, closeExcludedList:Array = null, x:Number = NaN, y:Number = NaN, showAnimation:Boolean = true):void {
			DialogManager.getInstance().popup(this, modal, closeOthers, closeExcludedList, x, y, showAnimation);
		}
		
		public function bringToFrong():void {
			DialogManager.getInstance().bringToFront(this);
		}
		
		public function resizeParallel():void {
			DialogManager.getInstance().resizeParallel();
		}

		public function close(type:String = null):void {
			DialogManager.getInstance().close(this);
			if (_closeHandler) {
				closeHandler.applyWith([type]);
			}
		}
		
		public function doDrag():void {
			DragManager.getInstance().doDrag(this);
		}
		
		override public function dispose():void {
			super.dispose();
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
	}
}