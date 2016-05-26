package com.canaan.lib.algorithm.behaviorTree.operatorWrapper
{
	/**
	 * 等于操作
	 * @author Administrator
	 * 
	 */	
	public class OpEqualWrapper extends OperatorWrapper
	{
		public function OpEqualWrapper(leftCondition:Number=0, rightCondition:Number=0, operatorName:String="")
		{
			super(leftCondition, rightCondition, operatorName);
		}
		
		override public function comparisonWrapper():Boolean {
			return _leftCondition == _rightCondition;
		}
		
		override public function clone():OperatorWrapper {
			return new OpEqualWrapper(_leftCondition, _rightCondition, _operatorName);
		}
	}
}