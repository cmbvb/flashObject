package com.canaan.lib.algorithm.behaviorTree.nodes
{
	import com.canaan.lib.algorithm.behaviorTree.BevNodeInputParam;
	import com.canaan.lib.algorithm.behaviorTree.BevNodeOutputParam;
	import com.canaan.lib.algorithm.behaviorTree.BevNodePrecondition;
	import com.canaan.lib.algorithm.behaviorTree.constants.BevConstDefine;
	import com.canaan.lib.algorithm.behaviorTree.constants.BevParallelFinishCondition;
	import com.canaan.lib.algorithm.behaviorTree.constants.BevRunningStatus;
	
	/**
	 * 平行节点
	 * 平行执行它的所有Child Node。而向Parent Node返回的值和Parallel Node所采取的具体策略相关
	 * @author Administrator
	 * 
	 */	
	public class BevNodeParallel extends BevNode
	{
		protected var mFinishCondition:int;									// 完成条件
		protected var mChildNodeStatus:Vector.<int>;						// 子节点状态列表
		
		public function BevNodeParallel(parentNode:BevNode=null, nodePrecondition:BevNodePrecondition=null)
		{
			super(parentNode, nodePrecondition);
			mFinishCondition = BevParallelFinishCondition.OR;
			mChildNodeStatus = new Vector.<int>();
			// 迭代设置所有子节点运行状态为执行中
			for (var i:int = 0; i < BevConstDefine.maxChildNodeCount; i++) {
				mChildNodeStatus[i] = BevRunningStatus.EXECUTING;
			}
		}
		
		override protected function doEvaluate(inputParam:BevNodeInputParam):Boolean {
			// 平行判断所有子节点
			var childNode:BevNode;
			for (var i:int = 0; i < mChildNodeCount; i++) {
				childNode = mChildNodeList[i];
				if (mChildNodeStatus[i] == BevRunningStatus.EXECUTING) {
					if (childNode.evaluate(inputParam) == false) {
						return false;
					}
				}
			}
			return true;
		}
		
		override protected function doTransition(inputParam:BevNodeInputParam):void {
			// 平行转换所有子节点
			var childNode:BevNode;
			var i:int;
			for (i = 0; i < BevConstDefine.maxChildNodeCount; i++) {
				mChildNodeStatus[i] = BevRunningStatus.EXECUTING;
			}
			for (i = 0; i < mChildNodeCount; i++) {
				childNode = mChildNodeList[i];
				childNode.transition(inputParam);
			}
		}
		
		override protected function doTick(inputParam:BevNodeInputParam, outputParam:BevNodeOutputParam):int {
			// 平行更新所有子节点
			var childNode:BevNode;
			var executingCount:int;
			for (var i:int = 0; i < mChildNodeCount; i++) {
				childNode = mChildNodeList[i];
				// 判断条件为或
				if (mFinishCondition == BevParallelFinishCondition.OR) {
					// 子节点运行状态为运行中则先运行一次
					if (mChildNodeStatus[i] == BevRunningStatus.EXECUTING) {
						mChildNodeStatus[i] = childNode.tick(inputParam, outputParam);
					}
					// 子节点运行状态不为运行中则返回执行完毕，并重置所有节点为运行中
					if (mChildNodeStatus[i] != BevRunningStatus.EXECUTING) {
						for (var j:int = 0; j < BevConstDefine.maxChildNodeCount; j++) {
							mChildNodeStatus[j] = BevRunningStatus.EXECUTING;
						}
						return BevRunningStatus.FINISH;
					}
				}
				// 判断条件为与
				else if (mFinishCondition == BevParallelFinishCondition.AND) {
					// 子节点运行状态为运行中则更新子节点
					if (mChildNodeStatus[i] == BevRunningStatus.EXECUTING) {
						mChildNodeStatus[i] = childNode.tick(inputParam, outputParam);
					}
					if (mChildNodeStatus[i] != BevRunningStatus.EXECUTING) {
						executingCount++;
					}
				}
			}
			// 所有子节点均不在执行中则返回执行完毕，并重置所有节点为运行中
			if (executingCount == mChildNodeCount) {
				for (var k:int = 0; k < BevConstDefine.maxChildNodeCount; k++) {
					mChildNodeStatus[k] = BevRunningStatus.EXECUTING;
				}
				return BevRunningStatus.FINISH;
			}
			return BevRunningStatus.EXECUTING;
		}
		
		/**
		 * 设置完成条件
		 * @param finishCondition
		 * @return 
		 * 
		 */		
		public function setFinishCondition(finishCondition:int):BevNodeParallel {
			mFinishCondition = finishCondition;
			return this;
		}
		
		override public function clone():BevNode {
			return new BevNodeParallel(mParentNode, mNodePrecondition);
		}
	}
}