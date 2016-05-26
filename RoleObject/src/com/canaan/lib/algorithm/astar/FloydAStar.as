package com.canaan.lib.algorithm.astar
{
	import flash.geom.Point;
	
	public class FloydAStar
	{
		private var _open:BinaryHeap;									// 待考察表
		private var _closed:Vector.<Node>;								// 已考察表
		private var _grid:Grid;											// 网格
		private var _startNode:Node;									// 开始节点
		private var _endNode:Node;										// 终点节点
		private var _path:Vector.<Node>;								// 路径（节点列表）
		private var _floydPath:Vector.<Node>;							// 弗洛伊德路径
		private var _heuristic:Function = diagonal;						// 估价方法(对角线估价法)
		//private var _heuristic:Function = manhattan;					// 估价方法(曼哈顿估价法)
		//private var _heuristic:Function = euclidian;					// 估价方法(几何估价法)
		private var _straightCost:Number = 1.0;							// 水平距离
		private var _diagCost:Number = Math.SQRT2;						// 对角线距离
		
		public function FloydAStar()
		{
			
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
		public function findPath(grid:Grid):Boolean {
			_grid = grid;
			_open = new BinaryHeap(justMin);
			_closed = new Vector.<Point>();
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
			while (node != _endNode) {
				// 首先找到当前节点的x，y值（不是实际意义的xy坐标，是节点在网格中的行列数），
				// 然后分别从x-1到x+1，y-1到y+1.
				// 通过Math.min和Math.max确保了检查的节点永远在网格里面。
				var startX:int = Math.max(0, node.x - 1);
				var endX:int = Math.min(_grid.numCols - 1, node.x + 1);
				var startY:int = Math.max(0, node.y - 1);
				var endY:int = Math.min(_grid.numRows - 1, node.y + 1);
				// 遍历起始点周围的8个点
				for (var i:int = startX; i <= endX; i++) {
					for (var j:int = startY; j <= endY; j++) {
						var test:Node = _grid.getNode(i, j);
						// 对于每一个节点来说，如果它是当前节点或不可通过的，或者临接节点都不能通过，
						// 那么就跳过该节点就忽略它，直接跳到下一个
						if (test == node || !test.walkable || (!_grid.getNode(node.x, test.y).walkable && !_grid.getNode(test.x, node.y).walkable)) {
							continue;
						}
						var cost:Number = _straightCost;
						// 如果是对角点则设置代价为_diagCost;
						if (!((node.x == test.x) || (node.y == test.y))) {
							cost = _diagCost;
						}
						var g:Number = node.g + cost * test.costMultiplier;
						var h:Number = _heuristic(test);
						var f:Number = g + h;
						// 如果一个节点在待考察表/已考察表里，因为它已经被考察过了，所以我们不需要再考察。
						// 不过这次计算出的结果有可能小于你之前计算的结果。
						// 所以，就算一个节点在待考察表/已考察表里面，最好还是比较一下当前值和之前值之间的大小。
						// 具体做法是比较测试节点的总代价与以前计算出来的总代价。
						// 如果以前的大，我们就找到了更好的节点，我们就需要重新给测试点的f，g，h赋值。
						// 同时，我们还要把测试点的父节点设为当前点。这就要我们向后追溯。
						if (isOpen(test) || isClosed(test)) {
							if (test.f > f) {
								test.f = f;
								test.g = g;
								test.h = h;
								test.parent = node;
							}
						}
							// 如果测试节点不再待考察表/已考察表里面，我们只需要赋值给f，g，h和父节点。
							// 然后把测试点加到待考察表，然后是下一个测试点，找出最佳点。
						else {
							test.f = f;
							test.g = g;
							test.h = h;
							test.parent = node;
							_open.ins(test);
						}
					}
				}
				
				// 调试输出_open里都有哪些点
				// for(var o:int = 0; o < _open.length; o++) {
				//       trace(_open[i].toString());
				// }
				
				// 将当前节点放入已考察表
				_closed.push(node);
				// 检查待考察表里面有没有节点。
				if (!_open.a.length) {
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
		 * 判断指定节点是否存在于已考察点集合中
		 */
		private function isClosed(node:Node):Boolean {
			for (var i:int = 0; i < _closed.length; i++) {
				if (_closed[i] == node) {
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
			return Math.abs(node.x - _endNode.x) * _straightCost
				+ Math.abs(node.y + _endNode.y) * _straightCost;
		}
		
		/**
		 * 几何估价法(Euclidian heuristic)
		 * 计算出两点之间的直线距离，本质公式为勾股定理A²+B²=C²。
		 */
		private function euclidian(node:Node):Number {
			var dx:Number = node.x - _endNode.x;
			var dy:Number = node.y - _endNode.y;
			return Math.sqrt(dx * dx + dy * dy) * _straightCost;
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
			return _diagCost * diag + _straightCost * (straight - 2 * diag);
		}
		
		/**
		 * 返回路径
		 */
		public function get path():Vector.<Node> {
			return _path;
		}
		
		/**
		 * 返回以考察点集合
		 */
		public function get open():Vector.<Node> {
			return _open.a;
		}
		
		/**
		 * 返回待考察点几何
		 */
		public function get closed():Vector.<Node> {
			return _closed;
		}
		
		/**
		 * 返回所有被计算过的节点(辅助函数)
		 */
		public function get visited():Vector.<Node> {
			return _closed.concat(_open);
		}
		
		public function floyd():void {
			if (!path) {
				return;
			}
			_floydPath = path.concat();
			var len:int = _floydPath.length;
			if (len > 2) {
				var vector:Node = new Node(0, 0);
				var tempVector:Node = new Node(0, 0);
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
		
		private function floydCrossAble(n1:Node, n2:Node):Boolean {
			var ps:Vector.<Point> = bresenhamNodes(new Point(n1.x, n1.y), new Point(n2.x, n2.y));
			for (var i:int = ps.length - 2; i > 0; i--) {
				if (ps[i].x >= 0 && ps[i].y >= 0&& ps[i].x < _grid.numCols&&ps[i].y < _grid.numRows && !_grid.getNode(ps[i].x, ps[i].y).walkable) {
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
			var ret:Vector.<Point> = Vector.<Point>();
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
		
		private function floydVector(target:Node, n1:Node, n2:Node):void {
			target.x = n1.x - n2.x;
			target.y = n1.y - n2.y;
		}
		
		public function get floydPath():Vector.<Node> {
			return _floydPath;
		}
	}
}
import com.canaan.lib.algorithm.astar.Node;



class BinaryHeap
{
	public var a:Vector.<Node> = new Vector.<Node>();
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