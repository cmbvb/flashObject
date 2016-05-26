package com.canaan.lib.component
{
	import com.canaan.lib.display.BaseSprite;
	import com.canaan.lib.display.effects.Glow;
	import com.canaan.lib.events.GuideEvent;
	import com.canaan.lib.events.UIEvent;
	import com.canaan.lib.interfaces.IDispose;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.managers.RenderManager;
	import com.canaan.lib.managers.StageManager;
	import com.canaan.lib.managers.ToolTipManager;
	import com.canaan.lib.utils.DisplayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	[Event(name="renderCompleted", type="com.canaan.lib.events.UIEvent")]
	[Event(name="resize", type="com.canaan.lib.events.UIEvent")]
	[Event(name="toolTipChanged", type="com.canaan.lib.events.UIEvent")]
	[Event(name="toolTipStart", type="com.canaan.lib.events.UIEvent")]
	[Event(name="toolTipShow", type="com.canaan.lib.events.UIEvent")]
	[Event(name="toolTipHide", type="com.canaan.lib.events.UIEvent")]
	
	public class UIComponent extends BaseSprite implements IUIComponent, IToolTipManagerClient, IDispose
	{
		public static var langFunc:Function;
		public static var guideControls:Dictionary = new Dictionary();
		
		protected var _data:Object;
		protected var _data2:Object;
		protected var _width:Number;
		protected var _height:Number;
		protected var _contentWidth:Number = 0;
		protected var _contentHeight:Number = 0;
		protected var _disabled:Boolean;
		protected var _dataSource:Object;
		protected var _comXml:XML;
		protected var _glow:Boolean;
		protected var _glowColor:uint;
		protected var _glowEffect:Glow;
		
		protected var _toolTip:Object;
		protected var _toolTipClass:Class;
		protected var _toolTipPosition:String;
		protected var _toolTipOffset:Point;
		protected var _toolTipLangId:int;
		protected var _toolTipLangArgs:Array;
		protected var _guideId:String;
		
		public function UIComponent()
		{
			super();
			tabEnabled = false;
			tabChildren = false;
			mouseChildren = false;
			preinitialize();
			createChildren();
			initialize();
		}
		
		protected function preinitialize():void {
			_glowColor = Styles.glowColor;
		}
		
		protected function createChildren():void {
			
		}
		
		protected function initialize():void {
			
		}
		
		public function get data():Object {
			return _data;
		}
		
		public function set data(value:Object):void {
			_data = value;
		}
		
		public function get data2():Object {
			return _data2;
		}
		
		public function set data2(value:Object):void {
			_data2 = value;
		}
		
		public function get disabled():Boolean {
			return _disabled;
		}
		
		public function set disabled(value:Boolean):void {
			if (_disabled != value) {
				_disabled = value;
				mouseEnabled = !value;
				mouseChildren = !value;
				DisplayUtil.gray(this, _disabled);
			}
		}
		
		public function setGrey():void {
			DisplayUtil.gray(this, true);
		}
		
		public function clearGrey():void {
			DisplayUtil.gray(this, false);
		}
		
		public function setFocus():void {
			if (StageManager.getInstance().stage) {
				StageManager.getInstance().stage.focus = this;
			}
		}
		
		override public function set x(value:Number):void {
			super.x = value;
			callLater(sendEvent, [UIEvent.MOVE]);
		}
		
		override public function set y(value:Number):void {
			super.y = value;
			callLater(sendEvent, [UIEvent.MOVE]);
		}
		
		/**宽度(值为NaN时，宽度为自适应大小)*/
		override public function get width():Number {
			if (!isNaN(_width)) {
				return _width;
			} else if (_contentWidth != 0) {
				return _contentWidth;
			} else {
				return measureWidth;
			}
		}
		
		/**显示的宽度(width * scaleX)*/
		public function get displayWidth():Number {
			return width * scaleX;
		}
		
		protected function get measureWidth():Number {
			commitMeasure();
			var max:Number = 0;
			for (var i:int = numChildren - 1; i > -1; i--) {
				var comp:DisplayObject = getChildAt(i);
				if (comp.visible) {
					max = Math.max(comp.x + comp.width * comp.scaleX, max);
				}
			}
			return max;
		}
		
		override public function set width(value:Number):void {
			if (_width != value) {
				_width = value;
				callLater(changeSize);
			}
		}
		
		/**高度(值为NaN时，高度为自适应大小)*/
		override public function get height():Number {
			if (!isNaN(_height)) {
				return _height;
			} else if (_contentHeight != 0) {
				return _contentHeight;
			} else {
				return measureHeight;
			}
		}
		
		/**显示的高度(height * scaleY)*/
		public function get displayHeight():Number {
			return height * scaleY;
		}
		
		protected function get measureHeight():Number {
			commitMeasure();
			var max:Number = 0;
			for (var i:int = numChildren - 1; i > -1; i--) {
				var comp:DisplayObject = getChildAt(i);
				if (comp.visible) {
					max = Math.max(comp.y + comp.height * comp.scaleY, max);
				}
			}
			return max;
		}
		
		override public function set height(value:Number):void {
			if (_height != value) {
				_height = value;
				callLater(changeSize);
			}
		}
		
		override public function set scaleX(value:Number):void {
			super.scaleX = value;
			callLater(changeSize);
		}
		
		override public function set scaleY(value:Number):void {
			super.scaleY = value;
			callLater(changeSize);
		}
		
		/**执行影响宽高的延迟函数*/
		public function commitMeasure():void {
			
		}
		
		protected function changeSize():void {
			sendEvent(Event.RESIZE);
		}
		
		public function callLater(func:Function, args:Array = null):void {
			RenderManager.getInstance().callLater(func, args);
		}
		
		public function exeCallLater(func:Function):void {
			RenderManager.getInstance().exeCallLater(func);
		}
		
		public function sendEvent(type:String, data:Object = null):void {
			if (hasEventListener(type)) {
				var event:UIEvent = new UIEvent(type, data);
				dispatchEvent(event);
			}
		}
		
		override public function dispose():void {
			super.dispose();
			clearGrey();
			_data = null;
			toolTip = null;
			guideId = null;
			_dataSource = null;
			if (_glowEffect != null) {
				_glowEffect.stop();
				_glowEffect = null;
			}
		}
		
		public function get toolTip():Object {
			return _toolTip;
		}
		
		public function set toolTip(value:Object):void {
			if (_toolTip != value) {
				var oldValue:Object = _toolTip;
				_toolTip = value;
				ToolTipManager.getInstance().registerToolTip(this, oldValue, value);
				sendEvent(UIEvent.TOOL_TIP_CHANGED);
			}
		}
		
		public function get toolTipLangId():int {
			return _toolTipLangId;
		}
		
		public function set toolTipLangId(value:int):void {
			if (_toolTipLangId != value) {
				_toolTipLangId = value;
				callLater(changeLocalToolTip);
			}
		}
		
		public function get toolTipLangArgs():Array {
			return _toolTipLangArgs;
		}
		
		public function set toolTipLangArgs(value:Array):void {
			if (_toolTipLangArgs != value) {
				_toolTipLangArgs = value;
				callLater(changeLocalToolTip);
			}
		}
		
		protected function changeLocalToolTip():void {
			toolTip = langFunc != null ? langFunc(_toolTipLangId, _toolTipLangArgs) : _toolTipLangId;
		}
		
		public function get toolTipClass():Class {
			return _toolTipClass;
		}
		
		public function set toolTipClass(value:Class):void {
			_toolTipClass = value;
		}
		
		public function get toolTipPosition():String {
			return _toolTipPosition;
		}
		
		public function set toolTipPosition(value:String):void {
			_toolTipPosition = value;
		}
		
		public function get toolTipOffset():Point {
			return _toolTipOffset;
		}
		
		public function set toolTipOffset(value:Point):void {
			_toolTipOffset = value;
		}
		
		public function get guideId():String {
			return _guideId;
		}
		
		public function set guideId(value:String):void {
			if (_guideId != value) {
				// 移除相同guideId的组件
				if (value != null && guideControls[value] != null) {
					guideControls[value].guideId = null;
				}
				delete guideControls[_guideId];
				if (_guideId != null) {
					EventManager.getInstance().dispatchEvent(new GuideEvent(GuideEvent.GUIDE_REMOVED_CONTROL, _guideId));
				}
				_guideId = value;
				if (_guideId) {
					doubleClickEnabled = true;
					guideControls[_guideId] = this;
					addEventListener(MouseEvent.CLICK, onGuideClick, false, int.MAX_VALUE);
					addEventListener(MouseEvent.DOUBLE_CLICK, onGuideDoubleClick, false, int.MAX_VALUE);
					addEventListener(MouseEvent.RIGHT_CLICK, onGuideRightClick, false, int.MAX_VALUE);
					addEventListener(Event.ADDED_TO_STAGE, onGuideAddedToStage);
					addEventListener(Event.REMOVED_FROM_STAGE, onGuideRemovedFromStage);
					onGuideAddedToStage(null);
				} else {
					removeEventListener(MouseEvent.CLICK, onGuideClick);
					removeEventListener(MouseEvent.DOUBLE_CLICK, onGuideDoubleClick);
					removeEventListener(MouseEvent.RIGHT_CLICK, onGuideRightClick);
					removeEventListener(Event.ADDED_TO_STAGE, onGuideAddedToStage);
					removeEventListener(Event.REMOVED_FROM_STAGE, onGuideRemovedFromStage);
				}
			}
		}
		
		protected function onGuideClick(event:MouseEvent):void {
			if (!_disabled) {
				EventManager.getInstance().dispatchEvent(new GuideEvent(GuideEvent.GUIDE_CLICK, this));
			}
		}
		
		protected function onGuideDoubleClick(event:MouseEvent):void {
			if (!_disabled) {
				EventManager.getInstance().dispatchEvent(new GuideEvent(GuideEvent.GUIDE_DOUBLE_CLICK, this));
			}
		}
		
		protected function onGuideRightClick(event:MouseEvent):void {
			if (!_disabled) {
				EventManager.getInstance().dispatchEvent(new GuideEvent(GuideEvent.GUIDE_RIGHT_CLICK, this));
			}
		}
		
		protected function onGuideAddedToStage(event:Event):void {
			EventManager.getInstance().dispatchEvent(new GuideEvent(GuideEvent.GUIDE_ADDED_TO_STAGE, this));
		}
		
		protected function onGuideRemovedFromStage(event:Event):void {
			EventManager.getInstance().dispatchEvent(new GuideEvent(GuideEvent.GUIDE_REMOVED_FROM_STAGE, this));
		}
		
		public function showBorder(color:uint = 0xff0000):void {
			if (getChildByName("border") == null) {
				var border:Shape = new Shape();
				border.name = "border";
				border.graphics.lineStyle(1, color);
				border.graphics.drawRect(0, 0, width, height);
				addChild(border);
			}
		}
		
		/**组件xml结构(高级用法：动态更改XML，然后通过页面重新渲染)*/
		public function get comXml():XML {
			return _comXml;
		}
		
		public function set comXml(value:XML):void {
			_comXml = value;
		}
		
		public function get dataSource():Object {
			return _dataSource;
		}
		
		public function set dataSource(value:Object):void {
			_dataSource = value;
			for (var prop:String in _dataSource) {
				if (hasOwnProperty(prop)) {
					this[prop] = _dataSource[prop];
				}
			}
		}

		public function get glow():Boolean {
			return _glow;
		}

		public function set glow(value:Boolean):void {
			if (_glow != value) {
				_glow = value;
				callLater(changeGlow);
			}
		}

		public function get glowColor():uint {
			return _glowColor;
		}

		public function set glowColor(value:uint):void {
			_glowColor = value;
			callLater(changeGlow);
		}

		protected function changeGlow():void {
			if (_glowEffect == null) {
				_glowEffect = new Glow();
			}
			if (_glow) {
				_glowEffect.start(this, _glowColor, 650, 5, 15, 0.5, 1, 2.5);
			} else {
				_glowEffect.stop();
			}
		}
	}
}