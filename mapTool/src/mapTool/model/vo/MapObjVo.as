package mapTool.model.vo
{
	public class MapObjVo
	{
		private var _row:int;
		private var _col:int;
		private var _walkAble:int = 1;
		private var _hideAble:int = 0;
		
		public function MapObjVo()
		{
		}

		public function setdata(obj:Object):void {
			if (obj.hasOwnProperty("row")) {
				_row = obj.row;
			}
			if (obj.hasOwnProperty("col")) {
				_col = obj.col;
			}
			if (obj.hasOwnProperty("walkAble")) {
				_walkAble = obj.walkAble;
			}
			if (obj.hasOwnProperty("hideAble")) {
				_hideAble = obj.hideAble;
			}
		}
		
		public function get walkAble():int
		{
			return _walkAble;
		}

		public function set walkAble(value:int):void
		{
			_walkAble = value;
		}

		public function get hideAble():int
		{
			return _hideAble;
		}

		public function set hideAble(value:int):void
		{
			_hideAble = value;
		}

		public function get row():int
		{
			return _row;
		}

		public function set row(value:int):void
		{
			_row = value;
		}

		public function get col():int
		{
			return _col;
		}

		public function set col(value:int):void
		{
			_col = value;
		}


	}
}