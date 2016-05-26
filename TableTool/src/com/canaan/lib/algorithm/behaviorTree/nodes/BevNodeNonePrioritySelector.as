package com.canaan.lib.algorithm.behaviorTree.nodes
{
	import com.canaan.lib.algorithm.behaviorTree.BevNodeInputParam;
	import com.canaan.lib.algorithm.behaviorTree.BevNodePrecondition;
	
	/**
	 * 非优先选择节点
	 * 依次执行当前节点下的所有节点
	 * @author Administrator
	 * 
	 */	
	public class BevNodeNonePrioritySelector extends BevNodePrioritySelector
	{
		protected var _falseClear:Boolean;										// 是否错误清除
		protected var _loop:Boolean;											// 是否循环
		protected var mNextSelectIndex:int;										// 下一个选择的节点
		
		public function BevNodeNonePrioritySelector(parentNode:BevNode=null, nodePrecondition:BevNodePrecondition=null, falseClear:Boolean=false, loop:Boolean=true, disableTime:int=0)
		{
			super(parentNode, nodePrecondition, disableTime);
			_falseClear = falseClear;
			_loop = loop;
			mNextSelectIndex = 0;
		}
		
		override protected function doEvaluate(inputParam:BevNodeInputParam):Boolean {
			var result:Boolean;
			var childNode:BevNode;
			_currentSelectIndex = mNextSelectIndex;
			mNextSelectIndex++;
			if (checkIndex(_currentSelectIndex) == true) {
				childNode = mChildNodeList[_currentSelectIndex];
				if (childNode.evaluate(inputParam)) {
					result = true;
				}
			} else {
				mNextSelectIndex = 0;
				if (_loop == false) {
					return false;
				}
			}
			// 错误清除
			if (_falseClear == true) {
				if (result == false) {
					mNextSelectIndex = 0;
				}
			}
			if (checkIndex(mNextSelectIndex) == false){
				mNextSelectIndex = 0;
			}
			return result;
		}

		public function get falseClear():Boolean {
			return _falseClear;
		}

		public function set falseClear(value:Boolean):void {
			_falseClear = value;
		}

		public function get loop():Boolean {
			return _loop;
		}

		public function set loop(value:Boolean):void {
			_loop = value;
		}
		
		override public function clone():BevNode {
			var cloneNode:BevNodeNonePrioritySelector = new BevNodeNonePrioritySelector(mParentNode, mNodePrecondition, _falseClear, _loop, mDisableTime);
			for each (var childNode:BevNode in mChildNodeList) {
				cloneNode.addChildNode(childNode.clone());
			}
			return cloneNode;
		}
	}
}