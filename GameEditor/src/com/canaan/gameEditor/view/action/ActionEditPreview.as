package com.canaan.gameEditor.view.action
{
	import com.canaan.lib.component.controls.Image;
	
	public class ActionEditPreview extends Image
	{
		private var _offsetX:int;
		private var _offsetY:int;
		
		public function ActionEditPreview(offsetX:int, offsetY:int)
		{
			super();
			_offsetX = offsetX;
			_offsetY = offsetY;
		}
		
		public function showImage(url:String, anchorX:int = 0, anchorY:int = 0):void {
			this.url = url;
			this.x = _offsetX + anchorX;
			this.y = _offsetY + anchorY;
		}
	}
}