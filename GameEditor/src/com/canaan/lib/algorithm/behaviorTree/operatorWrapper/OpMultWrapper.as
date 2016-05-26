package com.canaan.lib.algorithm.behaviorTree.operatorWrapper
{
	/**
	 * 乘操作
	 * @author Administrator
	 * 
	 */	
	public class OpMultWrapper extends OperatorWrapper
	{
		public function OpMultWrapper(leftCondition:Number=0, rightCondition:Number=0, operatorName:String="")
		{
			super(leftCondition, rightCondition, operatorName);
		}
		
		override public function calculationWrapper():Number {
			return _leftCondition * _rightCondition;
		}
		
		override public function clone():OperatorWrapper {
			return new OpMultWrapper(_leftCondition, _rightCondition, _operatorName);
		}
	}
}