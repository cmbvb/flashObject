package module
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import module.mainUI.MainControlBottomLeft;
	import module.mainUI.MainControlBottomRight;
	
	public class ModuleMainUI extends Sprite
	{
		private var mBottomLeft:MainControlBottomLeft;
		private var mBottomRight:MainControlBottomRight;
		
		public function ModuleMainUI()
		{
			super();
			init();
		}
		
		private function init():void {
			mBottomLeft = new MainControlBottomLeft();
			mBottomRight = new MainControlBottomRight();
			addChild(mBottomLeft);
			addChild(mBottomRight);
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		
		private function onResize():void {
			mBottomLeft.moveTo(0, stage.stageHeight - mBottomLeft.height);
			mBottomRight.moveTo(stage.stageWidth - mBottomRight.width, stage.stageHeight - mBottomRight.height);
		}
		
	}
}