package com.canaan.lib.managers
{
	import flash.events.EventDispatcher;

	/**
	 * 事件管理器
	 * 为方便事件监听，防止多层传递事件，故使用事件管理器进行统一发出和监听
	 * 
	 */	
	public class EventManager extends EventDispatcher
	{
		private static var canInstantiate:Boolean;
		private static var instance:EventManager;

		public function EventManager()
		{
			if (!canInstantiate) {
				throw new Error("Can not instantiate, use getInstance() instead.");
			}
		}
		
		public static function getInstance():EventManager {
			if (instance == null) {
				canInstantiate = true;
				instance = new EventManager();
				canInstantiate = false;
			}
			return instance;
		}
	}
}