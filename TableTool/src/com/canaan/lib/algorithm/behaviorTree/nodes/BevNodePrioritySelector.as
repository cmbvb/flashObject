package com.canaan.lib.algorithm.behaviorTree.nodes
{
	import com.canaan.lib.algorithm.behaviorTree.BevNodeInputParam;
	import com.canaan.lib.algorithm.behaviorTree.BevNodeOutputParam;
	import com.canaan.lib.algorithm.behaviorTree.BevNodePrecondition;
	import com.canaan.lib.algorithm.behaviorTree.constants.BevConstDefine;
	import com.canaan.lib.algorithm.behaviorTree.constants.BevRunningStatus;
	
	/**
	 * 优先选择节点
	 * 当执行本类型Node时，它将从begin到end迭代执行自己的Child Node：
	 * 如遇到一个Child Node执行后返回True，那停止迭代，本Node向自己的Parent Node也返回True；
	 * 否则所有Child Node都返回False，那本Node向自己的Parent Node返回False
	 * @author Administrator
	 * 
	 */	
	public class BevNodePrioritySelector extends BevNode
	{
		protected var _currentSelectIndex:int;								// 当前选择的索引
		protected var mLastSelectIndex:int;									// 上次选择的索引
		
		public function BevNodePrioritySelector(parentNode:BevNode=null, nodePrecondition:BevNodePrecondition=null, disableTime:int=0)
		{
			super(parentNode, nodePrecondition, disableTime);
			_currentSelectIndex = BevConstDefine.invalidChildNodeIndex;
			mLastSelectIndex = BevConstDefine.invalidChildNodeIndex;
		}
		
		override protected function doEvaluate(inputParam:BevNodeInputParam):Boolean {
			_currentSelectIndex = BevConstDefine.invalidChildNodeIndex;
			// 迭代所有子节点，判断子节点是否可以进入
			var childNode:BevNode;
			for (var i:int = 0; i < mChildNodeCount; i++) {
				childNode = mChildNodeList[i];
				if (childNode.evaluate(inputParam) == true) {
					_currentSelectIndex = i;
					return true;
				}
			}
			return false;
		}
		
		override protected function doTransition(inputParam:BevNodeInputParam):void {
			if (checkIndex(mLastSelectIndex) == true) {
				var childNode:BevNode = mChildNodeList[mLastSelectIndex];
				childNode.transition(inputParam);
			}
			mLastSelectIndex = BevConstDefine.invalidChildNodeIndex;
		}
		
		override protected function doTick(inputParam:BevNodeInputParam, outputParam:BevNodeOutputParam):int {
			var childNode:BevNode;
			var runningStatus:int = BevRunningStatus.FINISH;
			// 对当前子节点进行转换
			if (checkIndex(_currentSelectIndex) == true) {
				if (mLastSelectIndex != _currentSelectIndex) {
					if (checkIndex(mLastSelectIndex) == true) {
						childNode = mChildNodeList[mLastSelectIndex];
						childNode.transition(inputParam);
					}
					mLastSelectIndex = _currentSelectIndex;
				}
			}
			// 更新子节点
			if (checkIndex(mLastSelectIndex) == true) {
				childNode = mChildNodeList[mLastSelectIndex];
				runningStatus = childNode.tick(inputParam, outputParam);
				if (runningStatus) {
					mLastSelectIndex = BevConstDefine.invalidChildNodeIndex;
				}
			}
			return runningStatus;
		}

		public function get currentSelectIndex():int {
			return _currentSelectIndex;
		}

		public function set currentSelectIndex(value:int):void {
			_currentSelectIndex = value;
		}
		
		override public function clone():BevNode {
			var cloneNode:BevNodePrioritySelector = new BevNodePrioritySelector(mParentNode, mNodePrecondition, mDisableTime);
			for each (var childNode:BevNode in mChildNodeList) {
				cloneNode.addChildNode(childNode.clone());
			}
			return cloneNode;
		}
	}
}