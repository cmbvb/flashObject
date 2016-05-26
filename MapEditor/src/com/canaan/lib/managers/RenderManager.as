package com.canaan.lib.managers
{
	import com.canaan.lib.events.UIEvent;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class RenderManager
	{
		private static var canInstantiate:Boolean;
		private static var instance:RenderManager;
		
		private var _methods:Dictionary = new Dictionary();
		
		public function RenderManager()
		{
			if (!canInstantiate) {
				throw new Error("Can not instantiate, use getInstance() instead.");
			}
		}
		
		public static function getInstance():RenderManager {
			if (instance == null) {
				canInstantiate = true;
				instance = new RenderManager();
				canInstantiate = false;
			}
			return instance;
		}
		
		private function invalidate():void {
			StageManager.getInstance().stage.addEventListener(Event.RENDER, onValidate);
			StageManager.getInstance().stage.addEventListener(Event.ENTER_FRAME, onValidate);
			if (StageManager.getInstance().stage) {
				StageManager.getInstance().stage.invalidate();
			}
		}
		
		private function onValidate(e:Event):void {
			StageManager.getInstance().stage.removeEventListener(Event.RENDER, onValidate);
			StageManager.getInstance().stage.removeEventListener(Event.ENTER_FRAME, onValidate);
			renderAll();
			StageManager.getInstance().stage.dispatchEvent(new Event(UIEvent.RENDER_COMPLETED));
		}
		
		/**执行所有延迟调用*/
		public function renderAll():void {
			for (var method:Object in _methods) {
				exeCallLater(method as Function);
			}
		}
		
		/**延迟调用*/
		public function callLater(method:Function, args:Array = null):void {
			if (_methods[method] == null) {
				_methods[method] = args || [];
				invalidate();
			}
		}
		
		/**执行延迟调用*/
		public function exeCallLater(method:Function):void {
			if (_methods[method] != null) {
				var args:Array = _methods[method];
				delete _methods[method];
				method.apply(null, args);
			}
		}
	}
}