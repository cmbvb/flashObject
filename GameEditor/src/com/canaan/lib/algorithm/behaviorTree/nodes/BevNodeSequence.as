package com.canaan.lib.algorithm.behaviorTree.nodes
{
	import com.canaan.lib.algorithm.behaviorTree.BevNodeInputParam;
	import com.canaan.lib.algorithm.behaviorTree.BevNodeOutputParam;
	import com.canaan.lib.algorithm.behaviorTree.BevNodePrecondition;
	import com.canaan.lib.algorithm.behaviorTree.constants.BevConstDefine;
	import com.canaan.lib.algorithm.behaviorTree.constants.BevRunningStatus;
	
	/**
	 * 序列节点
	 * 当执行本类型Node时，它将从begin到end迭代执行自己的Child Node：
	 * 如遇到一个Child Node执行后返回False，那停止迭代，
	 * 本Node向自己的Parent Node也返回False；否则所有Child Node都返回True，
	 * 那本Node向自己的Parent Node返回True。
	 * @author Administrator
	 * 
	 */	
	public class BevNodeSequence extends BevNode
	{
		protected var mCurrentNodeIndex:int;								// 当前节点索引
		
		public function BevNodeSequence(parentNode:BevNode=null, nodePrecondition:BevNodePrecondition=null)
		{
			super(parentNode, nodePrecondition);
			mCurrentNodeIndex = BevConstDefine.invalidChildNodeIndex;
		}
		
		override protected function doEvaluate(inputParam:BevNodeInputParam):Boolean {
			var childNode:BevNode;
			var childIndex:int;
			if (mCurrentNodeIndex == BevConstDefine.invalidChildNodeIndex) {
				childIndex = 0;
			} else {
				childIndex = mCurrentNodeIndex;
			}
			if (checkIndex(childIndex) == true) {
				childNode = mChildNodeList[childIndex];
				if (childNode.evaluate(inputParam) == true) {
					return true;
				}
			}
			return false;
		}
		
		override protected function doTransition(inputParam:BevNodeInputParam):void {
			var childNode:BevNode;
			if (checkIndex(mCurrentNodeIndex) == true) {
				childNode = mChildNodeList[mCurrentNodeIndex];
				childNode.transition(inputParam);
			}
			mCurrentNodeIndex = BevConstDefine.invalidChildNodeIndex;
		}
		
		override protected function doTick(inputParam:BevNodeInputParam, outputParam:BevNodeOutputParam):int {
			var runningState:int = BevRunningStatus.FINISH;
			if (mCurrentNodeIndex == BevConstDefine.invalidChildNodeIndex) {
				mCurrentNodeIndex = 0;
			}
			// 更新当前子节点
			var childNode:BevNode = mChildNodeList[mCurrentNodeIndex];
			runningState = childNode.tick(inputParam, outputParam);
			// 运行状态为完成，如果所有节点均运行完毕，则重置当前子节点索引，否则运行状态为运行中
			if (runningState == BevRunningStatus.FINISH) {
				mCurrentNodeIndex++;
				if (mCurrentNodeIndex == mChildNodeCount) {
					mCurrentNodeIndex = BevConstDefine.invalidChildNodeIndex;
				} else {
					runningState = BevRunningStatus.EXECUTING;
				}
			}
			if (runningState < 0) {
				mCurrentNodeIndex = BevConstDefine.invalidChildNodeIndex;
			}
			return runningState;
		}
		
		override public function clone():BevNode {
			return new BevNodeSequence(mParentNode, mNodePrecondition);
		}
	}
}