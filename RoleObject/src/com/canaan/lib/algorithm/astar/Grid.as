package com.canaan.lib.algorithm.astar
{
	import com.canaan.lib.utils.MathUtil;

	public class Grid
	{
		public static const TYPE_8_DIRECTION:int = 0;		// 八方向
		public static const TYPE_4_DIRECTION:int = 1;		// 四方向
		public static const WALKABLE_NUM:int = 0;			// 可移动ID
		public static const UNWALKABLE_NUM:int = 1;			// 不可移动ID
		
		public static var straightCost:Number = 1.0;		// 水平距离
		public static var diagCost:Number = Math.SQRT2;		// 对角线距离
		public static var allowDiagMove:Boolean = false;	// 允许对角线移动
		public static var findWalkAbleMaxDist:int = 20;		// 查找最大可寻路距离
		
		private static var nodePool:Vector.<Node> = new Vector.<Node>();
		
		private var _startNode:Node;
		private var _endNode:Node;
		private var _nodes:Vector.<Vector.<Node>>;
		private var _numCols:int;
		private var _numRows:int;
		private var _maxCol:int;
		private var _maxRow:int;
		
		private var _type:int;
		
		public function Grid(type:int)
		{
			_type = type;
		}
		
		public function initialize(gridData:Array):void {
			_numRows = gridData.length;
			_numCols = gridData[0].length;
			_maxRow = _numRows - 1;
			_maxCol = _numCols - 1;
			
			initializeNodes();
			_nodes = new Vector.<Vector.<Node>>();
			for (var i:int = 0; i < _numCols; i++) {
				_nodes[i] = new Vector.<Node>();
				for (var j:int = 0; j < _numRows; j++) {
					_nodes[i][j] = Node.fromPool(i, j, gridData[j][i] != UNWALKABLE_NUM || gridData[j][i] == WALKABLE_NUM);
//					_nodes[i][j] = new Node(i, j, gridData[j][i] != UNWALKABLE_NUM || gridData[j][i] == WALKABLE_NUM);
				}
			}
		}
		
		private function initializeNodes():void {
			for each (var rowNodes:Vector.<Node> in _nodes) {
				for each (var node:Node in rowNodes) {
					Node.toPool(node);
				}
			}
		}
		
		public function findWalkabledNode(startX:int, startY:int, endX:int, endY:int):Node {
			var distX:int = Math.abs(endX - startX);
			var distY:int = Math.abs(endY - startY);
			var node:Node;
			var testNode:Node;
			var dist:int = 1;
			var sX:int;
			var sY:int;
			var eX:int;
			var eY:int;
			while (dist <= findWalkAbleMaxDist) {
				sX = endX - dist;
				sY = endY - dist;
				eX = endX + dist;
				eY = endY + dist;
				for (var i:int = sX; i <= eX; i++) {
					for (var j:int = sY; j <= eY; j++) {
						// 超出测试点范围
						if (i < 0 || j < 0 || i >= _numCols || j >= _numRows || i - sX > distX || j - sY > distY) {
							continue;
						}
						testNode = getNode(i, j);
						// 当测试点不为空（在整个地图范围内）并且node为空（首次测试）或testNode点到起始点的距离小于node点到起始点的距离
						if (testNode != null && testNode.walkable && (node == null || MathUtil.getDistance(i, j, startX, startY) < MathUtil.getDistance(node.x, node.y, startX, startY))) {
							node = testNode;
						}
					}
				}
				if (node != null) {
					return node;
				}
				dist++;
			}
			return node;
		}
		
		/**
		 * Returns the end node.
		 */
		public function get endNode():Node {
			return _endNode;
		}
		
		/**
		 * Returns the number of columns in the grid.
		 */
		public function get numCols():int {
			return _numCols;
		}
		
		/**
		 * Returns the number of rows in the grid.
		 */
		public function get numRows():int {
			return _numRows;
		}
		
		/**
		 * Returns the start node.
		 */
		public function get startNode():Node {
			return _startNode;
		}
		
		/**
		 * Returns the node at the given coords.
		 * @param x The x coord.
		 * @param y The y coord.
		 */
		public function getNode(x:int, y:int):Node {
			return _nodes[x][y];
		}
		
		/**
		 * Sets the node at the given coords as the end node.
		 * @param x The x coord.
		 * @param y The y coord.
		 */
		public function setEndNode(x:int, y:int):void {
			_endNode = _nodes[x][y];
		}
		
		/**
		 * Sets the node at the given coords as the start node.
		 * @param x The x coord.
		 * @param y The y coord.
		 */
		public function setStartNode(x:int, y:int):void {
			_startNode = _nodes[x][y];
		}
		
		/**
		 * Sets the node at the given coords as walkable or not.
		 * @param x The x coord.
		 * @param y The y coord.
		 */
		public function setWalkable(x:int, y:int, value:Boolean):void {
			_nodes[x][y].walkable = value;
		}
		
		public function getWalkable(x:int, y:int):Boolean {
			return _nodes[x][y].walkable;
		}
		
		public function get maxCol():int {
			return _maxCol;
		}
		
		public function get maxRow():int {
			return _maxRow;
		}
		
		public function get type():int {
			return _type;
		}
	}
}