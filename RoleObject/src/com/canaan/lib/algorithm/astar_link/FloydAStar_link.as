package com.canaan.lib.algorithm.astar_link
{
	import com.canaan.lib.debug.Log;
	
	import flash.geom.Point;
	import flash.utils.getTimer;

	public class FloydAStar_link
	{
		private var _open:BinaryHeap;					// 待考察表
		private var _grid:Grid_link;							// 网格
		private var _startNode:Node_link;					// 开始节点
		private var _endNode:Node_link;						// 终点节点
		private var _path:Vector.<Node_link>;				// 路径（节点列表）
		private var _floydPath:Vector.<Node_link>;			// 弗洛伊德路径
		private var _heuristic:Function = diagonal;		// 估价方法(对角线估价法)
		//private var _heuristic:Function = manhattan;	// 估价方法(曼哈顿估价法)
		//private var _heuristic:Function = euclidian;	// 估价方法(几何估价法)
		private var currentVersion:int = 1;
		
		public function FloydAStar_link(type:int = 0)
		{
			_grid = new Grid_link(type);
		}
		
		public function initializeGrid(gridData:Array):void {
			_grid.initialize(gridData);
		}
		
		public function find(startX:int, startY:int, endX:int, endY:int):Vector.<Node_link> {
			var time:int = getTimer();
			_grid.setStartNode(startX, startY);
			// 判断目标点是否可移动
			if (!_grid.getWalkable(endX, endY)) {
				// 寻找目标点附近最近的可移动点
				var node:Node_link = _grid.findWalkabledNode(startX, startY, endX, endY);
				if (node == null) {
					return null;
				} else {
					endX = node.x;
					endY = node.y;
				}
			}
			var result:Vector.<Node_link>;
			_grid.setEndNode(endX, endY);
			if (findPath()) {
				floyd();
				Log.getInstance().info("AStar find path time used: " + (getTimer() - time) + "ms");
				result = _floydPath;
			} else {
				Log.getInstance().info("AStar could not find the path.");
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
			var node:Node_link = _startNode;
			node.version = currentVersion;
			var test:Node_link;
			while (node != _endNode) {
				var linkLength:int = node.links.length;
				for (var i:int = 0; i < linkLength; i++) {
					test = node.links[i].node;
					var cost:Number = node.links[i].cost;
					var g:Number = node.g + cost;
					var h:Number = _heuristic(test);
					var f:Number = g + h;
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
				if (_open.a.length == 1) {
					return false;
				}
				node = _open.pop() as Node_link;
			}
			buildPath();
			return true;
		}
		
		/**
		 * 创建路径
		 */
		private function buildPath():void {
			var node:Node_link = _endNode;
			// 向路径中加入终点
			_path = new <Node_link>[node];
			// 循环加入所有父节点
			while (node != _startNode) {
				node = node.parent;
				_path.unshift(node);
			}
		}
		
		/**
		 * 判断指定节点是否存在于待考察点集合中
		 */
		private function isOpen(node:Node_link):Boolean {
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
		private function manhattan(node:Node_link):Number {
			return Math.abs(node.x - _endNode.x) * Grid_link.straightCost
				+ Math.abs(node.y + _endNode.y) * Grid_link.straightCost;
		}
		
		/**
		 * 几何估价法(Euclidian heuristic)
		 * 计算出两点之间的直线距离，本质公式为勾股定理A²+B²=C²。
		 */
		private function euclidian(node:Node_link):Number {
			var dx:Number = node.x - _endNode.x;
			var dy:Number = node.y - _endNode.y;
			return Math.sqrt(dx * dx + dy * dy) * Grid_link.straightCost;
		}
		
		/**
		 * 角线估价法(Diagonal heuristic)
		 * 三个估价方法里面最精确的，如果没有障碍，它将返回实际的消耗。
		 */
		private function diagonal(node:Node_link):Number {
			var dx:Number = Math.abs(node.x - _endNode.x);
			var dy:Number = Math.abs(node.y - _endNode.y);
			var diag:Number = Math.min(dx, dy);
			var straight:Number = dx + dy;
			return Grid_link.diagCost * diag + Grid_link.straightCost * (straight - 2 * diag);
		}
		
		/**
		 * 返回路径
		 */
		public function get path():Vector.<Node_link> {
			return _path;
		}
		
		/**
		 * floyd插点优化路径 
		 * 
		 */		
		public function floyd():void {
			if (path == null) {
				return;
			}
			_floydPath = path.concat();
			var len:int = _floydPath.length;
			if (len > 2) {
				var vector:Node_link = new Node_link(0, 0);
				var tempVector:Node_link = new Node_link(0, 0);
				floydVector(vector, _floydPath[len - 1], _floydPath[len - 2]);
				for (var i:int = _floydPath.length - 3; i >= 0; i--) {
					floydVector(tempVector, _floydPath[i + 1], _floydPath[i]);
					if (vector.x == tempVector.x && vector.y == tempVector.y) {
						_floydPath.splice(i + 1, 1);
					} else {
						vector.x = tempVector.x;
						vector.y = tempVector.y;
					}
				}
			}
			
			len = _floydPath.length;
			for (i = len - 1; i >= 0; i--) {
				for (var j:int = 0; j <= i - 2; j++) {
					if (floydCrossAble(_floydPath[i], _floydPath[j])) {
						for (var k:int = i - 1; k > j; k--) {
							_floydPath.splice(k, 1);
						}
						i = j;
						len = _floydPath.length;
						break;
					}
				}
			}
		}
		
		private function floydCrossAble(n1:Node_link, n2:Node_link):Boolean {
			var ps:Vector.<Point> = bresenhamNodes(new Point(n1.x, n1.y), new Point(n2.x, n2.y));
			for (var i:int = ps.length - 2; i > 0; i--) {
				if (ps[i].x >= 0 && ps[i].y >= 0 && ps[i].x < _grid.numCols && ps[i].y < _grid.numRows && !_grid.getNode(ps[i].x, ps[i].y).walkable) {
					return false;
				}
			}
			return true;
		}
		
		private function bresenhamNodes(p1:Point, p2:Point):Vector.<Point> {
			var steep:Boolean = Math.abs(p2.y - p1.y) > Math.abs(p2.x - p1.x);
			if (steep) {
				var temp:int = p1.x;
				p1.x = p1.y;
				p1.y = temp;
				temp = p2.x;
				p2.x = p2.y;
				p2.y = temp;
			}
			var stepX:int = p2.x > p1.x ? 1 :(p2.x < p1.x ? -1 : 0);
			var deltay:Number = (p2.y - p1.y) / Math.abs(p2.x - p1.x);
			var ret:Vector.<Point> = new Vector.<Point>();
			var nowX:Number = p1.x + stepX;
			var nowY:Number = p1.y + deltay;
			if (steep) {
				ret.push(new Point(p1.y, p1.x));
			} else {
				ret.push(new Point(p1.x, p1.y));
			}
			
			if (Math.abs(p1.x - p2.x) == Math.abs(p1.y - p2.y)) {
				if (p1.x < p2.x && p1.y < p2.y) {
					ret.push(new Point(p1.x, p1.y + 1), new Point(p2.x, p2.y - 1));
				}
				else if (p1.x > p2.x && p1.y > p2.y) {
					ret.push(new Point(p1.x, p1.y - 1), new Point(p2.x, p2.y + 1));
				}
				else if (p1.x < p2.x && p1.y > p2.y) {
					ret.push(new Point(p1.x, p1.y - 1), new Point(p2.x, p2.y + 1));
				}
				else if (p1.x > p2.x && p1.y < p2.y) {
					ret.push(new Point(p1.x, p1.y + 1), new Point(p2.x, p2.y - 1));
				}
			}
			while (nowX != p2.x) {
				var fy:int = Math.floor(nowY)
				var cy:int = Math.ceil(nowY);
				if (steep) {
					ret.push(new Point(fy, nowX));
				} else {
					ret.push(new Point(nowX, fy));
				}
				if (fy != cy) {
					if (steep) {
						ret.push(new Point(cy, nowX));
					} else {
						ret.push(new Point(nowX, cy));
					}
				} else if (deltay != 0) {
					if (steep) {
						ret.push(new Point(cy + 1, nowX));
						ret.push(new Point(cy - 1, nowX));
					} else {
						ret.push(new Point(nowX, cy + 1));
						ret.push(new Point(nowX, cy - 1));
					}
				}
				nowX += stepX;
				nowY += deltay;
			}
			
			if (steep) {
				ret.push(new Point(p2.y, p2.x));
			} else {
				ret.push(new Point(p2.x, p2.y));
			}
			return ret;
		}
		
		private function floydVector(target:Node_link, n1:Node_link, n2:Node_link):void {
			target.x = n1.x - n2.x;
			target.y = n1.y - n2.y;
		}
		
		public function get floydPath():Vector.<Node_link> {
			return _floydPath;
		}
		
		public function get grid():Grid_link {
			return _grid;
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