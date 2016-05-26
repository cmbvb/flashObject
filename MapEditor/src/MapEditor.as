package
{
	import com.canaan.lib.core.Application;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.ResManager;
	import com.canaan.mapEditor.core.DataCenter;
	import com.canaan.mapEditor.core.DefaultConfig;
	import com.canaan.mapEditor.core.DefaultSetting;
	import com.canaan.mapEditor.core.GameResPath;
	import com.canaan.mapEditor.core.LayerManager;
	import com.canaan.mapEditor.models.GameModels;
	import com.canaan.mapEditor.view.MainView;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	[SWF(width="1440", height="900", backgroundColor="0x666666", frameRate="30")]
	public class MapEditor extends Sprite
	{
		public static var intance:MapEditor;
		
		public function MapEditor()
		{
			intance = this;
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.nativeWindow.maximize();
			stage.nativeWindow.minSize = new Point(1440, 900);
			
			DefaultConfig.initialize();
			DefaultSetting.initialize();
			GameResPath.initialize();
			DataCenter.initialize();
			Application.initialize(this);
			LayerManager.getInstance().initialize(this);
			loadPreloadFiles();
		}
		
		private function loadPreloadFiles():void {
			ResManager.getInstance().addList(GameResPath.PRELOAD_FILES);
			ResManager.getInstance().load(new Method(loadPreloadFilesComplete));
		}
		
		private function loadPreloadFilesComplete():void {
			loadConfig();
		}
		
		public function loadConfig():Boolean {
			if (DataCenter.loadConfig()) {
				GameModels.initialize();
				var mainView:MainView = new MainView();
				LayerManager.getInstance().mainUI.addChild(mainView);
				return true;
			}
			return false;
		}
		
		public function enable():void {
			mouseEnabled = true;
			mouseChildren = true;
		}
		
		public function disable():void {
			mouseEnabled = false;
			mouseChildren = false;
		}
	}
}