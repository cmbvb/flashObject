package com.canaan.lib.algorithm.behaviorTree.operatorWrapper
{
	/**
	 * 除操作
	 * @author Administrator
	 * 
	 */	
	public class OpDivWrapper extends OperatorWrapper
	{
		public function OpDivWrapper(leftCondition:Number=0, rightCondition:Number=0, operatorName:String="")
		{
			super(leftCondition, rightCondition, operatorName);
		}
		
		override public function calculationWrapper():Number {
			return _leftCondition / _rightCondition;
		}
		
		override public function clone():OperatorWrapper {
			return new OpDivWrapper(_leftCondition, _rightCondition, _operatorName);
		}
	}
}