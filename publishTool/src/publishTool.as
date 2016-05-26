package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import manager.LayerManager;
	
	import models.GameModels;
	
	import modules.GameModules;
	
	[SWF(width="1440", height="900", backgroundColor="0x000000", frameRate="30")]
	public class publishTool extends Sprite
	{
		public function publishTool()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			App.init(this);
//			App.loader.loadAssets();
			addChild(LayerManager.ins);
			
			LayerManager.ins.init();
			GameModels.init();
			GameModules.init();
		}
		
	}
}