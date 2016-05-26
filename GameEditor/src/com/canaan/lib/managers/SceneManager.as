package com.canaan.lib.managers
{
	import com.canaan.lib.debug.Log;
	import com.canaan.lib.events.SceneEvent;
	import com.canaan.lib.interfaces.IScene;
	
	import flash.utils.Dictionary;

	public class SceneManager
	{
		private static var canInstantiate:Boolean;
		private static var instance:SceneManager;
		
		private var dictionary:Dictionary = new Dictionary();
		private var _currentScene:IScene;
		private var _nextScene:IScene;
		
		public function SceneManager()
		{
			if (!canInstantiate) {
				throw new Error("Can not instantiate, use getInstance() instead.");
			}
		}
		
		public static function getInstance():SceneManager {
			if (instance == null) {
				canInstantiate = true;
				instance = new SceneManager();
				canInstantiate = false;
			}
			return instance;
		}
		
		public function registerScene(scene:IScene):void {
			var sceneName:String = scene.sceneName;
			if (dictionary[sceneName]) {
				Log.getInstance().error("SceneManager.registerScene \"" + sceneName + "\" has already registered!");
				return;
			}
			dictionary[sceneName] = scene;
		}
		
		public function enterScene(scene:IScene):void {
			var sceneName:String = scene.sceneName;
			if (_currentScene != null && _currentScene.sceneName == sceneName) {
				return;
			}
			_nextScene = dictionary[sceneName];
			if (!_nextScene) {
				Log.getInstance().error("SceneManager.enterScene \"" + sceneName + "\" has not registered!");
				return;
			}
			if (!exitCurrentScene()) {
				enterNextScene();
			}
		}
		
		private function exitCurrentScene():Boolean {
			if (!_currentScene) {
				return false;
			}
			ModuleManager.getInstance().removeModules(_currentScene.sceneName);
			_currentScene.addEventListener(SceneEvent.EXIT_SCENE, onExitScene);
			_currentScene.exitScene();
			return true;
		}
		
		private function onExitScene(event:SceneEvent):void {
			_currentScene.removeEventListener(SceneEvent.EXIT_SCENE, onExitScene);
			enterNextScene();
		}
		
		private function enterNextScene():void {
			_nextScene.enterScene();
			_currentScene = _nextScene;
			_nextScene = null
		}
		
		public function get currentScene():IScene {
			return _currentScene;
		}
		
		public function get nextScene():IScene {
			return _nextScene;
		}
	}
}