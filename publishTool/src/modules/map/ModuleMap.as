package modules.map
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import manager.LayerManager;
	
	import utils.TypeRoleDirection;

	public class ModuleMap
	{
		private var mapView:MapView;
		private var centerPoint:Point = new Point(2560, 2560);
		
		public function ModuleMap()
		{
			mapView = new MapView();
			LayerManager.ins.map.addChild(mapView);
			var load:URLLoader = new URLLoader();
			load.dataFormat = URLLoaderDataFormat.BINARY;
			var urlR:URLRequest = new URLRequest("map/assets/mapData/shameng.mpd");
			load.load(urlR);
			load.addEventListener(Event.COMPLETE, onComplete);
			mapView.showMap(centerPoint);
		}
		
		private function onComplete(event:Event):void {
			var obj:Object;
			var data:ByteArray = event.target.data as ByteArray;
			data.position = 0;
			obj = data.readObject();
		}
		
		public function moveMap(type:int):void {
			switch (type) {
				case TypeRoleDirection.DOWN:
					centerPoint.y += 48;
					mapView.y += 48;
					break;
				case TypeRoleDirection.LEFT:
					centerPoint.x -= 68;
					mapView.x -= 68;
					break;
				case TypeRoleDirection.LEFT_DOWN:
					centerPoint.x -= 68;
					centerPoint.y += 48;
					mapView.y += 48;
					mapView.x -= 68;
					break;
				case TypeRoleDirection.LEFT_UP:
					centerPoint.y -= 48;
					centerPoint.x -= 68;
					mapView.y -= 48;
					mapView.x -= 68;
					break;
				case TypeRoleDirection.RIGHT:
					centerPoint.x += 68;
					mapView.x += 68;
					break;
				case TypeRoleDirection.RIGHT_DOWN:
					centerPoint.x += 68;
					centerPoint.y += 48;
					mapView.x += 68;
					mapView.y += 48;
					break;
				case TypeRoleDirection.RIGHT_UP:
					centerPoint.x += 68;
					centerPoint.y -= 48;
					mapView.x += 68;
					mapView.y -= 48;
					break;
				case TypeRoleDirection.UP:
					centerPoint.y -= 48;
					mapView.y -= 48;
					break;
			}
			mapView.showMap(centerPoint);
		}
		
	}
}