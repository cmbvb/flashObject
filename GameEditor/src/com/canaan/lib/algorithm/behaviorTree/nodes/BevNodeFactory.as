package com.canaan.lib.algorithm.behaviorTree.nodes
{
	/**
	 * 节点创建工厂
	 * @author Administrator
	 * 
	 */	
	public class BevNodeFactory
	{
		/**
		 * 创建通用节点
		 * @param childNode
		 * @param parentNode
		 * 
		 */		
		public static function createNodeCommon(childNode:BevNode, parentNode:BevNode):void {
			if (parentNode != null) {
				parentNode.addChildNode(childNode);
			}
		}
		
		/**
		 * 创建平行节点
		 * @param parentNode
		 * @param finishCondition
		 * @return 
		 * 
		 */		
		public static function createParalleNode(parentNode:BevNode, finishCondition:int):BevNode {
			var node:BevNodeParallel = new BevNodeParallel(parentNode);
			node.setFinishCondition(finishCondition);
			createNodeCommon(node, parentNode);
			return node;
		}
		
		/**
		 * 创建优先选择节点
		 * @param parentNode
		 * @param disableTime
		 * @return 
		 * 
		 */		
		public static function createPrioritySelectorNode(parentNode:BevNode, disableTime:int):BevNode {
			var node:BevNodePrioritySelector = new BevNodePrioritySelector(parentNode, null, disableTime);
			createNodeCommon(node, parentNode);
			return node;
		}
		
		/**
		 * 创建非优先选择节点
		 * @param parentNode
		 * @param falseClear
		 * @param loop
		 * @param disableTime
		 * @return 
		 * 
		 */		
		public static function createNonePrioritySelectorNode(parentNode:BevNode, falseClear:Boolean, loop:Boolean, disableTime:int):BevNode {
			var node:BevNodeNonePrioritySelector = new BevNodeNonePrioritySelector(parentNode, null, falseClear, loop, disableTime);
			createNodeCommon(node, parentNode);
			return node;
		}
		
		/**
		 * 创建序列节点
		 * @param parentNode
		 * @return 
		 * 
		 */		
		public static function createSequenceNode(parentNode:BevNode):BevNode {
			var node:BevNodeSequence = new BevNodeSequence(parentNode);
			createNodeCommon(node, parentNode);
			return node;
		}
		
		/**
		 * 创建循环节点
		 * @param parentNode
		 * @param loopCount
		 * @param disableTime
		 * @return 
		 * 
		 */		
		public static function createLoopNode(parentNode:BevNode, loopCount:int, disableTime:int):BevNode {
			var node:BevNodeLoop = new BevNodeLoop(parentNode, null, loopCount, disableTime);
			createNodeCommon(node, parentNode);
			return node;
		}
		
		/**
		 * 创建随机加权节点
		 * @param parentNode
		 * @param childWeightedList
		 * @param disableTime
		 * @return 
		 * 
		 */		
		public static function createWeightedRandomNode(parentNode:BevNode, childWeightedList:Vector.<int>, disableTime:int):BevNode {
			var node:BevNodeWeightedRandom = new BevNodeWeightedRandom(parentNode, childWeightedList, null, disableTime);
			createNodeCommon(node, parentNode);
			return node;
		}
		
		/**
		 * 创建随机加权判断排除节点
		 * @param parentNode
		 * @param childWeightedList
		 * @param judge
		 * @param disableTime
		 * @return 
		 * 
		 */		
		public static function createWeightedRandomJudgeNode(parentNode:BevNode, childWeightedList:Vector.<int>, judge:Boolean, disableTime:int):BevNode {
			var node:BevNodeWeightedRandomJudge = new BevNodeWeightedRandomJudge(parentNode, childWeightedList, null, judge, disableTime);
			createNodeCommon(node, parentNode);
			return node;
		}
		
		/**
		 * 创建叶子节点
		 * @param node
		 * @param parentNode
		 * @return 
		 * 
		 */		
		public static function createTeminalNode(node:BevNodeTerminal, parentNode:BevNode):BevNode {
			createNodeCommon(node, parentNode);
			return node;
		}
	}
}