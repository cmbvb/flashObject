package com.canaan.lib.managers
{
	import com.canaan.lib.component.IToolTip;
	import com.canaan.lib.component.IToolTipManagerClient;
	import com.canaan.lib.component.Styles;
	import com.canaan.lib.component.UIPosition;
	import com.canaan.lib.component.controls.ToolTip;
	import com.canaan.lib.events.UIEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class ToolTipManager extends Sprite
	{
		private static var canInstantiate:Boolean;
		private static var instance:ToolTipManager;
		
		public static var offsetX:Number = 10;
		public static var offsetY:Number = 10;
		
		private var _enabled:Boolean = true;
		private var _showDelay:Number = Styles.toolTipShowDelay;
		private var _hideDelay:Number = Styles.toolTipHideDelay;
		private var _scrubDelay:Number = Styles.toolTipScrubDelay;
		private var _currentTarget:IToolTipManagerClient;
		private var _currentToolTip:IToolTip;
		private var _toolTipClass:Class = ToolTip;
		
		private var toolTipCache:Dictionary = new Dictionary(true);
		private var previousTarget:IToolTipManagerClient;
		private var currentToolTipData:Object;
		
		public function ToolTipManager()
		{
			super();
		}
		
		public static function getInstance():ToolTipManager {
			if (instance == null) {
				canInstantiate = true;
				instance = new ToolTipManager();
				canInstantiate = false;
			}
			return instance;
		}
		
		public function get enabled():Boolean {
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void {
			_enabled = value;
		}
		
		public function get showDelay():Number {
			return _showDelay;
		}
		
		public function set showDelay(value:Number):void {
			_showDelay = value;
		}
		
		public function get hideDelay():Number {
			return _hideDelay;
		}
		
		public function set hideDelay(value:Number):void {
			_hideDelay = value;
		}
		
		public function get scrubDelay():Number {
			return _scrubDelay;
		}
		
		public function set scrubDelay(value:Number):void {
			_scrubDelay = value;
		}
		
		public function get currentTarget():IToolTipManagerClient {
			return _currentTarget;
		}
		
		public function set currentTarget(value:IToolTipManagerClient):void {
			_currentTarget = value;
		}
		
		public function get currentToolTip():IToolTip {
			return _currentToolTip;
		}
		
		public function set currentToolTip(value:IToolTip):void {
			_currentToolTip = value;
		}
		
		public function get toolTipClass():Class {
			return _toolTipClass;
		}
		
		public function set toolTipClass(value:Class):void {
			_toolTipClass = value;
		}
		
		public function registerToolTip(target:DisplayObject, oldValue:Object, newValue:Object):void {
			if (!oldValue && newValue) {
				target.addEventListener(MouseEvent.ROLL_OVER, toolTipMouseOverHandler);
				target.addEventListener(MouseEvent.ROLL_OUT, toolTipMouseOutHandler);
				if (mouseIsOver(target)) {
					showImmediately(target);
				}
			} else if (oldValue && !newValue) {
				target.removeEventListener(MouseEvent.ROLL_OVER, toolTipMouseOverHandler);
				target.removeEventListener(MouseEvent.ROLL_OUT, toolTipMouseOutHandler);
				checkIfTargetChanged(target);
			} else {
				if (mouseIsOver(target)) {
					showImmediately(target);
				}
			}
		}
		
		private function mouseIsOver(target:DisplayObject):Boolean {
			if (!target || !target.stage) {
				return false;
			}
			if (target.stage.mouseX == 0 && target.stage.mouseY == 0) {
				return false;
			}
			return target.hitTestPoint(target.stage.mouseX, target.stage.mouseY, true);
		}
		
		private function toolTipMouseOverHandler(event:MouseEvent):void {
			checkIfTargetChanged(DisplayObject(event.target));
		}
		
		private function toolTipMouseOutHandler(event:MouseEvent):void {
			checkIfTargetChanged(event.relatedObject);
		}
		
		private function showImmediately(target:DisplayObject):void {
			var oldShowDelay:Number = showDelay;
			showDelay = 0;
			checkIfTargetChanged(target);
			showDelay = oldShowDelay;
		}
		
		private function hideImmediately(target:DisplayObject):void {
			checkIfTargetChanged(null);
		}
		
		private function checkIfTargetChanged(displayObject:DisplayObject):void {
			if (!enabled) {
				return;
			}
			findTarget(displayObject);
//			if (currentTarget != previousTarget) {
				targetChanged();
				previousTarget = currentTarget;
//			}
		}
		
		private function findTarget(displayObject:DisplayObject):void {
			while (displayObject) {
				if (displayObject is IToolTipManagerClient) {
					currentToolTipData = IToolTipManagerClient(displayObject).toolTip;
					if (currentToolTipData) {
						currentTarget = displayObject as IToolTipManagerClient;
						return;
					}
				}
				displayObject = displayObject.parent;
			}
			
			currentToolTipData = null;
			currentTarget = null;
		}
		
		private function targetChanged():void {
			if (previousTarget && currentTarget) {
				previousTarget.sendEvent(UIEvent.TOOL_TIP_CHANGED);
			}
			reset();
			if (currentTarget) {
				if (!currentToolTipData) {
					return;
				}
				currentTarget.sendEvent(UIEvent.TOOL_TIP_START);
//				if (showDelay == 0 || TimerManager.getInstance().running(scrubFunction)) {
				if (showDelay == 0) {
					showToolTip();
				} else {
					TimerManager.getInstance().doOnce(showDelay, showToolTip);
				}
			}
		}
		
		private function showToolTip():void {
			if (currentTarget) {
				createTip();
				initializeTip();
				positionTip();
				showTip();
			}
		}
		
		private function hideToolTip():void {
			if (hideDelay == 0) {
				hideTip();
			} else {
				TimerManager.getInstance().doOnce(hideDelay, hideTip);
			}
		}
		
		private function reset():void {
			TimerManager.getInstance().clear(showToolTip);
			TimerManager.getInstance().clear(hideTip);
//			TimerManager.getInstance().clear(moveToolTip);
			StageManager.getInstance().deleteHandler(MouseEvent.MOUSE_MOVE, moveToolTip);
			if (currentToolTip) {
				currentToolTip.onToolTipHide();
				removeChild(currentToolTip as DisplayObject);
				currentToolTip = null;
				TimerManager.getInstance().clear(scrubFunction);
				if (scrubDelay > 0) {
					TimerManager.getInstance().doOnce(scrubDelay, scrubFunction);
				}
			}
		}
		
		private function createTip():void {
			var clazz:Class = currentTarget.toolTipClass || toolTipClass;
			currentToolTip = toolTipCache[clazz];
			if (!currentToolTip) {
				currentToolTip = new clazz();
				toolTipCache[clazz] = currentToolTip;
			}
			if (currentToolTip is InteractiveObject) {
				InteractiveObject(currentToolTip).mouseEnabled = false;
			}
			if (currentToolTip is DisplayObjectContainer) {
				DisplayObjectContainer(currentToolTip).mouseChildren = false;
			}
			currentToolTip.visible = false;
			addChild(currentToolTip as DisplayObject);
		}
		
		private function initializeTip():void {
			currentToolTip.toolTipData = currentToolTipData;
		}
		
		private function positionTip():void {
			var stage:Stage = StageManager.getInstance().stage;
			var xx:Number;
			var yy:Number;
			var displayObject:DisplayObject = currentToolTip as DisplayObject;
			if (displayObject == null) {
				return;
			}
			var toolTipRect:Rectangle = displayObject.getBounds(displayObject);
			var rect:Rectangle = DisplayObject(currentTarget).getRect(stage);
			var centerX:Number = rect.left + (rect.width - toolTipRect.width) * 0.5;
			var centerY:Number = rect.top + (rect.height - toolTipRect.height) * 0.5;
			
			switch (currentTarget.toolTipPosition) {
				case UIPosition.BELOW:
					xx = centerX;
					yy = rect.bottom;
					break;
				case UIPosition.ABOVE:
					xx = centerX;
					yy = rect.top - toolTipRect.height;
					break;
				case UIPosition.LEFT:
					xx = rect.left - toolTipRect.width;
					yy = centerY;
					break;
				case UIPosition.RIGHT:
					xx = rect.right;
					yy = centerY;
					break;            
				case UIPosition.CENTER:
					xx = centerX;
					yy = centerY;
					break;            
				case UIPosition.TOP_LEFT:
					xx = rect.left;
					yy = rect.top;
					break;
				default:
					moveToolTip();
//					TimerManager.getInstance().doFrameLoop(1, moveToolTip);
					StageManager.getInstance().registerHandler(MouseEvent.MOUSE_MOVE, moveToolTip);
					return;
			}
			xx -= toolTipRect.left;
			yy -= toolTipRect.top;
			var offset:Point = currentTarget.toolTipOffset;
			if (offset) {
				xx += offset.x;
				yy += offset.y;
			}
			
			var stageWidth:Number = stage.stageWidth;
			var stageHeight:Number = stage.stageHeight;
			if (xx + toolTipRect.width > stageWidth) {
				xx = stageWidth - toolTipRect.width;
			}
			if (yy + toolTipRect.height > stageHeight) {
				yy = stageHeight - toolTipRect.height;
			}
			
			currentToolTip.x = xx;
			currentToolTip.y = yy;
		}
		
		private function showTip():void {
			if (currentTarget == null) {
				return;
			}
			currentTarget.sendEvent(UIEvent.TOOL_TIP_SHOW, currentToolTip);
//			StageManager.getInstance().registerHandler(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
			currentToolTip.visible = true;
			currentToolTip.onToolTipShow();
//			hideToolTip();
		}
		
		private function hideTip():void {
			if (previousTarget) {
				previousTarget.sendEvent(UIEvent.TOOL_TIP_HIDE, currentToolTip);
				StageManager.getInstance().deleteHandler(MouseEvent.MOUSE_DOWN, stageMouseDownHandler);
			}
			if (currentToolTip) {
				currentToolTip.visible = false;
				currentToolTip.onToolTipHide();
			}
		}
		
		private function stageMouseDownHandler():void {
			reset();
		}
		
		private function scrubFunction():void {
			
		}
		
		private function moveToolTip():void {
			var stage:Stage = StageManager.getInstance().stage;
			if (right > stage.stageWidth) {
				currentToolTip.x = mouseX - currentToolTip.width - offsetX;
			} else {
				currentToolTip.x = mouseX + offsetX;
			}
			if (top < 0 || bottom > stage.stageHeight) {
				currentToolTip.y = Math.max(0, mouseY - currentToolTip.height - offsetY);
			} else {
				currentToolTip.y = mouseY + offsetY;
			}
		}
		
		private function get right():Number {
			return mouseX + currentToolTip.width + offsetX;
		}
		
		private function get top():Number {
			return mouseY + offsetY;
		}
		
		private function get bottom():Number {
			return mouseY + currentToolTip.height + offsetY;
		}
	}
}