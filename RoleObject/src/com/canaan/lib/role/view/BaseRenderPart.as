package com.canaan.lib.role.view
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.display.BitmapDataEx;
	import com.canaan.lib.display.BitmapEx;
	import com.canaan.lib.interfaces.IDispose;
	import com.canaan.lib.managers.ResManager;
	import com.canaan.lib.role.data.ActionVo;
	import com.canaan.lib.role.interfaces.IRenderPart;
	import com.canaan.lib.role.managers.ActionManager;
	
	public class BaseRenderPart extends BitmapEx implements IRenderPart, IDispose
	{
		protected var _index:int = -1;
		protected var _maxIndex:int;
		protected var _bitmapDatas:Vector.<BitmapDataEx>;
		
		protected var _type:int;
		protected var _action:int;
		protected var _direction:int;
		protected var _callback:Method;
		protected var _actionVo:ActionVo;
		protected var _maxFrameIndex:int;
		protected var _url:String;
		protected var _loadCallback:Method;
		
		public function BaseRenderPart()
		{
			super();
			_loadCallback = new Method(loadAsyncComplete);
		}
		
		public function get bitmapDatas():Vector.<BitmapDataEx> {
			return _bitmapDatas;
		}
		
		public function set bitmapDatas(value:Vector.<BitmapDataEx>):void {
			_bitmapDatas = value;
			if (_bitmapDatas != null) {
				_maxIndex = _bitmapDatas.length - 1;
				var index:int = Math.min(_maxIndex, Math.max(0, _index));
				bitmapDataEx = _bitmapDatas[index];
			} else {
				_maxIndex = 0;
				bitmapDataEx = null;
			}
		}
		
		public function get index():int {
			return _index;
		}
		
		public function set index(value:int):void {
			if (value < 0) {
				value = 0;
			}
			if (_index != value) {
				_index = value;
				if (_bitmapDatas != null && _maxIndex >= _index) {
					bitmapDataEx = _bitmapDatas[_index];
				}
			}
		}
		
		public function get maxIndex():int {
			return _maxIndex;
		}
		
		public function initRenderPart(type:int = 0, actionVo:ActionVo = null):void {
			_type = type;
			if (_actionVo != null) {
				ActionManager.getInstance().unUseAction(_actionVo);
			}
			_actionVo = actionVo;
			if (_actionVo != null) {
				ActionManager.getInstance().useAction(_actionVo);
			}
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
			} else {
				bitmapDatas = null;
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
			index = value;
		}
		
		public function getMaxFrameIndex():int {
			return _maxFrameIndex;
		}
		
		public function setMaxFrameIndex(value:int):void {
			_maxFrameIndex = value;
		}
		
		public function nextFrame():void {
			if (_index == _maxFrameIndex) {
				index = 0;
			} else {
				index++;
			}
		}
		
		public function dispose():void {
			if (_actionVo != null) {
				ActionManager.getInstance().unUseAction(_actionVo);
				_actionVo = null;
			}
			_index = -1;
			_maxIndex = 0;
			_bitmapDatas = null;
		}
		
		public function get action():int {
			return _action;
		}
		
		public function set action(value:int):void {
			_action = value;
		}
		
		public function get direction():int {
			return _direction;
		}
		
		public function set direction(value:int):void {
			_direction = value;
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
		
		public function loadAsync(url:String, priority:int):void {
			stopLoad();
			_url = url;
			if (ResManager.getInstance().hasContent(url)) {
				loadAsyncComplete();
			} else {
				ResManager.getInstance().load(url, url, url, _loadCallback, null, false, priority);
			}
		}
		
		public function stopLoad():void {
			if (_url) {
				ResManager.getInstance().removeResItemCompleteHandler(_url, _loadCallback);
				_url = null;
			}
		}
		
		protected function loadAsyncComplete():void {
			var actionVo:ActionVo = ActionManager.getInstance().getAction(_url);
			initRenderPart(_type, actionVo);
			setFrameIndex(_index);
			playAction(_action, _direction, true);
			_url = null;
		}
		
		public function reset():void {
			if (_actionVo != null) {
				ActionManager.getInstance().unUseAction(_actionVo);
			}
			stopLoad();
			bitmapData = null;
			_bitmapDataEx = null;
			_bitmapDatas = null;
			_index = -1;
			_type = 0;
			_action = 0;
			_direction = 0;
			_callback = null;
			_actionVo = null;
			_maxFrameIndex = 0;
		}
	}
}