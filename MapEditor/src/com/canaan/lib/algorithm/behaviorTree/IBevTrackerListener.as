package com.canaan.lib.algorithm.behaviorTree
{
	import com.canaan.lib.algorithm.behaviorTree.nodes.BevNode;

	/**
	 * 行为跟踪器监听器
	 * @author Administrator
	 * 
	 */	
	public interface IBevTrackerListener
	{
		/**
		 * 输出节点执行结果
		 * @param inputParam
		 * @param node
		 * @param result
		 * @param text
		 * 
		 */		
		function traceNode(inputParam:BevNodeInputParam, node:BevNode, result:Boolean, text:String = ""):void;
		
		/**
		 * 输出条件判断结果
		 * @param inputParam
		 * @param condition
		 * @param result
		 * @param text
		 * 
		 */		
		function traceCondition(inputParam:BevNodeInputParam, condition:BevNodePrecondition, result:Boolean, text:String = ""):void;
	}
}