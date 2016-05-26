package com.canaan.lib.algorithm.behaviorTree
{
	/**
	 * 节点前置条件
	 * @author Administrator
	 * 
	 */	
	public class BevNodePrecondition
	{
		protected var _id:String;
		
		public function BevNodePrecondition()
		{
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function set id(value:String):void
		{
			_id = value;
		}
		
		/**
		 * 判断节点外部条件
		 * @param inputParam
		 * @return 
		 * 
		 */		
		public function externalCondition(inputParam:BevNodeInputParam):Boolean {
			if (inputParam == null || inputParam.anyData == null) {
				return false;
			}
			return true;
		}
		
		public function clone():BevNodePrecondition {
			return new BevNodePrecondition();
		}
	}
}