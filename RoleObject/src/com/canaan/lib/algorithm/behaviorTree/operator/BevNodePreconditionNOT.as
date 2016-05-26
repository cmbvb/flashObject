package com.canaan.lib.algorithm.behaviorTree.operator
{
	import com.canaan.lib.algorithm.behaviorTree.BevNodeInputParam;
	import com.canaan.lib.algorithm.behaviorTree.BevNodePrecondition;
	
	public class BevNodePreconditionNOT extends BevNodePrecondition
	{
		protected var mLeftCondition:BevNodePrecondition;								// 操作符左侧条件
		
		public function BevNodePreconditionNOT(leftCondition:BevNodePrecondition = null)
		{
			mLeftCondition = leftCondition;
		}
		
		override public function externalCondition(inputParam:BevNodeInputParam):Boolean {
			if (mLeftCondition == null) {
				return false;
			}
			return !mLeftCondition.externalCondition(inputParam);
		}
		
		public function setLeftCondition(condition:BevNodePrecondition):void {
			mLeftCondition = condition;
		}
		
		override public function clone():BevNodePrecondition {
			return new BevNodePreconditionNOT(mLeftCondition);
		}
	}
}