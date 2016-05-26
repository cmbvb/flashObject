package mapTool.module.mainUI
{
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import manager.LayerManager;

	public class ModuleMainUI
	{
		public var mapView:MapView;
		public var mainUITopLeft:MainUITopLeftView;
		
		public function ModuleMainUI()
		{
			mapView = new MapView();
			mainUITopLeft = new MainUITopLeftView();
			
			App.stage.addEventListener(Event.RESIZE, resizeHandler);
			
			LayerManager.ins.mainUI.addChild(mapView);
			LayerManager.ins.mainUI.addChild(mainUITopLeft);
			resizeHandler();
		}
		
		private function resizeHandler(event:Event = null):void {
			mainUITopLeft.setPosition(0, 0);
			mapView.setPosition(0, 0);
		}
		
		public function showMap(bitmapData:BitmapData):void {
			mapView.show(bitmapData);
		}
		
		public function showGrid():void {
			mapView.setGridVisible();
		}
		
	}
}