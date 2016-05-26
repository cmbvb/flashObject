package com.canaan.lib.managers
{
	import com.canaan.lib.interfaces.IModule;
	
	import flash.utils.Dictionary;

	public class ModuleManager
	{
		private static var canInstantiate:Boolean;
		private static var instance:ModuleManager;
		
		private var dictionary:Dictionary = new Dictionary();
		
		public function ModuleManager()
		{
			if (!canInstantiate) {
				throw new Error("Can not instantiate, use getInstance() instead.");
			}
		}
		
		public static function getInstance():ModuleManager {
			if (instance == null) {
				canInstantiate = true;
				instance = new ModuleManager();
				canInstantiate = false;
			}
			return instance;
		}
		
		public function registerModule(module:IModule):void {
			dictionary[module] = module;
		}
		
		public function deleteModule(module:IModule):void {
			delete dictionary[module];
		}
		
		public function removeModules(sceneName:String):void {
			var module:IModule;
			for each (module in dictionary) {
				if (module.sceneName == sceneName) {
					module.removeFromScene();
				}
			}
		}
	}
}