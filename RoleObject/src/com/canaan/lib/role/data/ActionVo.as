package com.canaan.lib.role.data
{
	import com.canaan.lib.abstract.AbstractVo;
	import com.canaan.lib.display.BitmapDataEx;
	import com.canaan.lib.managers.ResManager;
	import com.canaan.lib.managers.StageManager;
	import com.canaan.lib.utils.StageUtil;
	
	import flash.utils.Dictionary;
	
	public class ActionVo extends AbstractVo
	{
		private var _resId:String;
		private var _id:String;
		private var _interval:int;
		private var _vectors:Dictionary = new Dictionary();
		
		public function ActionVo()
		{
			super();
		}
		
		public function getVectorByAction(action:int, direction:int):Vector.<BitmapDataEx> {
			if (_vectors[action]) {
				return _vectors[action][direction];
			}
			return null;
		}
		
		public function setHeadData(value:Object):void {
			_id = value.id;
			var actions:Object = value.actions;
			var directions:Dictionary;
			var vector:Vector.<BitmapDataEx>;
			var bitmapDataEx:BitmapDataEx;
			var frameIndex:int;
			var lastFrameIndex:int;
			var skin:String;
			for (var action:String in actions) {
				directions = new Dictionary();
				_vectors[action] = directions;
				for (var direction:String in actions[action]) {
					vector = new Vector.<BitmapDataEx>();
					directions[direction] = vector;
					frameIndex = -1;
					lastFrameIndex = -1;
					for each (var data:Object in actions[action][direction]) {
						frameIndex = data.frameIndex;
						if (lastFrameIndex != frameIndex) {
							skin = _id + "_" + action + "_" + direction + "_" + getIndexString(frameIndex);
//							bitmapDataEx = new BitmapDataEx();
							bitmapDataEx = BitmapDataEx.fromPool();
							bitmapDataEx.bitmapData = ResManager.getInstance().getActionBitmapData(_resId, skin);
							bitmapDataEx.x = data.x;
							bitmapDataEx.y = data.y;
							bitmapDataEx.delay = data.delay;
							bitmapDataEx.frameIndex = frameIndex;
							lastFrameIndex = frameIndex;
						}
						for (var i:int = 0; i < StageUtil.fpsMultiple; i++) {
							vector.push(bitmapDataEx);
						}
					}
				}
			}
		}
		
		private function getIndexString(frameIndex:int):String {
			var indexString:String = frameIndex.toString();
			var lastLength:int = 4 - indexString.length;
			while (lastLength > 0) {
				indexString = "0" + indexString;
				lastLength--;
			}
			return indexString;
		}
		
		public function get resId():String {
			return _resId;
		}
		
		public function set resId(value:String):void {
			_resId = value;
		}

		public function get id():String {
			return _id;
		}

		public function set id(value:String):void {
			_id = value;
		}

		public function get interval():int {
			return _interval || StageManager.getInstance().interval;
		}

		public function set interval(value:int):void {
			_interval = value;
		}
		
		public function dispose():void {
			var directions:Dictionary;
			var vector:Vector.<BitmapDataEx>;
			var skin:String;
			var lastBitmapDataEx:BitmapDataEx;
			for (var action:String in _vectors) {
				directions = _vectors[action];
				for (var direction:String in directions) {
					vector = directions[direction];
					for each (var bitmapDataEx:BitmapDataEx in vector) {
//						bitmapDataEx.bitmapData.dispose();
						if (bitmapDataEx != lastBitmapDataEx) {
							BitmapDataEx.toPool(bitmapDataEx);
							lastBitmapDataEx = bitmapDataEx;
						}
					}
				}
			}
			_vectors = null;
			ResManager.getInstance().removeAction(resId);
		}
	}
}