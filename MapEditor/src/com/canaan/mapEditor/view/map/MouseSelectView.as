package com.canaan.mapEditor.view.map
{
	import com.canaan.lib.display.BaseSprite;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.managers.StageManager;
	import com.canaan.mapEditor.events.GlobalEvent;
	
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class MouseSelectView extends BaseSprite
	{
		private var mTarget:InteractiveObject;
		private var mStartPoint:Point;
		
		public function MouseSelectView(target:InteractiveObject)
		{
			super();
			mTarget = target;
		}
		
		public function show():void {
			mStartPoint = new Point(mTarget.mouseX, mTarget.mouseY);
			mTarget.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			StageManager.getInstance().stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseMove(event:MouseEvent):void {
			graphics.clear();
			graphics.lineStyle(2, 0x6388ff);
			graphics.drawRect(mStartPoint.x, mStartPoint.y, mTarget.mouseX - mStartPoint.x, mTarget.mouseY - mStartPoint.y);
			graphics.endFill();
		}
		
		private function onMouseUp(event:MouseEvent):void {
			graphics.clear();
			mTarget.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			StageManager.getInstance().stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			var rect:Rectangle = new Rectangle();
			rect.left = Math.min(mStartPoint.x, mTarget.mouseX);
			rect.top = Math.min(mStartPoint.y, mTarget.mouseY);
			rect.right = Math.max(mStartPoint.x, mTarget.mouseX);
			rect.bottom = Math.max(mStartPoint.y, mTarget.mouseY);
			EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.ON_MOUSE_SELECT, rect));
		}
	}
}