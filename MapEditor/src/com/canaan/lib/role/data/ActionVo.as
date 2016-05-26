package com.canaan.lib.role.data
{
	import com.canaan.lib.abstract.AbstractVo;
	import com.canaan.lib.display.BitmapDataEx;
	import com.canaan.lib.managers.ResManager;
	import com.canaan.lib.managers.StageManager;
	
	import flash.utils.Dictionary;
	
	public class ActionVo extends AbstractVo
	{
		private static var cache:Dictionary = new Dictionary();
		
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
			var skin:String;
			for (var action:String in actions) {
				directions = new Dictionary();
				_vectors[action] = directions;
				for (var direction:String in actions[action]) {
					vector = new Vector.<BitmapDataEx>();
					directions[direction] = vector;
					frameIndex = 0;
					for each (var data:Object in actions[action][direction]) {
						bitmapDataEx = new BitmapDataEx();
						skin = _id + "_" + action + "_" + direction + "_" + getIndexString(frameIndex);
						bitmapDataEx.bitmapData = ResManager.getInstance().getBitmapData(skin);
						bitmapDataEx.x = data.x;
						bitmapDataEx.y = data.y;
						bitmapDataEx.delay = data.delay;
						bitmapDataEx.frameIndex = frameIndex;
						vector.push(bitmapDataEx);
						frameIndex++;
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
		
		public static function getAction(id:String):ActionVo {
			var actionVo:ActionVo = cache[id];
			if (actionVo == null) {
				var headData:Object = ResManager.getInstance().getContent(id);
				if (headData != null) {
					cache[id] = actionVo = new ActionVo();
					actionVo.setHeadData(headData);
				}
			}
			return actionVo;
		}
	}
}