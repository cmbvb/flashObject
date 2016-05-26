package com.canaan.lib.algorithm.behaviorTree.operator
{
	import com.canaan.lib.algorithm.behaviorTree.BevNodeInputParam;
	import com.canaan.lib.algorithm.behaviorTree.BevNodePrecondition;
	
	public class BevNodePreconditionOR extends BevNodePrecondition
	{
		protected var mLeftCondition:BevNodePrecondition;								// 操作符左侧条件
		protected var mRighCondition:BevNodePrecondition;								// 操作符右侧条件
		
		public function BevNodePreconditionOR(leftCondition:BevNodePrecondition = null, rightCondition:BevNodePrecondition = null)
		{
			mLeftCondition = leftCondition;
			mRighCondition = rightCondition;
		}
		
		override public function externalCondition(inputParam:BevNodeInputParam):Boolean {
			if (mLeftCondition == null || mRighCondition == null) {
				return false;
			}
			return mLeftCondition.externalCondition(inputParam) || mRighCondition.externalCondition(inputParam);
		}
		
		public function setLeftCondition(condition:BevNodePrecondition):Boolean {
			if (mLeftCondition != null) {
				return false;
			}
			mLeftCondition = condition;
			return true;
		}
		
		public function setRightCondition(condition:BevNodePrecondition):Boolean {
			if (mRighCondition != null) {
				return false;
			}
			mRighCondition = condition;
			return true;
		}
		
		override public function clone():BevNodePrecondition {
			return new BevNodePreconditionOR(mLeftCondition, mRighCondition);
		}
	}
}