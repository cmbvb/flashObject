package com.canaan.lib.algorithm.behaviorTree
{
	/**
	 * 节点数据
	 * @author Administrator
	 * 
	 */	
	public class BevAnyData
	{
		protected var _anyData:Object;
		
		public function BevAnyData(anyData:Object = null)
		{
			_anyData = anyData;
		}

		public function get anyData():Object {
			return _anyData;
		}

		public function set anyData(value:Object):void {
			_anyData = value;
		}
	}
}