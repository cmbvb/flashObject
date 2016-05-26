package com.canaan.lib.algorithm.astar
{
	public class Node
	{
		private static var nodePool:Vector.<Node> = new Vector.<Node>();
		
		public var x:int;												// 节点x索引
		public var y:int;												// 节点y索引
		public var f:Number;											// 总代价
		public var g:Number;											// 已付出代价
		public var h:Number;											// 剩余代价
		public var initWalkable:Boolean;								// 初始化是否可通过
		public var walkable:Boolean;									// 是否可通过
		public var parent:Node;											// 父节点
		public var costMultiplier:Number = 1.0;							// 节点代价因子
		public var version:int = 1;
		public var key:String;
		
		public function Node(x:int = 0, y:int = 0, walkable:Boolean = true)
		{
			this.x = x;
			this.y = y;
			this.initWalkable = walkable;
			this.walkable = walkable;
			this.key = x + "_" + y;
		}
		
		public function resetWalkable():void {
			walkable = initWalkable;
		}
		
		public static function fromPool(x:int = 0, y:int = 0, walkable:Boolean = true):Node {
			if (nodePool.length > 0) {
				var node:Node = nodePool.pop();
				node.x = x;
				node.y = y;
				node.initWalkable = walkable;
				node.walkable = walkable;
				node.key = x + "_" + y;
				return node;
			} else {
				return new Node(x, y, walkable);
			}
		}
		
		public static function toPool(node:Node):void {
			nodePool.push(node);
		}
		
		public static function clearPool():void {
			nodePool.length = 0;
		}
	}
}