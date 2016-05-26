package modules.map
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import modules.GameModules;
	
	import utils.DirectionUtil;

	public class MapControl
	{
		private const centerPoint:Point = new Point(App.stage.fullScreenWidth / 2, App.stage.fullScreenHeight / 2);
		
		public function MapControl()
		{
		}
		
		public function init():void {
			App.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(event:MouseEvent):void {
			var type:int = DirectionUtil.getDirection8(centerPoint.x, centerPoint.y, App.stage.mouseX, App.stage.mouseY);
			GameModules.modelMap.moveMap(type);
		}
		
	}
}