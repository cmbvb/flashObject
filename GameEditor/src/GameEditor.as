package
{
	import com.canaan.gameEditor.core.DataCenter;
	import com.canaan.gameEditor.core.DefaultConfig;
	import com.canaan.gameEditor.core.GameResPath;
	import com.canaan.gameEditor.core.LayerManager;
	import com.canaan.gameEditor.view.MainView;
	import com.canaan.lib.core.Application;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.ResManager;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width="1440", height="900", backgroundColor="0xFFFFFF", frameRate="30")]
	public class GameEditor extends Sprite
	{
		public function GameEditor()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			GameResPath.initialize();
			DataCenter.initialize();
			DefaultConfig.initialize();
			Application.initialize(this);
			LayerManager.getInstance().initialize(this);
			loadPreloadFiles();
		}
		
		private function loadPreloadFiles():void {
			ResManager.getInstance().addList(GameResPath.PRELOAD_FILES);
			ResManager.getInstance().load(new Method(loadPreloadFilesComplete));
		}
		
		private function loadPreloadFilesComplete():void {
			var mainView:MainView = new MainView();
			LayerManager.getInstance().mainUI.addChild(mainView);
		}
	}
}