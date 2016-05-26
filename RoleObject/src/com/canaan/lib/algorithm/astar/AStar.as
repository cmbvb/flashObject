package com.canaan.lib.algorithm.astar
{
	public class AStar
	{
		private var _open:BinaryHeap;
		private var _grid:Grid;											// 网格
		private var _startNode:Node;									// 开始节点
		private var _endNode:Node;										// 终点节点
		private var _path:Vector.<Node>;								// 路径（节点列表）
		//private var _heuristic:Function = diagonal;					// 估价方法(对角线估价法)
		//private var _heuristic:Function = manhattan;					// 估价方法(曼哈顿估价法)
		private var _heuristic:Function = euclidian;					// 估价方法(几何估价法)
		private var currentVersion:int = 1;
		
		public function AStar()
		{
		}
		
		public function find(startX:int, startY:int, endX:int, endY:int):Vector.<Node> {
			if (startX < 0 || startY < 0 || endX >= _grid.numCols || endY >= _grid.numRows) {
				return null;
			}
//			var time:int = getTimer();
			_grid.setStartNode(startX, startY);
			// 判断目标点是否可移动
			if (!_grid.getWalkable(endX, endY)) {
				// 寻找目标点附近最近的可移动点
				var node:Node = _grid.findWalkabledNode(startX, startY, endX, endY);
				if (node == null) {
					return null;
				} else {
					endX = node.x;
					endY = node.y;
				}
			}
			var result:Vector.<Node>;
			_grid.setEndNode(endX, endY);
			if (findPath()) {
//				Log.getInstance().info("AStar find path time used: " + (getTimer() - time) + "ms");
				result = _path;
			} else {
//				Log.getInstance().info("AStar could not find the path:" + (getTimer() - time) + "ms");
			}
			return result;
		}
		
		private function justMin(x:Object, y:Object):Boolean {
			return x.f < y.f;
		}
		
		/**
		 * 寻路方法
		 * 方法创建了一个空的待考察表/已考察表，然后从_grid中获取起点，终点节点值。
		 * 在计算出起点的代价后，跳到search方法开始循环，直到终点节点，返回路径。
		 * 因为g值的定义是从起点到当前点的消耗，这时起点就是当前点，让当前节点的g值为0。
		 */
		public function findPath():Boolean {
			currentVersion++;
			_open = new BinaryHeap(justMin);
			_startNode = _grid.startNode;
			_endNode = _grid.endNode;
			_startNode.g = 0;
			_startNode.h = _heuristic(_startNode);
			_startNode.f = _startNode.g + _startNode.h;
			return search();
		}
		
		/**
		 * 挨个计算起点节点一直到终点节点，计算出最佳路径。
		 */
		public function search():Boolean {
			if (!_endNode.walkable) {
				return false;
			}
			// 设置当前节点为起始点
			var node:Node = _startNode;
			node.version = currentVersion;
			var test:Node;
			while (node != _endNode) {
				// 首先找到当前节点的x，y值（不是实际意义的xy坐标，是节点在网格中的行列数），然后分别从x-1到x+1，y-1到y+1.
				// 通过Math.min和Math.max确保了检查的节点永远在网格里面。
				var startX:int = node.x - 1;
				if (startX < 0) {
					startX = 0;
				}
				var endX:int = node.x + 1;
				if (endX > _grid.maxCol) {
					endX = _grid.maxCol;
				}
				var startY:int = node.y - 1;
				if (startY < 0) {
					startY = 0;
				}
				var endY:int = node.y + 1;
				if (endY > _grid.maxRow) {
					endY = _grid.maxRow;
				}
				// 遍历起始点周围的8个点
				for (var i:int = startX; i <= endX; i++) {
					for (var j:int = startY; j <= endY; j++) {
						test = _grid.getNode(i, j);
						// 对于每一个节点来说，如果它是当前节点或不可通过的，或者临接节点都不能通过，那么就跳过该节点就忽略它，直接跳到下一个
						if (test == node || !test.walkable) {
							continue;
						}
						var g:Number = node.g + 1;
						var h:Number = _heuristic(test);
						var f:Number = g + h;
						// 如果一个节点在待考察表/已考察表里，因为它已经被考察过了，所以我们不需要再考察。
						// 不过这次计算出的结果有可能小于你之前计算的结果。
						// 所以，就算一个节点在待考察表/已考察表里面，最好还是比较一下当前值和之前值之间的大小。
						// 具体做法是比较测试节点的总代价与以前计算出来的总代价。
						// 如果以前的大，我们就找到了更好的节点，我们就需要重新给测试点的f，g，h赋值。
						// 同时，我们还要把测试点的父节点设为当前点。这就要我们向后追溯。
						if (test.version == currentVersion) {
							if (test.f > f) {
								test.f = f;
								test.g = g;
								test.h = h;
								test.parent = node;
							}
						} else {
							test.f = f;
							test.g = g;
							test.h = h;
							test.parent = node;
							_open.ins(test);
							test.version = currentVersion;
						}
					}
				}
				
				if (_open.a.length == 1) {
					return false;
				}
				node = _open.pop() as Node;
			}
			buildPath();
			return true;
		}
		
		/**
		 * 创建路径
		 */
		private function buildPath():void {
			var node:Node = _endNode;
			// 向路径中加入终点
			_path = new <Node>[node];
			// 循环加入所有父节点
			while (node != _startNode) {
				node = node.parent;
				_path.unshift(node);
			}
		}
		
		/**
		 * 判断指定节点是否存在于待考察点集合中
		 */
		private function isOpen(node:Node):Boolean {
			for (var i:int = 0; i < _open.a.length; i++) {
				if (_open.a[i] == node) {
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 曼哈顿估价法(Manhattan heuristic)
		 * 它忽略所有的对角移动，只添加起点节点和终点节点之间的行、列数目。
		 */
		private function manhattan(node:Node):Number {
			return Math.abs(node.x - _endNode.x) + Math.abs(node.y + _endNode.y);
		}
		
		/**
		 * 几何估价法(Euclidian heuristic)
		 * 计算出两点之间的直线距离，本质公式为勾股定理A²+B²=C²。
		 */
		private function euclidian(node:Node):Number {
			var dx:Number = node.x - _endNode.x;
			var dy:Number = node.y - _endNode.y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		/**
		 * 角线估价法(Diagonal heuristic)
		 * 三个估价方法里面最精确的，如果没有障碍，它将返回实际的消耗。
		 */
		private function diagonal(node:Node):Number {
			var dx:Number = Math.abs(node.x - _endNode.x);
			var dy:Number = Math.abs(node.y - _endNode.y);
			var diag:Number = Math.min(dx, dy);
			var straight:Number = dx + dy;
			return Grid.diagCost * diag + (straight - 2 * diag);
		}
		
		/**
		 * 返回路径
		 */
		public function get path():Vector.<Node> {
			return _path;
		}
		
		/**
		 * 地图网格
		 * @return 
		 * 
		 */		
		public function get grid():Grid {
			return _grid;
		}
		
		public function set grid(value:Grid):void {
			_grid = value;
		}
	}
}

class BinaryHeap
{
	public var a:Array = [];
	public var justMinFun:Function = function(x:Object, y:Object):Boolean {
		return x < y;
	};
	
	public function BinaryHeap(justMinFun:Function = null)
	{
		a.push(-1);
		if (justMinFun != null) {
			this.justMinFun = justMinFun;
		}
	}
	
	public function ins(value:Object):void {
		var p:int = a.length;
		a[p] = value;
		var pp:int = p >> 1;
		while (p > 1 && justMinFun(a[p], a[pp])) {
			var temp:Object = a[p];
			a[p] = a[pp];
			a[pp] = temp;
			p = pp;
			pp = p >> 1;
		}
	}
	
	public function pop():Object {
		var min:Object = a[1];
		a[1] = a[a.length - 1];
		a.pop();
		var p:int = 1;
		var l:int = a.length;
		var sp1:int = p << 1;
		var sp2:int = sp1 + 1;
		while (sp1 < l) {
			if (sp2 < l) {
				var minp:int = justMinFun(a[sp2], a[sp1]) ? sp2 : sp1;
			} else {
				minp = sp1;
			}
			if (justMinFun(a[minp], a[p])) {
				var temp:Object = a[p];
				a[p] = a[minp];
				a[minp] = temp;
				p = minp;
				sp1 = p << 1;
				sp2 = sp1 + 1;
			} else {
				break;
			}
		}
		return min;
	}
}