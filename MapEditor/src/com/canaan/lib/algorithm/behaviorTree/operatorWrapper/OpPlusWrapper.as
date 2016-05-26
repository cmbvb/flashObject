package com.canaan.lib.algorithm.behaviorTree.operatorWrapper
{
	/**
	 * 加操作
	 * @author Administrator
	 * 
	 */	
	public class OpPlusWrapper extends OperatorWrapper
	{
		public function OpPlusWrapper(leftCondition:Number=0, rightCondition:Number=0, operatorName:String="")
		{
			super(leftCondition, rightCondition, operatorName);
		}
		
		override public function calculationWrapper():Number {
			return _leftCondition + _rightCondition;
		}
		
		override public function clone():OperatorWrapper {
			return new OpPlusWrapper(_leftCondition, _rightCondition, _operatorName);
		}
	}
}