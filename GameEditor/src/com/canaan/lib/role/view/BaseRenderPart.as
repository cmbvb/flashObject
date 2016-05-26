package com.canaan.lib.role.view
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.display.BitmapDataEx;
	import com.canaan.lib.display.BitmapMovieClip;
	import com.canaan.lib.role.data.ActionVo;
	import com.canaan.lib.role.interfaces.IRenderPart;
	
	public class BaseRenderPart extends BitmapMovieClip implements IRenderPart
	{
		protected var _type:int;
		protected var _action:int;
		protected var _direction:int;
		protected var _callback:Method;
		protected var _actionVo:ActionVo;
		protected var _maxFrameIndex:int;
		
		public function BaseRenderPart()
		{
			super();
		}
		
		public function initRenderPart(type:int = 0, actionVo:ActionVo = null):void {
			_type = type;
			_actionVo = actionVo;
		}
		
		public function setOffset(offsetX:Number = 0, offsetY:Number = 0):void {
			x = offsetX;
			y = offsetY;
		}
		
		public function playAction(action:int, direction:int, replay:Boolean = false, callback:Method = null):void {
			if (_action == action && _direction == direction && replay == false) {
				return;
			}
			_action = action;
			_direction = direction;
			_callback = callback;
			if (_actionVo != null) {
				var vector:Vector.<BitmapDataEx> = _actionVo.getVectorByAction(_action, _direction);
				bitmapDatas = vector;
			}
		}
		
		public function getFrameIndex():int {
			return _index;
		}
		
		public function setFrameIndex(value:int):void {
			if (_maxFrameIndex <= value) {
				if (_callback != null) {
					_callback.apply();
				}
			}
			frame = value;
		}
		
		public function getMaxFrameIndex():int {
			return _maxFrameIndex;
		}
		
		public function setMaxFrameIndex(value:int):void {
			_maxFrameIndex = value;
		}
		
		override protected function animationComplete():void {
			_action = 0;
			super.animationComplete();
		}
		
		public function get action():int {
			return _action;
		}
		
		public function get direction():int {
			return _direction;
		}
		
		public function get actionVo():ActionVo {
			return _actionVo;
		}
		
		public function get type():int {
			return _type;
		}
		
		public function get depth():Number {
			return _type;
		}
	}
}