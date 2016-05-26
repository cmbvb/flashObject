package com.canaan.gameEditor.view.action
{
	import com.canaan.gameEditor.contants.TypeDragType;
	import com.canaan.gameEditor.ui.action.ActionEditImageItemUI;
	import com.canaan.lib.component.controls.Image;
	import com.canaan.lib.managers.DragManager;
	
	import flash.events.MouseEvent;
	
	public class ActionEditImageItem extends ActionEditImageItemUI
	{
		private var mUrl:String;
		private var mDirection:int;
		private var mFrameIndex:int;
		
		public function ActionEditImageItem()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(event:MouseEvent):void {
			DragManager.getInstance().doDrag(imgIcon, new Image(mUrl), {type:TypeDragType.DRAG_IMAGE_ITEM, frameIndex:mFrameIndex});
		}
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mUrl = value.url;
			mFrameIndex = value.frameIndex;
			
			lblIndex.text = mFrameIndex.toString();
			imgIcon.url = mUrl;
		}
		
		private static function getIndexString(frameIndex:int):String {
			var indexString:String = frameIndex.toString();
			while (indexString.length < 4) {
				indexString = "0" + indexString;
			}
			return indexString;
		}
		
		override public function dispose():void {
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			super.dispose();
		}
	}
}