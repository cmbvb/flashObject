package com.canaan.lib.role.view
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.display.BaseSprite;
	import com.canaan.lib.role.constants.TypeRoleDirection;
	import com.canaan.lib.role.data.ActionVo;
	import com.canaan.lib.role.interfaces.IRenderPart;
	import com.canaan.lib.utils.ArrayUtil;
	import com.canaan.lib.utils.DisplayUtil;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	/**
	 * 显示器抽象类
	 * @author Administrator
	 * 
	 */	
	public class AbstractView extends BaseSprite
	{
		protected var _renderParts:Vector.<IRenderPart>;								// 渲染部件
		protected var _containerParts:BaseSprite;										// 渲染部件容器
		protected var _action:int;														// 动作
		protected var _direction:int;													// 方向
		protected var _loop:Boolean;													// 循环播放
		protected var _onComplete:Method;												// 播放完成回调函数
		
		public function AbstractView()
		{
			super();
			initialize();
		}
		
		protected function initialize():void {
			_renderParts = new Vector.<IRenderPart>();
			_containerParts = new BaseSprite();
			addChild(_containerParts);
		}
		
		/**
		 * 添加一个渲染部件
		 * @param type
		 * @param actionVo
		 * @param partClass
		 * @return
		 * 
		 */			
		public function addRenderPart(type:int = 0, actionVo:ActionVo = null, direction:int = 0, partClass:Class = null):IRenderPart {
			partClass ||= BaseRenderPart;
			var renderPart:IRenderPart;
			var index:int = -1;
//			for (var i:int = 0; i < _renderParts.length; i++) {
//				renderPart = _renderParts[i];
//				if (renderPart.type == type) {
//					index = i;
//					_containerParts.removeChild(renderPart as DisplayObject);
//					renderPart.dispose();
//					break;
//				}
//			}
			renderPart = new partClass() as IRenderPart;
			renderPart.initRenderPart(type, actionVo);
			renderPart.direction = direction;
//			if (renderPart == null) {
//				throw new Error(partClass.toString() + " must implements IRenderPart");
//			}
//			if (!(renderPart is DisplayObject)) {
//				throw new Error(partClass.toString() + " must extends DisplayObject");
//			}
//			if (index != -1) {
//				_renderParts.splice(index, 1, renderPart);
//			} else {
				_renderParts.push(renderPart);
				_renderParts.sort(renderPartSortFunc);
				index = _renderParts.indexOf(renderPart);
//			}
			_containerParts.addChildAt(renderPart as DisplayObject, index);
			return renderPart;
		}
		
		/**
		 * 根据type删除渲染部件
		 * @param type
		 * 
		 */		
		public function removeRenderPart(type:int):void {
			var renderPart:IRenderPart;
			for (var i:int = 0; i < _renderParts.length; i++) {
				renderPart = _renderParts[i];
				if (renderPart.type == type) {
					_renderParts.splice(i, 1);
					_containerParts.removeChild(renderPart as DisplayObject);
					renderPart.dispose();
					renderPart = null;
					break;
				}
			}
		}
		
		/**
		 * 根据实例删除渲染部件
		 * @param renderPart
		 * 
		 */		
		public function removeRenderPartInst(renderPart:IRenderPart):void {
			var index:int = _renderParts.indexOf(renderPart);
			if (index != -1) {
				_renderParts.splice(index, 1);
				_containerParts.removeChild(renderPart as DisplayObject);
				renderPart.dispose();
				renderPart = null;
			}
		}
		
		/**
		 * 删除所有渲染组件
		 * 
		 */		
		public function removeAllRenderParts():void {
			for each (var renderPart:IRenderPart in _renderParts) {
				_containerParts.removeChild(renderPart as DisplayObject);
				renderPart.dispose();
				renderPart = null;
			}
			_renderParts.length = 0;
		}
		
		/**
		 * 根据type获取渲染部件
		 * @param type
		 * @return 
		 * 
		 */		
		public function getRenderPart(type:int = 0):IRenderPart {
			return ArrayUtil.find(_renderParts, "type", type);
		}
		
		/**
		 * 渲染部件排序
		 * @param renderPartA
		 * @param renderPartB
		 * @return 
		 * 
		 */		
		protected function renderPartSortFunc(renderPartA:IRenderPart, renderPartB:IRenderPart):int {
			return renderPartA.depth < renderPartB.depth ? -1 : 1;
		}
		
		/**
		 * 播放动画
		 * @param action
		 * @param direction
		 * @param loop
		 * @param stop
		 * @onComplete
		 * 
		 */		
		public function playAction(action:int, direction:int = -1, loop:Boolean = true, stop:Boolean = false, onComplete:Method = null):void {
			if (direction == -1) {
				direction = _direction || TypeRoleDirection.RIGHT;
			}
			if (_action == action && _direction == direction && stop == false) {
				return;
			}
			_action = action;
			_direction = direction;
			_loop = loop;
			_onComplete = onComplete;
			playActionInner();
		}
		
		protected function playActionInner():void {
			var renderPart:IRenderPart;
			for (var i:int = 0; i < _renderParts.length; i++) {
				renderPart = _renderParts[i];
				renderPart.playAction(_action, _direction);
			}
		}
		
		/**
		 * 碰撞检测
		 * @param point
		 * @return 
		 * 
		 */		
		public function getIntersect(point:Point):Boolean {
			return DisplayUtil.getIntersect(_containerParts, point.x, point.y);
		}
		
		public function get action():int {
			return _action;
		}
		
		public function get direction():int {
			return _direction;
		}
		
		public function get containerParts():BaseSprite {
			return _containerParts;
		}
		
		override public function dispose():void {
			removeAllRenderParts();
			super.dispose();
		}
	}
}