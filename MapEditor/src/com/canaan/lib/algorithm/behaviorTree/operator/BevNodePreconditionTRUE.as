package com.canaan.lib.algorithm.behaviorTree.operator
{
	import com.canaan.lib.algorithm.behaviorTree.BevNodeInputParam;
	import com.canaan.lib.algorithm.behaviorTree.BevNodePrecondition;
	
	public class BevNodePreconditionTRUE extends BevNodePrecondition
	{
		public function BevNodePreconditionTRUE()
		{
			super();
		}
		
		override public function externalCondition(inputParam:BevNodeInputParam):Boolean {
			return true;
		}
		
		override public function clone():BevNodePrecondition {
			return new BevNodePreconditionTRUE();
		}
	}
}