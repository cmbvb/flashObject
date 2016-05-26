package com.canaan.lib.algorithm.behaviorTree
{
	import com.canaan.lib.algorithm.behaviorTree.nodes.BevNode;

	/**
	 * 行为跟踪器
	 * @author Administrator
	 * 
	 */	
	public class BevTracker
	{
		private static var mListeners:Vector.<IBevTrackerListener> = new Vector.<IBevTrackerListener>();				// 行为跟踪器监听器
		
		private static var _enabled:Boolean;
		
		public function BevTracker()
		{
		}
		
		/**
		 * 添加监听器
		 * @param listener
		 * 
		 */		
		public static function addListener(listener:IBevTrackerListener):void {
			if (mListeners.indexOf(listener) == -1) {
				mListeners.push(listener);
			}
		}
		
		/**
		 * 输出节点执行结果
		 * @param inputParam
		 * @param node
		 * @param result
		 * @param text
		 * 
		 */		
		public static function traceNode(inputParam:BevNodeInputParam, node:BevNode, result:Boolean, text:String = ""):void {
			if (_enabled) {
				for each (var listener:IBevTrackerListener in mListeners) {
					listener.traceNode(inputParam, node, result, text);
				}
			}
		}
		
		/**
		 * 输出条件判断结果
		 * @param inputParam
		 * @param condition
		 * @param result
		 * @param text
		 * 
		 */		
		public static function traceCondition(inputParam:BevNodeInputParam, condition:BevNodePrecondition, result:Boolean, text:String = ""):void {
			if (_enabled) {
				for each (var listener:IBevTrackerListener in mListeners) {
					listener.traceCondition(inputParam, condition, result, text);
				}
			}
		}

		public static function get enabled():Boolean
		{
			return _enabled;
		}

		public static function set enabled(value:Boolean):void
		{
			_enabled = value;
		}
	}
}