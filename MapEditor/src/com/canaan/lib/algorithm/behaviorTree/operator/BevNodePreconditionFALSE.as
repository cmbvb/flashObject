package com.canaan.lib.algorithm.behaviorTree.operator
{
	import com.canaan.lib.algorithm.behaviorTree.BevNodeInputParam;
	import com.canaan.lib.algorithm.behaviorTree.BevNodePrecondition;
	
	public class BevNodePreconditionFALSE extends BevNodePrecondition
	{
		public function BevNodePreconditionFALSE()
		{
			super();
		}
		
		override public function externalCondition(inputParam:BevNodeInputParam):Boolean {
			return false;
		}
		
		override public function clone():BevNodePrecondition {
			return new BevNodePreconditionFALSE();
		}
	}
}