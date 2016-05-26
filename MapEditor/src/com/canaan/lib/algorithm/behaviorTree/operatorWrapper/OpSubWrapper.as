package com.canaan.lib.algorithm.behaviorTree.operatorWrapper
{
	/**
	 * 减操作
	 * @author Administrator
	 * 
	 */	
	public class OpSubWrapper extends OperatorWrapper
	{
		public function OpSubWrapper(leftCondition:Number=0, rightCondition:Number=0, operatorName:String="")
		{
			super(leftCondition, rightCondition, operatorName);
		}
		
		override public function calculationWrapper():Number {
			return _leftCondition - _rightCondition;
		}
		
		override public function clone():OperatorWrapper {
			return new OpSubWrapper(_leftCondition, _rightCondition, _operatorName);
		}
	}
}