/**
 * Morn UI Version 2.5.1215 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package com.canaan.lib.component.controls {
	import com.canaan.lib.component.Styles;
	import com.canaan.lib.component.UIComponent;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.StageManager;
	import com.canaan.lib.utils.TextUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	/**选择项改变后触发*/
	[Event(name="select",type="flash.events.Event")]
	
	/**下拉框*/
	public class ComboBox extends UIComponent {
		/**向上方向*/
		public static const UP:String = "up";
		/**向下方向*/
		public static const DOWN:String = "down";
		protected var _visibleNum:int = 6;
		protected var _button:Button;
		protected var _list:List;
		protected var _isOpen:Boolean;
		protected var _scrollBar:VScrollBar;
		protected var _itemColor:uint = Styles.comboBoxItemColor;
		protected var _itemSize:int = Styles.fontSize;
		protected var _array:Array = [];
		protected var _labelField:String = "label";
		protected var _selectedIndex:int = -1;
		protected var _selectHandler:Method;
		protected var _openDirection:String = DOWN;
		protected var _itemHeight:Number;
		protected var _listHeight:Number;
		protected var _listBg:Image;
		protected var _listBgSizeGrid:String;
		protected var _listBgOffset:int;
		
		public function ComboBox(skin:String = null, labels:String = null) {
			this.skin = skin;
			this.labels = labels;
		}
		
		override protected function preinitialize():void {
			super.preinitialize();
			mouseChildren = true;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			addChild(_button = new Button());
			_list = new List();
			_list.selectShow = false;
			_list.renderHandler = new Method(onListRender);
			_list.mouseHandler = new Method(onlistItemMouse);
			_listBg = new Image();
			_list.addChildAt(_listBg, 0);
			_scrollBar = new VScrollBar();
			_list.addChild(_scrollBar);
		}
		
		override protected function initialize():void {
			super.initialize();
			_button.btnLabel.align = "left";
			_button.labelMargin = "5";
			_button.labelColors = [itemColor, itemColor, itemColor, itemColor].join(",");
			_button.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
			
			_list.addEventListener(Event.SELECT, onListSelect);
			_scrollBar.name = "scrollBar";
			_scrollBar.y = 1;
		}
		
		private function onButtonMouseDown(e:MouseEvent):void {
			callLater(changeOpen);
		}
		
		protected function onListSelect(e:Event):void {
			selectedIndex = _list.selectedIndex;
		}
		
		/**皮肤*/
		public function get skin():String {
			return _button.skin;
		}
		
		public function set skin(value:String):void {
			if (_button.skin != value) {
				_button.skin = value;
				_contentWidth = _button.width;
				_contentHeight = _button.height;
				callLater(changeList);
			}
		}
		
		public function get selectBoxSkin():String {
			return _button.skin + "$selectBox";
		}
		
		public function get listBgSkin():String {
			return _button.skin + "$listBg";
		}
		
		protected function changeList():void {
			var labelWidth:Number = width - 2;
			_itemHeight = TextUtil.getTextField(new TextFormat(Styles.fontName, _itemSize)).height + 3;
			list.itemRender = <Box>
								<Image url={selectBoxSkin} width={labelWidth} height={_itemHeight} name="selectBox"/>
								<Label name={_labelField} width={labelWidth} size={_itemSize} height={_itemHeight} color={_itemColor} x="5"/>
							</Box>;
			list.repeatY = _visibleNum;
			_listBg.url = listBgSkin;
			_listBg.y = _listBgOffset;
			_scrollBar.x = width - _scrollBar.width - 1;
			_list.refresh();
		}
		
		protected function onListRender(cell:Box, index:int):void {
			var label:Label = cell.getChildByName(_labelField) as Label;
			if (cell.dataSource != null) {
				if (cell.dataSource is String) {
					label.text = cell.dataSource.toString();
				} else {
					label.text = cell.dataSource[_labelField];
				}
			}
		}
		
		protected function onlistItemMouse(e:MouseEvent, index:int):void {
			var type:String = e.type;
			if (type == MouseEvent.CLICK) {
				isOpen = false;
			}
		}
		
		protected function changeOpen():void {
			isOpen = !_isOpen;
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			_button.width = _width;
			callLater(changeList);
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			_button.height = _height;
		}
		
		/**数据源*/
		public function get array():Array {
			return _array;
		}
		
		public function set array(value:Array):void {
			if (_array.length > 0) {
				selectedIndex = -1;
			}
			_array = value || [];
			callLater(changeItem);
		}
		
		/**文本显示字段*/
		public function get labelField():String {
			return _labelField;
		}
		
		public function set labelField(value:String):void {
			_labelField = value;
			callLater(changeList);
		}
		
		public function set labels(value:String):void {
			if (value) {
				array = value.split(",");
			} else {
				array = null;
			}
		}
		
		protected function changeItem():void {
			//赋值之前需要先初始化列表
			exeCallLater(changeList);
			
			//显示边框
			_listHeight = _array.length > 0 ? Math.min(_visibleNum, _array.length) * _itemHeight : _itemHeight;
			_scrollBar.height = _listHeight - 2;
			//填充背景
			_listBg.width = width;
			_listBg.height = _listHeight - _listBgOffset + 1;
			//填充数据			
			var a:Array = [];
			var obj:Object;
			for (var i:int = 0, n:int = _array.length; i < n; i++) {
				if (_array[i] is String) {
					obj = {};
					obj[_labelField] = _array[i];
				} else {
					obj = _array[i];
				}
				a.push(obj);
			}
			_list.array = a;
		}
		
		/**选择索引*/
		public function get selectedIndex():int {
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void {
			if (_selectedIndex != value) {
				_list.selectedIndex = _selectedIndex = value;
				_button.label = selectedLabel;
				if (_selectHandler != null) {
					_selectHandler.applyWith([_selectedIndex]);
				}
				sendEvent(Event.SELECT);
			}
		}
		
		/**选中单元格数据源*/
		public function get selectedItem():Object {
			return _selectedIndex != -1 ? _array[_selectedIndex] : null;
		}
		
		public function set selectedItem(value:Object):void {
			selectedIndex = _array.indexOf(value);
		}
		
		/**选择被改变时执行的处理器(默认返回参数index:int)*/
		public function get selectHandler():Method {
			return _selectHandler;
		}
		
		public function set selectHandler(value:Method):void {
			_selectHandler = value;
		}
		
		/**选择标签*/
		public function get selectedLabel():String {
			if (_selectedIndex > -1 && _selectedIndex < _array.length) {
				var obj:Object = _array[_selectedIndex];
				if (obj is String) {
					return obj as String;
				} else {
					return obj[_labelField];
				}
			}
			return "";
		}
		
		public function set selectedLabel(value:String):void {
			selectedIndex = _array.indexOf(value);
		}
		
		/**可见项数量*/
		public function get visibleNum():int {
			return _visibleNum;
		}
		
		public function set visibleNum(value:int):void {
			_visibleNum = value;
			callLater(changeList);
		}
		
//		/**项颜色(格式:overBgColor,overLabelColor,outLableColor,borderColor,bgColor)*/
//		public function get itemColors():String {
//			return String(_itemColors);
//		}
//		
//		public function set itemColors(value:String):void {
//			_itemColors = ArrayUtil.copyAndFill(_itemColors, value);
//			callLater(changeList);
//		}
		
		/**项颜色*/
		public function get itemColor():uint {
			return _itemColor;
		}
		
		public function set itemColor(value:uint):void {
			_itemColor = value;
			callLater(changeList);
		}
		
		/**项字体大小*/
		public function get itemSize():int {
			return _itemSize;
		}
		
		public function set itemSize(value:int):void {
			_itemSize = value;
			callLater(changeList);
		}
		
		/**是否打开*/
		public function get isOpen():Boolean {
			return _isOpen;
		}
		
		public function set isOpen(value:Boolean):void {
			if (_isOpen != value) {
				_isOpen = value;
				_button.selected = _isOpen;
				if (_isOpen) {
					var p:Point = localToGlobal(new Point());
					_list.moveTo(p.x, p.y + (_openDirection == DOWN ? height : -_listHeight));
					StageManager.getInstance().stage.addChild(_list);
					StageManager.getInstance().stage.addEventListener(MouseEvent.MOUSE_DOWN, removeList);
					StageManager.getInstance().stage.addEventListener(Event.REMOVED_FROM_STAGE, removeList);
					//处理定位
					_list.scrollTo((_selectedIndex + _visibleNum) < _list.length ? _selectedIndex : _list.length - _visibleNum);
				} else {
					_list.remove();
					StageManager.getInstance().stage.removeEventListener(MouseEvent.MOUSE_DOWN, removeList);
					StageManager.getInstance().stage.removeEventListener(Event.REMOVED_FROM_STAGE, removeList);
				}
			}
		}
		
		protected function removeList(e:Event):void {
			if (e == null || e.target == _list.content || (!_button.contains(e.target as DisplayObject) && !_list.contains(e.target as DisplayObject))) {
				isOpen = false;
			}
		}
		
		/**滚动条皮肤*/
		public function get scrollBarSkin():String {
			return _scrollBar.skin;
		}
		
		public function set scrollBarSkin(value:String):void {
			_scrollBar.skin = value;
		}
		
		/**九宫格信息(格式:左边距,上边距,右边距,下边距)*/
		public function get sizeGrid():String {
			return _button.sizeGrid;
		}
		
		public function set sizeGrid(value:String):void {
			_button.sizeGrid = value;
		}
		
		/**滚动条*/
		public function get scrollBar():VScrollBar {
			return _scrollBar;
		}
		
		/**按钮实体*/
		public function get button():Button {
			return _button;
		}
		
		/**list实体*/
		public function get list():List {
			return _list;
		}
		
		override public function set dataSource(value:Object):void {
			_dataSource = value;
			if (value is int || value is String) {
				selectedIndex = int(value);
			} else if (value is Array) {
				array = value as Array;
			} else {
				super.dataSource = value;
			}
		}
		
		/**打开方向*/
		public function get openDirection():String {
			return _openDirection;
		}
		
		public function set openDirection(value:String):void {
			_openDirection = value;
		}
		
		/**标签颜色(格式:upColor,overColor,downColor,disableColor)*/
		public function get labelColors():String {
			return _button.labelColors;
		}
		
		public function set labelColors(value:String):void {
			_button.labelColors = value;
		}
		
		/**按钮标签边距(格式:左边距,上边距,右边距,下边距)*/
		public function get labelMargin():String {
			return _button.labelMargin;
		}
		
		public function set labelMargin(value:String):void {
			_button.labelMargin = value;
		}
		
		/**按钮标签描边(格式:color,alpha,blurX,blurY,strength,quality)*/
		public function get labelStroke():String {
			return _button.labelStroke;
		}
		
		public function set labelStroke(value:String):void {
			_button.labelStroke = value;
		}
		
		/**按钮标签大小*/
		public function get labelSize():Object {
			return _button.labelSize;
		}
		
		public function set labelSize(value:Object):void {
			_button.labelSize = value;
		}
		
		/**按钮标签粗细*/
		public function get labelBold():Object {
			return _button.labelBold;
		}
		
		public function set labelBold(value:Object):void {
			_button.labelBold = value;
		}

		public function get listBgSizeGrid():String {
			return _listBg.sizeGrid;
		}

		public function set listBgSizeGrid(value:String):void {
			_listBg.sizeGrid = value;
		}

		public function get listBgOffset():int {
			return _listBgOffset;
		}

		public function set listBgOffset(value:int):void {
			_listBgOffset = value;
			callLater(changeList);
		}

	}
}