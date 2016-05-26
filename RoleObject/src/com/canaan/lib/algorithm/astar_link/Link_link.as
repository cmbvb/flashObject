package com.canaan.lib.algorithm.astar_link
{
	public class Link_link
	{
		public var node:Node_link;
		public var cost:Number;
		
		public function Link_link(node:Node_link, cost:Number)
		{
			this.node = node;
			this.cost = cost;
		}
	}
}