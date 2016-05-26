package com.canaan.lib.abstract
{
	import com.canaan.lib.interfaces.IDispose;
	import com.canaan.lib.interfaces.IModel;
	import com.canaan.lib.net.ServerResult;
	
	import flash.events.EventDispatcher;
	
	public class AbstractModel extends EventDispatcher implements IModel, IDispose
	{
		protected var _initialized:Boolean;
		protected var _protocols:Array;
		
		public function AbstractModel()
		{
			registerprotocolInterests();
		}
		
		/**
		 * 注册感兴趣的系统命令 
		 * 
		 */		
		protected function registerprotocolInterests():void {
			_protocols = listProtocolInterests();
			if (_protocols != null && _protocols.length != 0) {
				for each (var protocol:* in _protocols) {
					registerHandler(protocol);
				}
			}
		}
		
		protected function registerHandler(protocol:*):void {
			
		}
		
		protected function deleteHandler(protocol:*):void {
			
		}
		
		/**
		 * 系统命令监听集合 
		 * @return 
		 * 
		 */		
		protected function listProtocolInterests():Array {
			return null;
		}

		/**
		 * 处理感兴趣的协议
		 * @param result
		 * 
		 */		
		protected function handleProtocol(result:ServerResult):void {
			
		}
		
		/**
		 * 是否已经初始化 
		 * @return 
		 * 
		 */		
		public function get initialized():Boolean {
			return _initialized;
		}
		
		/**
		 * 自动初始化 
		 * @param value
		 * 
		 */		
		public function autoInitialize(value:Object = null):void {
			_initialized = false;
		}
		
		public function dispose():void {
			for each (var protocol:* in _protocols) {
				deleteHandler(protocol);
			}
			_initialized = false;
		}
	}
}