package com.canaan.lib.abstract
{
	import com.canaan.lib.events.ModuleEvent;
	import com.canaan.lib.interfaces.IModule;
	import com.canaan.lib.managers.ModuleManager;
	import com.canaan.lib.managers.SceneManager;
	
	import flash.events.EventDispatcher;

	public class AbstractModule extends EventDispatcher implements IModule
	{
		protected var _sceneName:String;
		protected var _viewInitialized:Boolean;
		
		public function AbstractModule()
		{
			ModuleManager.getInstance().registerModule(this);
		}
		
		public function addedToScene(sceneName:String):void {
			_sceneName = sceneName;
			if (!_viewInitialized) {
				initializeView();
				_viewInitialized = true;
			}
			show();
			dispatchEvent(new ModuleEvent(ModuleEvent.ADDED_TO_SCENE));
		}
		
		public function addedToCurrentScene():void {
			if (SceneManager.getInstance().currentScene) {
				addedToScene(SceneManager.getInstance().currentScene.sceneName);
			}
		}
		
		public function get viewInitialized():Boolean {
			return _viewInitialized;
		}
		
		public function removeFromScene():void {
			remove();
			dispatchEvent(new ModuleEvent(ModuleEvent.REMOVE_FROM_SCENE));
			_sceneName = null;
		}
		
		/**
		 * 初始化视图，用于模块对应视图的初始化
		 * 此方法需要重写 
		 * 
		 */		
		protected function initializeView():void {
			
		}
		
		/**
		 * 显示模块中的视图
		 * 此方法需要重写
		 * 
		 */
		protected function show():void {
			
		}
		
		/**
		 * 移除模块中的视图
		 * 此方法需要重写 
		 * 
		 */		
		protected function remove():void {
			
		}
		
		public function get sceneName():String {
			return _sceneName;
		}
	}
}