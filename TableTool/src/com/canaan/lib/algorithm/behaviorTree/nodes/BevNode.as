package com.canaan.lib.algorithm.behaviorTree.nodes
{
	import com.canaan.lib.algorithm.behaviorTree.BevNodeInputParam;
	import com.canaan.lib.algorithm.behaviorTree.BevNodeOutputParam;
	import com.canaan.lib.algorithm.behaviorTree.BevNodePrecondition;
	import com.canaan.lib.algorithm.behaviorTree.BevTracker;
	import com.canaan.lib.algorithm.behaviorTree.constants.BevConstDefine;
	import com.canaan.lib.algorithm.behaviorTree.constants.BevRunningStatus;

	/**
	 * 行为节点
	 * @author Administrator
	 * 
	 */	
	public class BevNode
	{
		protected var mChildNodeList:Vector.<BevNode>;									// 子节点集合
		protected var mChildNodeCount:int;												// 子节点数量
		protected var mParentNode:BevNode;												// 父节点
		protected var mActiveNode:BevNode;												// 活动节点
		protected var mLastActiveNode:BevNode;											// 最后活动节点
		protected var mNodePrecondition:BevNodePrecondition;							// 节点前置条件
		protected var mDisableTime:int;													// 停滞时间
		protected var mDisableTimeInner:int;
		
		protected var _id:String;
		
		public function BevNode(parentNode:BevNode = null, nodePrecondition:BevNodePrecondition = null, disableTime:int = 0)
		{
			mChildNodeList = new Vector.<BevNode>();
			mChildNodeCount = 0;
			mDisableTime = disableTime;
			mDisableTimeInner = 0;
			setParentNode(parentNode);
			setNodePrecondition(nodePrecondition);
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function set id(value:String):void
		{
			_id = value;
		}
		
		/**
		 * 设置父节点
		 * @param parentNode
		 * 
		 */		
		protected function setParentNode(parentNode:BevNode):void {
			mParentNode = parentNode;
		}
		
		/**
		 * 设置节点前置条件
		 * @param nodePrecondition
		 * @return
		 * 
		 */		
		public function setNodePrecondition(nodePrecondition:BevNodePrecondition):BevNode {
			if (mNodePrecondition != nodePrecondition) {
				mNodePrecondition = nodePrecondition;
			}
			return this;
		}
		
		/**
		 * 设置活动节点
		 * @param activeNode
		 * 
		 */		
		public function setActiveNode(activeNode:BevNode):void {
			mLastActiveNode = mActiveNode;
			mActiveNode = activeNode;
			if (mParentNode != null) {
				mParentNode.setActiveNode(activeNode);
			}
		}
		
		/**
		 * 添加子节点
		 * @param childNode
		 * @return 
		 * 
		 */		
		public function addChildNode(childNode:BevNode):BevNode {
			if (mChildNodeCount != BevConstDefine.maxChildNodeCount) {
				mChildNodeList[mChildNodeCount] = childNode;
				mChildNodeCount++;
			}
			return this;
		}
		
		/**
		 * 根据索引获取子节点
		 * @param index
		 * @return 
		 * 
		 */		
		public function getChildNodeByIndex(index:int):BevNode {
			return mChildNodeList[index];
		}
		
		/**
		 * 移除所有的子节点
		 * 
		 */		
		public function removeAllChildNode():void {
			mChildNodeList.length = 0;
			mChildNodeCount = 0;
		}
		
		/**
		 * 检查索引
		 * @param index
		 * @return 
		 * 
		 */		
		protected function checkIndex(index:int):Boolean {
			return index >= 0 && index < mChildNodeCount;
		}
		
		/**
		 * 判断是否可以进入节点
		 * @param inputParam
		 * @return
		 * 
		 */		
		public function evaluate(inputParam:BevNodeInputParam):Boolean {
			if (mDisableTimeInner > 0) {
				mDisableTimeInner -= 33;
				BevTracker.traceNode(inputParam, this, false, "剩余disableTime:" + mDisableTime);
				return false;
			}
			var conditionResult:Boolean = (mNodePrecondition == null || mNodePrecondition.externalCondition(inputParam));
			var nodeResult:Boolean = doEvaluate(inputParam);
			// 跟踪条件判断结果
			if (mNodePrecondition != null) {
				BevTracker.traceCondition(inputParam, mNodePrecondition, conditionResult);
			}
			// 跟踪节点执行结果
			BevTracker.traceNode(inputParam, this, nodeResult);
			var result:Boolean = conditionResult && nodeResult;
			if (mDisableTime <= 0) {
				return result;
			}
			if (result == true) {
				mDisableTimeInner = mDisableTime;
			}
			return result;
		}
		
		/**
		 * 判断是否可以进入节点
		 * @param inputParam
		 * @return 
		 * 
		 */		
		protected function doEvaluate(inputParam:BevNodeInputParam):Boolean {
			if (inputParam == null) {
				return false;
			}
			return true;
		}
		
		/**
		 * 转移
		 * 转移（Transition）指从上一个可运行的节点切换到另一个节点的行为。这个方法会被在节点切换的时候调用，
		 * 比如，在一个带优先级的选择节点下有节点A，和节点B，节点A的优先级高于节点B，当前运行的节点是B，然后发现节点A可以运行了，
		 * 但带优先级的选择节点就会选择去运行节点A，这时就会调用节点B的Transition方法，所以在这个方法中，一般可以用来做一些清理的工作
		 * @param inputParam
		 * 
		 */		
		public function transition(inputParam:BevNodeInputParam):void {
			doTransition(inputParam);
		}
		
		/**
		 * 转移
		 * @param inputParam
		 * 
		 */		
		protected function doTransition(inputParam:BevNodeInputParam):void {
			
		}
		
		/**
		 * 更新
		 * @param inputParam
		 * @param outputParam
		 * @return 
		 * 
		 */		
		public function tick(inputParam:BevNodeInputParam, outputParam:BevNodeOutputParam):int {
			return doTick(inputParam, outputParam);
		}
		
		/**
		 * 更新
		 * @param inputParam
		 * @param outputParam
		 * @return 
		 * 
		 */		
		protected function doTick(inputParam:BevNodeInputParam, outputParam:BevNodeOutputParam):int {
			return BevRunningStatus.FINISH;
		}
		
		/**
		 * 复制节点
		 * @return 
		 * 
		 */		
		public function clone():BevNode {
			var cloneNode:BevNode = new BevNode(mParentNode, mNodePrecondition, mDisableTime);
			for each (var childNode:BevNode in mChildNodeList) {
				cloneNode.addChildNode(childNode.clone());
			}
			return cloneNode;
		}
	}
}