package com.canaan.lib.component.controls
{
	import com.canaan.lib.core.Method;
	
	import flash.events.MouseEvent;
	
	public class TreeItem extends View
	{
		protected var _level:int;
		protected var _selected:Boolean;
		protected var _parentItem:TreeItem;
		protected var _childItems:Vector.<TreeItem>;
		protected var _opened:Boolean;
		protected var _padding:int;
		protected var _clickHandler:Method;
		
		protected var mContainerChildren:Box;
		protected var mMouseChildren:Boolean;
		
		public function TreeItem()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onInitialized();
			mContainerChildren = new Box();
			
			addEventListener(MouseEvent.CLICK, onMouseClick);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			mContainerChildren.addEventListener(MouseEvent.ROLL_OVER, onChildrenMouseOver);
			mContainerChildren.addEventListener(MouseEvent.ROLL_OUT, onChildrenMouseOut);
			changeState(false, 0);
			
			graphics.clear();
			graphics.beginFill(0xffff00, 0);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
		
		override public function dispose():void {
			removeEventListener(MouseEvent.CLICK, onMouseClick);
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			mContainerChildren.removeEventListener(MouseEvent.ROLL_OVER, onChildrenMouseOver);
			mContainerChildren.removeEventListener(MouseEvent.ROLL_OUT, onChildrenMouseOut);
			_clickHandler = null;
			super.dispose();
		}
		
		private function onMouseClick(event:MouseEvent):void {
			if (hasChildren) {
				if (!_opened) {
					open();
				} else {
					close();
				}
			}
			if (_clickHandler != null) {
				_clickHandler.applyWith([this]);
			}
			event.stopPropagation();
		}
		
		private function onMouseOver(event:MouseEvent):void {
			if (mMouseChildren) {
				return;
			}
			if (!_selected) {
				changeState(true, 0);
			}
		}
		
		private function onMouseOut(event:MouseEvent):void {
			if (!_selected) {
				changeState(false, 0);
			}
		}
		
		private function onChildrenMouseOver(event:MouseEvent):void {
			mMouseChildren = true;
			if (!_selected) {
				changeState(false, 0);
			}
		}
		
		private function onChildrenMouseOut(event:MouseEvent):void {
			mMouseChildren = false;
		}
		
		protected function changeState(visable:Boolean, frame:int):void {
			var selectBox:Clip = getChildByName("selectBox") as Clip;
			if (selectBox) {
				selectBox.visible = visable;
				selectBox.frame = frame;
			}
		}
		
		public function open():void {
			if (hasChildren) {
				if (!_opened) {
					_opened = true;
					mContainerChildren.y = height;
					addChild(mContainerChildren);
				}
			}
		}
		
		public function close():void {
			if (hasChildren) {
				if (_opened) {
					_opened = false;
					removeChild(mContainerChildren);
				}
			}
		}
		
		public function updateLayout():void {
			if (hasChildren) {
				var yy:int;
				for each (var item:TreeItem in _childItems) {
					item.y = yy;
					yy += item.height;
				}
			}
		}
		
		public function set selected(value:Boolean):void {
			_selected = value;
			changeState(_selected, 1);
		}
		
		public function get selected():Boolean {
			return _selected;
		}
		
		public function get opened():Boolean {
			return hasChildren && _opened;
		}
		
		public function get hasChildren():Boolean {
			return _childItems != null && _childItems.length > 0;
		}
		
		public function get level():int {
			return _level;
		}
		
		public function set level(value:int):void {
			_level = value;
			callLater(updatePadding);
		}
		
		public function get padding():int {
			return _padding;
		}
		
		public function set padding(value:int):void {
			_padding = value;
			callLater(updatePadding);
		}
		
		protected function updatePadding():void {
			if (_level != 0) {
				x = _padding;
			}
		}
		
		public function get parentItem():TreeItem {
			return _parentItem;
		}
		
		public function set parentItem(value:TreeItem):void {
			_parentItem = value;
		}
		
		public function get childItems():Vector.<TreeItem> {
			return _childItems;
		}
		
		public function set childItems(value:Vector.<TreeItem>):void {
			_childItems = value;
			for each (var item:TreeItem in _childItems) {
				mContainerChildren.addChild(item);
			}
		}
		
		public function set clickHandler(value:Method):void {
			_clickHandler = value;
		}
		
		public function get clickHandler():Method {
			return _clickHandler;
		}
	}
}