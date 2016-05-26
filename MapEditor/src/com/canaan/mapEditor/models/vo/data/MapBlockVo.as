package com.canaan.mapEditor.models.vo.data
{
	public class MapBlockVo
	{
		private var _x:int;
		private var _y:int;
		private var _type:int;
		
		public function MapBlockVo()
		{
		}

		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
		}

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y = value;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}
	}
}