package com.canaan.lib.algorithm.astar
{
	public class Node
	{
		public var x:int;									// 节点x索引
		public var y:int;									// 节点y索引
		public var f:Number;								// 总代价
		public var g:Number;								// 已付出代价
		public var h:Number;								// 剩余代价
		public var walkable:Boolean;						// 是否可通过
		public var parent:Node;								// 父节点
//		public var costMultiplier:Number = 1.0;				// 节点代价因子
		public var version:int = 1;
		public var links:Vector.<Link>;
		
		public function Node(x:int, y:int, walkable:Boolean = true)
		{
			this.x = x;
			this.y = y;
			this.walkable = walkable;
		}
	}
}