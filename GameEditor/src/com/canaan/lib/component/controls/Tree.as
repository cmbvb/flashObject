package com.canaan.lib.component.controls
{
	import com.canaan.lib.component.IItem;
	import com.canaan.lib.component.Styles;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.RenderManager;
	import com.canaan.lib.utils.ArrayUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 树形控件
	 * @author Administrator
	 * 
	 */	
	public class Tree extends Box implements IItem
	{
		protected var _content:Box;
		protected var _scrollBar:ScrollBar;
		protected var _itemRender:*;
		protected var _mask:Bitmap;
		protected var _rootItems:Vector.<TreeItem> = new Vector.<TreeItem>();
		protected var _allItems:Vector.<TreeItem> = new Vector.<TreeItem>();
		protected var _array:Array = [];
		protected var _selectedItem:Object;
		protected var _selectHandler:Method;
		protected var _maxLevel:int;
		protected var _padding:int = Styles.treeItemPaddingLeft;
		protected var _canSelectFolder:Boolean;
		protected var _cellSize:Number = 20;
		
		public function Tree()
		{
			super();
		}
		
		override protected function createChildren():void {
			super.createChildren();
			_content = new Container();
			addChild(_content);
			_mask = new Bitmap(new BitmapData(1, 1, false, 0x000000));
			addChild(_mask);
		}
		
		override protected function initialize():void {
			super.initialize();
			_content.mask = _mask;
		}
		
		override protected function changeSize():void {
			_mask.width = _width;
			_mask.height = _height;
			if (_scrollBar) {
				if (_scrollBar.direction == ScrollBar.VERTICAL) {
					_scrollBar.visible = _height < _content.height;
				} else {
					_scrollBar.visible = _width < _content.width;
				}
				if (_scrollBar.visible) {
					_scrollBar.thumbPercent = height / _content.height;
					_scrollBar.value = _scrollBar.value;
				} else {
					_scrollBar.value = 0;
				}
				onScrollBarChange();
				_scrollBar.scrollSize = _cellSize;
				setContentSize(width, height);
				_scrollBar.setScroll(0, (_content.height - height) * _cellSize, _scrollBar.value);
			}
			super.changeSize();
		}
		
		override public function dispose():void {
			if (_scrollBar) {
				_scrollBar.removeEventListener(Event.CHANGE, onScrollBarChange);
			}
			super.dispose();
		}
		
		public function initItems():void {
			_scrollBar = getChildByName("scrollBar") as ScrollBar;
			if (_scrollBar) {
				_scrollBar.target = this;
				_scrollBar.scrollSize = _cellSize;
				_scrollBar.addEventListener(Event.CHANGE, onScrollBarChange);
			}
		}
		
		protected function onScrollBarChange(event:Event = null):void {
			var percent:Number = _scrollBar.value / _scrollBar.max;
			var scrollSize:Number;
			if (_scrollBar.direction == ScrollBar.VERTICAL) {
				scrollSize = Math.max(0, _content.height - height);
				_content.y = -scrollSize * percent;
			} else {
				scrollSize = Math.max(0, _content.width - width);
				_content.x = -scrollSize * percent;
			}
		}
		
		protected function onMouseWheel(event:MouseEvent):void {
			_scrollBar.value -= event.delta;
		}
		
		public function get selectHandler():Method {
			return _selectHandler;
		}
		
		public function set selectHandler(value:Method):void {
			_selectHandler = value;
		}
		
		public function get selectedItem():Object {
			return _selectedItem;
		}
		
		public function set selectedItem(value:Object):void {
			if (_selectedItem != value) {
				if (selection != null) {
					selection.selected = false;
				}
				_selectedItem = value;
				if (selection != null) {
					selection.selected = true;
				}
				if (_selectHandler != null) {
					_selectHandler.applyWith([_selectedItem]);
				}
				sendEvent(Event.CHANGE);
			}
		}
		
		public function get selection():TreeItem {
			for each (var item:TreeItem in _allItems) {
				if (item.dataSource == _selectedItem) {
					return item;
				}
			}
			return null;
		}
		
		public function set selection(value:TreeItem):void {
			selectedItem = value.dataSource;
		}
		
		public function get array():Array {
			return _array;
		}
		
		public function set array(value:Array):void {
			_array = value || [];
			selectedItem = null;
			callLater(refresh);
		}
		
		public function refresh():void {
			clearItems();
			createItems();
			updateLayout();
		}
		
		protected function clearItems():void {
			_content.removeAllChildren(true);
			_rootItems.length = 0;
			_allItems.length = 0;
		}
		
		protected function createItems():void {
			var item:TreeItem;
			for each (var itemData:Object in _array) {
				item = generateItem(itemData);
				_rootItems.push(item);
				_content.addChild(item);
			}
			_cellSize = item.height;
		}
		
		protected function generateItem(itemData:Object, level:int = 0, parentItem:TreeItem = null):TreeItem {
			var item:TreeItem = (_itemRender is XML ? View.createComp(_itemRender) : new _itemRender()) as TreeItem;
			item.level = level;
			item.padding = _padding;
			item.clickHandler = new Method(itemClickHandler);
			if (parentItem != null) {
				item.parentItem = parentItem;
			}
			if (itemData.hasOwnProperty("children")) {
				level++;
				_maxLevel = level;
				var childItems:Vector.<TreeItem> = new Vector.<TreeItem>();
				for each (var childItemData:Object in itemData.children) {
					childItems.push(generateItem(childItemData, level, item));
				}
				item.childItems = childItems;
			}
			item.dataSource = itemData;
			_allItems.push(item);
			return item;
		}
		
		/**设置可视区域大小*/
		public function setContentSize(width:Number, height:Number):void {
			var g:Graphics = _content.graphics;
			g.clear();
			g.beginFill(0xffff00, 0);
			g.drawRect(0, 0, width, height);
			g.endFill();
		}
		
		protected function itemClickHandler(item:TreeItem):void {
			if (!item.hasChildren || _canSelectFolder) {
				selectedItem = item.dataSource;
			}
			updateLayout();
		}
		
		/**单元格渲染器，可以设置为XML或类对象*/
		public function get itemRender():* {
			return _itemRender;
		}
		
		public function set itemRender(value:*):void {
			_itemRender = value;
			callLater(refresh);
		}
		
		public function get padding():int {
			return _padding;
		}
		
		public function set padding(value:int):void {
			_padding = value;
			for each (var item:TreeItem in _allItems) {
				item.padding = _padding;
			}
		}
		
		public function get maxLevel():int {
			return _maxLevel;
		}
		
		/**
		 * 打开全部
		 * 
		 */		
		public function expandAll():void {
			RenderManager.getInstance().renderAll();
			for each (var item:TreeItem in _allItems) {
				item.open();
			}
			updateLayout();
		}
		
		/**
		 * 关闭全部
		 * 
		 */		
		public function closeAll():void {
			callLater(delayCloseAll);
		}
		
		protected function delayCloseAll():void {
			for each (var item:TreeItem in _allItems) {
				item.close();
			}
			callLater(updateLayout);
		}
		
		/**
		 * 打开或关闭分支项目
		 * @param item
		 * @param open
		 * 
		 */		
		public function expandItem(itemData:Object, open:Boolean):void {
			var item:TreeItem = ArrayUtil.find(_allItems, "data", itemData);
			if (item != null) {
				do {
					if (open) {
						item.open();
					} else {
						item.close();
					}
					item = item.parentItem;
				} while (item != null);
			}
			callLater(updateLayout);
		}
		
		/**
		 * 项目是否打开
		 * @param itemData
		 * @return 
		 * 
		 */		
		public function isItemOpen(itemData:Object):Boolean {
			var item:TreeItem = ArrayUtil.find(_allItems, "data", itemData);
			if (item != null) {
				return item.opened;
			}
			return false;
		}
		
		/**
		 * 所有打开的项目
		 * @return 
		 * 
		 */		
		public function get opendItems():Array {
			var result:Array = [];
			for each (var item:TreeItem in _allItems) {
				if (item.opened) {
					result.push(item.dataSource);
				}
			}
			return result;
		}
		
		public function set opendItems(value:Array):void {
			for each (var item:TreeItem in _allItems) {
				if (value.indexOf(item.dataSource) != -1) {
					item.open();
				} else {
					item.close();
				}
			}
		}
		
		/**
		 * 所有可视的项目
		 * @return 
		 * 
		 */		
		public function get visualItems():Array {
			var result:Array = [];
			for each (var item:TreeItem in _allItems) {
				if (item.level == 0 || item.parentItem.opened) {
					result.push(item);
				}
			}
			return result;
		}
		
		protected function updateLayout():void {
			var yy:int;
			for each (var rootItem:TreeItem in _rootItems) {
				updateItemLayout(rootItem);
				rootItem.y = yy;
				yy += rootItem.height;
			}
			changeSize();
		}
		
		protected function updateItemLayout(item:TreeItem):void {
			if (item.hasChildren) {
				for each (var childItem:TreeItem in item.childItems) {
					updateItemLayout(childItem);
				}
				item.updateLayout();
			}
		}
		
		public function get canSelectFolder():Boolean
		{
			return _canSelectFolder;
		}
		
		public function set canSelectFolder(value:Boolean):void
		{
			_canSelectFolder = value;
		}
	}
}