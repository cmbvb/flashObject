package com.canaan.gameEditor.data
{
	import com.canaan.lib.display.BitmapDataEx;

	public class ActionAnimSequence
	{
		private var _direction:int;
		private var _maxAnimFrame:int = -1;
		private var _animFrames:Vector.<int>;
		private var _bitmapDatas:Vector.<BitmapDataEx>;
		
		public function ActionAnimSequence()
		{
			_animFrames = new Vector.<int>();
			_bitmapDatas = new Vector.<BitmapDataEx>();
		}

		public function get direction():int
		{
			return _direction;
		}

		public function set direction(value:int):void
		{
			_direction = value;
		}

		public function get maxAnimFrame():int
		{
			return _maxAnimFrame;
		}

		public function set maxAnimFrame(value:int):void
		{
			_maxAnimFrame = value;
		}

		public function get animFrames():Vector.<int>
		{
			return _animFrames;
		}

		public function set animFrames(value:Vector.<int>):void
		{
			_animFrames = value;
		}

		public function get bitmapDatas():Vector.<BitmapDataEx>
		{
			return _bitmapDatas;
		}

		public function set bitmapDatas(value:Vector.<BitmapDataEx>):void
		{
			_bitmapDatas = value;
		}
	}
}