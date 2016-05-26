package roleObject
{
	public class RoleData
	{
		private var _state:int;
		private var _direction:int;
		private var _skillNum:int;
		private var _isCanJump2:Boolean;
		private var _isMoveing:Boolean;
		private var _isCanComboSkill:Boolean;
		private var _isCanSkill:Boolean;
		
		public function RoleData()
		{
		}

		public function get state():int
		{
			return _state;
		}

		public function set state(value:int):void
		{
			_state = value;
		}

		public function get direction():int
		{
			return _direction;
		}

		public function set direction(value:int):void
		{
			_direction = value;
		}

		public function get isCanJump2():Boolean
		{
			return _isCanJump2;
		}

		public function set isCanJump2(value:Boolean):void
		{
			_isCanJump2 = value;
		}

		public function get isMoveing():Boolean
		{
			return _isMoveing;
		}

		public function set isMoveing(value:Boolean):void
		{
			_isMoveing = value;
		}

		public function get skillNum():int
		{
			return _skillNum;
		}

		public function set skillNum(value:int):void
		{
			_skillNum = value;
		}

		public function get isCanComboSkill():Boolean
		{
			return _isCanComboSkill;
		}

		public function set isCanComboSkill(value:Boolean):void
		{
			_isCanComboSkill = value;
		}

		public function get isCanSkill():Boolean
		{
			return _isCanSkill;
		}

		public function set isCanSkill(value:Boolean):void
		{
			_isCanSkill = value;
		}


	}
}