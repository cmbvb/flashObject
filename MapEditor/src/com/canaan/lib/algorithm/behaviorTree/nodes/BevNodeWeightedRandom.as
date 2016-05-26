package com.canaan.lib.algorithm.behaviorTree.nodes
{
	import com.canaan.lib.algorithm.behaviorTree.BevNodeInputParam;
	import com.canaan.lib.algorithm.behaviorTree.BevNodePrecondition;
	import com.canaan.lib.algorithm.behaviorTree.constants.BevConstDefine;
	
	/**
	 * 随机加权节点
	 * Weight Random Selector Node提供每次执行不同First True Child Node的功能。
	 * @author Administrator
	 * 
	 */	
	public class BevNodeWeightedRandom extends BevNodePrioritySelector
	{
		protected var mChildWeightedList:Vector.<int>;							// 子节点权重列表
		
		public function BevNodeWeightedRandom(parentNode:BevNode=null, childWeightedList:Vector.<int>=null, nodePrecondition:BevNodePrecondition=null, disableTime:int=0)
		{
			super(parentNode, nodePrecondition, disableTime);
			setChildWeights(childWeightedList);
		}
		
		override protected function doEvaluate(inputParam:BevNodeInputParam):Boolean {
			var childNode:BevNode;
			_currentSelectIndex = BevConstDefine.invalidChildNodeIndex;
			// 随机权重
			var randomWeighted:int = Math.random() * 100;
			// 上次计算总权重
			var lastTotalWeighted:int;
			// 总权重
			var totalWeighted:int;
			// 子节点权重
			var childWeighted:int;
			for (var i:int = 0; i < mChildWeightedList.length; i++) {
				lastTotalWeighted = totalWeighted;
				childWeighted = mChildWeightedList[i];
				totalWeighted = lastTotalWeighted + childWeighted;
				if (lastTotalWeighted < randomWeighted && randomWeighted <= totalWeighted) {
					childNode = mChildNodeList[i];
					if (childNode.evaluate(inputParam) == true) {
						_currentSelectIndex = i;
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * 设置子节点权重列表
		 * @param childWeightedList
		 * 
		 */		
		public function setChildWeights(childWeightedList:Vector.<int>):void {
			mChildWeightedList = childWeightedList;
		}
		
		override public function clone():BevNode {
			var cloneNode:BevNodeWeightedRandom = new BevNodeWeightedRandom(mParentNode, mChildWeightedList, mNodePrecondition, mDisableTime);
			for each (var childNode:BevNode in mChildNodeList) {
				cloneNode.addChildNode(childNode.clone());
			}
			return cloneNode;
		}
	}
}