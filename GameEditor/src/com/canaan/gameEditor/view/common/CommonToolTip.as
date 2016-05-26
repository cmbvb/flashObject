package com.canaan.gameEditor.view.common
{
	import com.canaan.lib.component.IToolTip;
	import com.canaan.lib.component.UIComponent;
	import com.canaan.lib.component.controls.Image;
	import com.canaan.lib.component.controls.Label;
	import com.canaan.lib.managers.RenderManager;
	
	import flash.text.TextFieldAutoSize;
	
	public class CommonToolTip extends UIComponent implements IToolTip
	{
		private static const MAX_WIDTH:int = 200;
		private static const OFFSET:int = 5;
		
		private var _toolTipData:Object;
		private var background:Image;
		private var label:Label;
		
		public function CommonToolTip()
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			background = new Image("png.comp.borderBlank");
			background.sizeGrid = "2,2,2,2";
			addChild(background);
			label = new Label();
			label.autoSize = TextFieldAutoSize.NONE;
			label.isHtml = true;
			label.multiline = true;
			label.wordWrap = true;
			label.x = label.y = OFFSET;
			label.width = MAX_WIDTH;
			addChild(label);
		}
		
		public function get toolTipData():Object {
			return _toolTipData;
		}
		
		public function set toolTipData(value:Object):void {
			_toolTipData = value;
			label.text = value.toString();
			RenderManager.getInstance().renderAll();
			background.width = label.textField.textWidth + OFFSET * 3;
			background.height = label.textField.textHeight + OFFSET * 3;
		}
		
		override public function get width():Number {
			return background.width;
		}
		
		override public function get height():Number {
			return background.height;
		}
	}
}