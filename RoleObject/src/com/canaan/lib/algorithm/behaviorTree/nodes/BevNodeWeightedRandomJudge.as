package com.canaan.lib.algorithm.behaviorTree.nodes
{
	import com.canaan.lib.algorithm.behaviorTree.BevNodeInputParam;
	import com.canaan.lib.algorithm.behaviorTree.BevNodePrecondition;
	import com.canaan.lib.algorithm.behaviorTree.constants.BevConstDefine;
	
	/**
	 * 随机加权判断排除节点
	 * @author Administrator
	 * 
	 */	
	public class BevNodeWeightedRandomJudge extends BevNodeWeightedRandom
	{
		protected var mJudge:Boolean;									// 要排除的判断状态
		protected var mReSelect:Boolean;								// 是否重新选择
		
		public function BevNodeWeightedRandomJudge(parentNode:BevNode=null, childWeightedList:Vector.<int>=null, nodePrecondition:BevNodePrecondition=null, judge:Boolean=true, disableTime:int=0)
		{
			super(parentNode, childWeightedList, nodePrecondition, disableTime);
			mJudge = judge;
			mReSelect = false;
		}
		
		override protected function doEvaluate(inputParam:BevNodeInputParam):Boolean {
			var childNode:BevNode;
			var result:Boolean;
			// 如果存在当前选择的节点并且开启重新选择
			if (_currentSelectIndex != BevConstDefine.invalidChildNodeIndex && mReSelect == true) {
				childNode = mChildNodeList[_currentSelectIndex];
				result = childNode.evaluate(inputParam);
				mReSelect = result == mJudge;
				return result;
			}
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
					result = childNode.evaluate(inputParam);
					mReSelect = result == mJudge;
					if (result == true) {
						_currentSelectIndex = i;
						return true;
					}
				}
			}
			return false;
		}
		
		override public function clone():BevNode {
			var cloneNode:BevNodeWeightedRandomJudge = new BevNodeWeightedRandomJudge(mParentNode, mChildWeightedList, mNodePrecondition, mJudge, mDisableTime);
			for each (var childNode:BevNode in mChildNodeList) {
				cloneNode.addChildNode(childNode.clone());
			}
			return cloneNode;
		}
	}
}