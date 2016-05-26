package com.canaan.lib.component.controls
{
	import com.canaan.lib.component.IToolTip;
	
	import flash.text.TextFieldAutoSize;
	import com.canaan.lib.component.UIComponent;
	
	public class ToolTip extends UIComponent implements IToolTip
	{
		protected var _toolTipData:Object;
		
		protected var label:Label;
		
		public function ToolTip()
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			label = new Label();
			addChild(label);
//			drawBackground();
		}
		
		override protected function initialize():void {
			super.initialize();
			label.autoSize = TextFieldAutoSize.LEFT;
			label.mouseEnabled = false;
			label.multiline = true;
			label.wordWrap = true;
		}
		
		private function drawBackground():void {        
			graphics.clear();
			graphics.beginFill(0x000000, 0.7);
			graphics.drawRoundRect(0, 0, width, height, 5, 5);
			graphics.endFill();
		}
		
		public function get toolTipData():Object {
			return _toolTipData;
		}
		
		public function set toolTipData(value:Object):void {
			_toolTipData = value;
			label.text = value as String;
		}
		
		public function onToolTipShow():void {
			
		}
		
		public function onToolTipHide():void {
			
		}
	}
}