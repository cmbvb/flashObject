package com.canaan.lib.algorithm.behaviorTree.operatorWrapper
{
	/**
	 * 小于操作
	 * @author Administrator
	 * 
	 */	
	public class OpLessWrapper extends OperatorWrapper
	{
		public function OpLessWrapper(leftCondition:Number=0, rightCondition:Number=0, operatorName:String="")
		{
			super(leftCondition, rightCondition, operatorName);
		}
		
		override public function comparisonWrapper():Boolean {
			return _leftCondition < _rightCondition;
		}
		
		override public function clone():OperatorWrapper {
			return new OpLessWrapper(_leftCondition, _rightCondition, _operatorName);
		}
	}
}