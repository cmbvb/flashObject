/**
 * Morn UI Version 2.3.0810 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package com.canaan.lib.component.controls {
	import com.canaan.lib.component.Styles;
	import com.canaan.lib.component.UIComponent;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.utils.ArrayUtil;
	import com.canaan.lib.utils.TextUtil;
	
	import flash.events.Event;
	
	/**值改变后触发*/
	[Event(name="change",type="flash.events.Event")]
	
	/**进度条*/
	public class ProgressBar extends UIComponent {
		protected var _bg:Image;
		protected var _bar:Image;
		protected var _skin:String;
		protected var _value:Number = 0.5;
		protected var _label:String;
		protected var _barLabel:Label;
		protected var _changeHandler:Method;
		protected var _labelMargin:Array = Styles.buttonLabelMargin;
		
		public function ProgressBar(skin:String = null) {
			this.skin = skin;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			addChild(_bg = new Image());
			addChild(_bar = new Image());
			addChild(_barLabel = new Label());
		}
		
		override protected function initialize():void {
			super.initialize();
			_barLabel.width = 200;
			_barLabel.height = 18;
			_barLabel.align = "center";
		}
		
		/**皮肤*/
		public function get skin():String {
			return _skin;
		}
		
		public function set skin(value:String):void {
			if (_skin != value) {
				_skin = value;
				_bg.url = _skin;
				_bar.url = _skin + "$bar";
				_contentWidth = _bg.width;
				_contentHeight = _bg.height;
				callLater(changeLabelSize);
				callLater(changeValue);
			}
		}
		
		protected function changeLabelSize():void {
			_barLabel.width = width - _labelMargin[0] - _labelMargin[2];
			_barLabel.height = TextUtil.getTextField(_barLabel.format).height;
			_barLabel.x = _labelMargin[0];
			_barLabel.y = (height - _barLabel.height) * 0.5 + _labelMargin[1] - _labelMargin[3];
		}
		
		/**当前值(0-1)*/
		public function get value():Number {
			return _value;
		}
		
		public function set value(num:Number):void {
			if (_value != num) {
				num = num > 1 ? 1 : num < 0 ? 0 : num;
				_value = num;
				sendEvent(Event.CHANGE);
				if (_changeHandler != null) {
					_changeHandler.applyWith([num]);
				}
				callLater(changeValue);
			}
		}
		
		protected function changeValue():void {
			if (sizeGrid) {
				var grid:Array = sizeGrid.split(",");
				var left:Number = grid[0];
				var right:Number = grid[2];
				var max:Number = width - left - right;
				var sw:Number = max * _value;
				_bar.width = int(left + right + sw);
				_bar.visible = _bar.width > left + right;
			} else {
				_bar.width = width * _value;
			}
		}
		
		/**标签*/
		public function get label():String {
			return _label;
		}
		
		public function set label(value:String):void {
			if (_label != value) {
				_label = value;
				_barLabel.text = _label;
			}
		}
		
		/**进度条*/
		public function get bar():Image {
			return _bar;
		}
		
		/**标签实体*/
		public function get barLabel():Label {
			return _barLabel;
		}
		
		/**九宫格信息(格式:左边距,上边距,右边距,下边距)*/
		public function get sizeGrid():String {
			return _bg.sizeGrid;
		}
		
		public function set sizeGrid(value:String):void {
			_bg.sizeGrid = _bar.sizeGrid = value;
		}
		
		public function get labelColor():Object {
			return _barLabel.color;
		}
		
		public function set labelColor(value:Object):void {
			_barLabel.color = value;
		}
		
		public function get labelSize():Object {
			return _barLabel.size;
		}
		
		public function set labelSize(value:Object):void {
			_barLabel.size = value;
		}
		
		public function get labelStroke():String {
			return _barLabel.stroke;
		}
		
		public function set labelStroke(value:String):void {
			_barLabel.stroke = value;
		}
		
		/**按钮标签边距(格式:左边距,上边距,右边距,下边距)*/
		public function get labelMargin():String {
			return String(_labelMargin);
		}
		
		public function set labelMargin(value:String):void {
			_labelMargin = ArrayUtil.copyAndFill(_labelMargin, value);
			callLater(changeLabelSize);
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			_bg.width = _width;
			_barLabel.width = _width;
			callLater(changeLabelSize);
			callLater(changeValue);
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			_bg.height = _height;
			_bar.height = _height;
			callLater(changeLabelSize);
		}
		
		override public function commitMeasure():void {
			super.commitMeasure();
			exeCallLater(changeLabelSize);
			exeCallLater(changeValue);
		}
		
		override public function set dataSource(value:Object):void {
			_dataSource = value;
			if (value is Number || value is String) {
				this.value = Number(value);
			} else {
				super.dataSource = value;
			}
		}
	}
}