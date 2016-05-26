package com.canaan.lib.algorithm.behaviorTree.operatorWrapper
{
	/**
	 * 操作符包装类
	 * @author Administrator
	 * 
	 */	
	public class OperatorWrapper
	{
		protected var _leftCondition:Number;								// 左侧判断条件
		protected var _rightCondition:Number;								// 右侧判断条件
		protected var _operatorName:String;									// 操作符名称
		
		public function OperatorWrapper(leftCondition:Number = 0, rightCondition:Number = 0, operatorName:String = "")
		{
			_leftCondition = leftCondition;
			_rightCondition = rightCondition;
			_operatorName = operatorName;
		}
		
		/**
		 * 计算结果
		 * @return 
		 * 
		 */		
		public function calculationWrapper():Number {
			return 0;
		}
		
		/**
		 * 对比结果
		 * @return 
		 * 
		 */		
		public function comparisonWrapper():Boolean {
			return true;
		}

		public function get leftCondition():Number {
			return _leftCondition;
		}

		public function set leftCondition(value:Number):void {
			_leftCondition = value;
		}

		public function get rightCondition():Number {
			return _rightCondition;
		}

		public function set rightCondition(value:Number):void {
			_rightCondition = value;
		}

		public function get operatorName():String {
			return _operatorName;
		}
		
		public function clone():OperatorWrapper {
			return new OperatorWrapper(_leftCondition, _rightCondition, _operatorName);
		}
	}
}