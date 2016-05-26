package com.canaan.lib.abstract
{
	import com.canaan.lib.events.SceneEvent;
	import com.canaan.lib.interfaces.IModule;
	import com.canaan.lib.interfaces.IScene;
	import com.canaan.lib.managers.SceneManager;
	
	import flash.events.EventDispatcher;
	
	public class AbstractScene extends EventDispatcher implements IScene
	{
		protected var _sceneName:String;
		
		public function AbstractScene(sceneName:String)
		{
			_sceneName = sceneName;
			SceneManager.getInstance().registerScene(this);
		}
		
		public function enterScene():void {
			dispatchEvent(new SceneEvent(SceneEvent.ENTER_SCENE));
		}
		
		public function exitScene():void {
			dispatchEvent(new SceneEvent(SceneEvent.EXIT_SCENE));
		}
		
		protected function showModule(module:IModule):void {
			module.addedToScene(_sceneName);
		}
		
		protected function removeModule(module:IModule):void {
			module.removeFromScene();
		}
		
		public function get sceneName():String {
			return _sceneName;
		}
	}
}