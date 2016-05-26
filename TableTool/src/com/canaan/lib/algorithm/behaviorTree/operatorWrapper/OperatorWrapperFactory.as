package com.canaan.lib.algorithm.behaviorTree.operatorWrapper
{
	/**
	 * 操作符创建工厂类
	 * @author Administrator
	 * 
	 */	
	public class OperatorWrapperFactory
	{
		/**
		 * 创建操作符 
		 * @param operatorName
		 * @param leftCondition
		 * @param rightCondition
		 * @return 
		 * 
		 */		
		public static function createOperatorWrapper(operatorName:String = "", leftCondition:Number = 0, rightCondition:Number = 0):OperatorWrapper {
			switch (operatorName) {
				case "OpBiggerWrapper":
					return new OpBiggerWrapper(leftCondition, rightCondition, operatorName);
				case "OpLessWrapper":
					return new OpLessWrapper(leftCondition, rightCondition, operatorName);
				case "OpEqualWrapper":
					return new OpEqualWrapper(leftCondition, rightCondition, operatorName);
				case "OpPlusWrapper":
					return new OpPlusWrapper(leftCondition, rightCondition, operatorName);
				case "OpSubWrapper":
					return new OpSubWrapper(leftCondition, rightCondition, operatorName);
				case "OpMultWrapper":
					return new OpMultWrapper(leftCondition, rightCondition, operatorName);
				case "OpDivWrapper":
					return new OpDivWrapper(leftCondition, rightCondition, operatorName);
			}
			return new OperatorWrapper();
		}
	}
}