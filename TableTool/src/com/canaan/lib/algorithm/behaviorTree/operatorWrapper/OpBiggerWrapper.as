package com.canaan.lib.algorithm.behaviorTree.operatorWrapper
{
	/**
	 * 大于操作
	 * @author Administrator
	 * 
	 */	
	public class OpBiggerWrapper extends OperatorWrapper
	{
		public function OpBiggerWrapper(leftCondition:Number=0, rightCondition:Number=0, operatorName:String="")
		{
			super(leftCondition, rightCondition, operatorName);
		}
		
		override public function comparisonWrapper():Boolean {
			return _leftCondition > _rightCondition;
		}
		
		override public function clone():OperatorWrapper {
			return new OpBiggerWrapper(_leftCondition, _rightCondition, _operatorName);
		}
	}
}