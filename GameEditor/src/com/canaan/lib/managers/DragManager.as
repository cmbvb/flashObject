package com.canaan.lib.managers
{
	import com.canaan.lib.events.DragEvent;
	import com.canaan.lib.utils.DisplayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class DragManager extends Sprite
	{
		private static var canInstantiate:Boolean;
        private static var instance:DragManager;
        
        private var dragInitiator:DisplayObject;
        private var data:Object;
        private var dragImage:DisplayObject;
		private var startX:Number;
		private var startY:Number;
		
		public function DragManager()
		{
			if (!canInstantiate) {
				throw new Error("Can not instantiate, use getInstance() instead.");
			}
		}
		
		public static function getInstance():DragManager {
            if (instance == null) {
            	canInstantiate = true;
                instance = new DragManager();
                canInstantiate = false;
            }
            return instance;
        }
        
        public function doDrag(dragInitiator:DisplayObject, dragImage:DisplayObject = null, data:Object = null):void {
			if (dragImage == null) {
				dragImage = dragInitiator;
			}
        	this.dragInitiator = dragInitiator;
        	this.data = data;
        	this.dragImage = dragImage;
			if (dragInitiator != dragImage) {
	        	var globalPoint:Point = dragInitiator.parent.localToGlobal(new Point(dragInitiator.x, dragInitiator.y));
	        	dragImage.x = globalPoint.x;
	        	dragImage.y = globalPoint.y;
				addChild(dragImage);
			}
			startX = mouseX;
			startY = mouseY;
			StageManager.getInstance().registerHandler(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        	StageManager.getInstance().registerHandler(MouseEvent.MOUSE_UP, mouseUpHandler);
        	dragInitiator.dispatchEvent(new DragEvent(DragEvent.DRAG_START, dragInitiator, data));
        }

		private function mouseMoveHandler():void {
			var stage:Stage = StageManager.getInstance().stage;
			if (mouseX < 0 || mouseX > stage.stageWidth || mouseY < 0 || mouseY > stage.stageHeight) {
				return;
			}
			dragImage.x += mouseX - startX;
			dragImage.y += mouseY - startY;
			startX = mouseX;
			startY = mouseY;
		}
		
        private function mouseUpHandler():void {
        	var dropTarget:DisplayObject = getDropTarget();
        	if (dropTarget != null) {
        		dropTarget.dispatchEvent(new DragEvent(DragEvent.DRAG_DROP, dragInitiator, data));
        	}
        	dragInitiator.dispatchEvent(new DragEvent(DragEvent.DRAG_COMPLETE, dragInitiator, data));
			if (dragInitiator != dragImage) {
        		DisplayUtil.removeChild(dragImage.parent, dragImage);
			}
			StageManager.getInstance().deleteHandler(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			StageManager.getInstance().deleteHandler(MouseEvent.MOUSE_UP, mouseUpHandler);
        	dragInitiator = null;
        	data = null;
        	dragImage = null;
        }
        
        private function getDropTarget():DisplayObject {
			var stage:Stage = StageManager.getInstance().stage;
			var list:Array = stage.getObjectsUnderPoint(new Point(stage.mouseX, stage.mouseY));
			var length:int = list.length;
			var value:DisplayObject;
			for (var i:int = length - 1; i >= 0; i--) {
				value = list[i];
				while (value) {
					if (value.hasEventListener(DragEvent.DRAG_DROP)) {
						return value;
					}
					value = value.parent;
				}
			}
			return null;
        }
	}
}