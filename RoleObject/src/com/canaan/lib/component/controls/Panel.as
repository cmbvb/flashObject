/**
 * Morn UI Version 2.4.1027 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package com.canaan.lib.component.controls {
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**面板*/
	public class Panel extends Container {
		protected var _content:Box;
		protected var _vScrollBar:VScrollBar;
		protected var _hScrollBar:HScrollBar;
		protected var _vScrollBarLeft:Boolean;
		protected var _hScrollBarTop:Boolean;
		protected var _vScrollBarVisible:Boolean;
		protected var _hScrollBarVisible:Boolean;
		protected var _vScrollBarShowForever:Boolean;
		protected var _hScrollBarShowForever:Boolean;
		protected var _scrollBarOffset:int;
		
		public function Panel() {
			width = height = 100;
			_vScrollBarVisible = true;
			_hScrollBarVisible = true;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			super.addChild(_content = new Box());
		}
		
		override public function addChild(child:DisplayObject):DisplayObject {
			callLater(changeScroll);
			return _content.addChild(child);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			callLater(changeScroll);
			return _content.addChildAt(child, index);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject {
			callLater(changeScroll);
			return _content.removeChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject {
			callLater(changeScroll);
			return _content.removeChildAt(index);
		}
		
		override public function dispose():void {
			_content.dispose();
			_content = null;
			super.dispose();
		}
		
		override public function removeAllChild(except:DisplayObject = null):void {
			for (var i:int = _content.numChildren - 1; i > -1; i--) {
				if (except != _content.getChildAt(i)) {
					_content.removeChildAt(i);
				}
			}
			callLater(changeScroll);
		}
		
		override public function removeAllChildren(dispose:Boolean=false):void {
			_content.removeAllChildren(dispose);
			callLater(changeScroll);
		}
		
		override public function getChildAt(index:int):DisplayObject {
			return _content.getChildAt(index);
		}
		
		override public function getChildByName(name:String):DisplayObject {
			return _content.getChildByName(name);
		}
		
		override public function getChildIndex(child:DisplayObject):int {
			return _content.getChildIndex(child);
		}
		
		override public function get numChildren():int {
			return _content.numChildren;
		}
		
		protected function changeScroll():void {
			var vShow:Boolean = _vScrollBar && _content.height > _height;
			var hShow:Boolean = _hScrollBar && _content.width > _width;
			var contentWidth:Number = vShow ? _width - _vScrollBar.width : _width;
			var contentHeight:Number = hShow ? _height - _hScrollBar.height : _height;
			_content.scrollRect = new Rectangle(0, 0, contentWidth, contentHeight);
			if (_vScrollBar) {
				if (_vScrollBarVisible == true) {
					_vScrollBar.visible = _vScrollBarShowForever || _content.height > _height;
				} else {
					_vScrollBar.visible = false;
				}
				if (_vScrollBarShowForever || _content.height > _height) {
					if (_vScrollBarLeft) {
						_vScrollBar.x = 0;
						_content.x = _vScrollBar.width;
					} else {
						_vScrollBar.x = _width - _vScrollBar.width;
						_content.x = 0;
					}
					_vScrollBar.y = 0;
					_vScrollBar.height = _height - (hShow ? _hScrollBar.height : 0) + _scrollBarOffset;
					_vScrollBar.scrollSize = _content.height * 0.1;
					_vScrollBar.thumbPercent = contentHeight / _content.height;
					_vScrollBar.setScroll(0, _content.height - contentHeight, _vScrollBar.value);
				}
			}
			if (_hScrollBar) {
				if (_hScrollBarVisible == true) {
					_hScrollBar.visible = _hScrollBarShowForever || _content.width > _width;
				} else {
					_hScrollBar.visible = false;
				}
				if (_hScrollBarShowForever || _content.width > _width) {
					if (_hScrollBarTop) {
						_hScrollBar.y = 0;
						_content.y = _hScrollBar.height;
					} else {
						_hScrollBar.y = _height - _hScrollBar.height;
						_content.y = 0;
					}
					_hScrollBar.x = 0;
					_hScrollBar.width = _width - (vShow ? _vScrollBar.width : 0) + _scrollBarOffset;
					_hScrollBar.thumbPercent = contentWidth / _content.width;
					_hScrollBar.setScroll(0, _content.width - contentWidth, _hScrollBar.value);
				}
			}
			createContentBg();
		}
		
		protected function createContentBg():void {
			var g:Graphics = _content.graphics;
			g.clear();
			g.beginFill(0xffff00, 0);
			g.drawRect(0, 0, _content.width, _content.height);
			g.endFill();
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			callLater(changeScroll);
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			callLater(changeScroll);
		}
		
		/**垂直滚动条皮肤*/
		public function get vScrollBarSkin():String {
			return _vScrollBar.skin;
		}
		
		public function set vScrollBarSkin(value:String):void {
			if (_vScrollBar == null) {
				super.addChild(_vScrollBar = new VScrollBar());
				_vScrollBar.addEventListener(Event.CHANGE, onScrollBarChange);
				_vScrollBar.target = this;
				callLater(changeScroll);
			}
			_vScrollBar.skin = value;
		}
		
		/**水平滚动条皮肤*/
		public function get hScrollBarSkin():String {
			return _hScrollBar.skin;
		}
		
		public function set hScrollBarSkin(value:String):void {
			if (_hScrollBar == null) {
				super.addChild(_hScrollBar = new HScrollBar());
				_hScrollBar.addEventListener(Event.CHANGE, onScrollBarChange);
				_hScrollBar.target = this;
				callLater(changeScroll);
			}
			_hScrollBar.skin = value;
		}
		
		public function get vScrollBarLeft():Boolean {
			return _vScrollBarLeft;
		}
		
		public function set vScrollBarLeft(value:Boolean):void {
			if (_vScrollBarLeft != value) {
				_vScrollBarLeft = value;
				callLater(changeScroll);
			}
		}
		
		public function get hScrollBarTop():Boolean {
			return _hScrollBarTop;
		}
		
		public function set hScrollBarTop(value:Boolean):void {
			if (_hScrollBarTop != value) {
				_hScrollBarTop = value;
				callLater(changeScroll);
			}
		}
		
		public function get vScrollBarVisible():Boolean {
			return _vScrollBarVisible;
		}
		
		public function set vScrollBarVisible(value:Boolean):void {
			if (_vScrollBarVisible != value) {
				_vScrollBarVisible = value;
				callLater(changeScroll);
			}
		}
		
		public function get hScrollBarVisible():Boolean {
			return _hScrollBarVisible;
		}
		
		public function set hScrollBarVisible(value:Boolean):void {
			if (_hScrollBarVisible != value) {
				_hScrollBarVisible = value;
				callLater(changeScroll);
			}
		}
		
		public function get vScrollBarShowForever():Boolean {
			return _vScrollBarShowForever;
		}
		
		public function set vScrollBarShowForever(value:Boolean):void {
			if (_vScrollBarShowForever != value) {
				_vScrollBarShowForever = value;
				callLater(changeScroll);
			}
		}
		
		public function get hScrollBarShowForever():Boolean {
			return _hScrollBarShowForever;
		}
		
		public function set hScrollBarShowForever(value:Boolean):void {
			if (_hScrollBarShowForever != value) {
				_hScrollBarShowForever = value;
				callLater(changeScroll);
			}
		}
		
		public function get scrollBarOffset():int {
			return _scrollBarOffset;
		}
		
		public function set scrollBarOffset(value:int):void {
			if (_scrollBarOffset != value) {
				_scrollBarOffset = value;
				callLater(changeScroll);
			}
		}
		
		/**垂直滚动条*/
		public function get vScrollBar():ScrollBar {
			return _vScrollBar;
		}
		
		/**水平滚动条*/
		public function get hScrollBar():ScrollBar {
			return _hScrollBar;
		}
		
		/**内容容器*/
		public function get content():Sprite {
			return _content;
		}
		
		protected function onScrollBarChange(e:Event):void {
			var rect:Rectangle = _content.scrollRect;
			if (rect) {
				var scroll:ScrollBar = e.currentTarget as ScrollBar;
				var start:int = Math.round(scroll.value);
				scroll.direction == ScrollBar.VERTICAL ? rect.y = start : rect.x = start;
				_content.scrollRect = rect;
			}
		}
		
		override public function commitMeasure():void {
			exeCallLater(changeScroll);
		}
		
		/**滚动到某个位置*/
		public function scrollTo(x:Number = 0, y:Number = 0):void {
			commitMeasure();
			if (vScrollBar) {
				vScrollBar.value = y;
			}
			if (hScrollBar) {
				hScrollBar.value = x;
			}
		}
	}
}