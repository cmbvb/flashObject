package com.canaan.lib.algorithm.behaviorTree.nodes
{
	import com.canaan.lib.algorithm.behaviorTree.BevNodeInputParam;
	import com.canaan.lib.algorithm.behaviorTree.BevNodeOutputParam;
	import com.canaan.lib.algorithm.behaviorTree.BevNodePrecondition;
	import com.canaan.lib.algorithm.behaviorTree.constants.BevConstDefine;
	import com.canaan.lib.algorithm.behaviorTree.constants.BevRunningStatus;
	
	/**
	 * 循环节点
	 * 循环执行第一个子节点
	 * @author Administrator
	 * 
	 */	
	public class BevNodeLoop extends BevNode
	{
		protected var mLoopCount:int;									// 循环次数
		protected var mCurrentCount:int;								// 当前循环次数
		
		public function BevNodeLoop(parentNode:BevNode=null, nodePrecondition:BevNodePrecondition=null, loopCount:int=-1, disableTime:int=0)
		{
			super(parentNode, nodePrecondition, disableTime);
			mLoopCount = loopCount;
		}
		
		override protected function doEvaluate(inputParam:BevNodeInputParam):Boolean {
			var result:Boolean = mLoopCount == BevConstDefine.infiniteLoop || mCurrentCount < mLoopCount;
			if (result == false) {
				return false;
			}
			// 判断第一个子节点的进入函数
			if (checkIndex(0) == true) {
				var childNode:BevNode = mChildNodeCount[0];
				if (childNode.evaluate(inputParam)) {
					return true;
				}
			}
			return false;
		}
		
		override protected function doTransition(inputParam:BevNodeInputParam):void {
			// 执行第一个子节点的跳转函数
			if (checkIndex(0) == true) {
				var childNode:BevNode = mChildNodeList[0];
				childNode.transition(inputParam);
			}
			mCurrentCount = 0;
		}
		
		override protected function doTick(inputParam:BevNodeInputParam, outputParam:BevNodeOutputParam):int {
			var runningStatus:int = BevRunningStatus.FINISH;
			// 执行第一个子节点的更新函数
			if (checkIndex(0) == true) {
				var childNode:BevNode = mChildNodeList[0];
				runningStatus = childNode.tick(inputParam, outputParam);
				// 子节点执行成功 判断本节点是否执行完毕
				if (runningStatus == BevRunningStatus.FINISH) {
					if (mLoopCount != BevConstDefine.infiniteLoop) {
						mCurrentCount++;
						if (mCurrentCount == mLoopCount) {
							runningStatus = BevRunningStatus.EXECUTING;
						}
					} else {
						runningStatus = BevRunningStatus.EXECUTING;
					}
				}
			}
			if (runningStatus) {
				mCurrentCount = 0;
			}
			return runningStatus;
		}
		
		override public function clone():BevNode {
			return new BevNodeLoop(mParentNode, mNodePrecondition, mLoopCount, mDisableTime);
		}
	}
}