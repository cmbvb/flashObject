package com.canaan.lib.algorithm.particle
{
	import com.canaan.lib.utils.Position3;

	/**
	 * 粒子
	 * @author Administrator
	 * 
	 */	
	public class Particle
	{
		private var _age:Number;										// 粒子年龄
		private var _maxAge:Number;										// 粒子年龄上限
		private var _isAlive:Boolean;									// 粒子存活状态
		private var _isFaceRight:Boolean;								// 粒子方向朝右
		private var _rotateZ:Number;									// 粒子z轴旋转
		private var _velocity:Position3;								// 粒子速度
		private var _originPosition:Position3;							// 粒子起始位置
		private var _position:Position3;								// 粒子当前位置
		private var _lastPosition:Position3;							// 粒子上一次位置
		private var _parse:Boolean;										// 粒子暂停
		
		public function Particle()
		{
			_age = 0;
			_maxAge = -1;
			_isAlive = true;
			_isFaceRight = true;
			_rotateZ = 0;
			_velocity = new Position3();
			_originPosition = new Position3();
			_position = new Position3();
			_lastPosition = new Position3();
		}
		
		/**
		 * 备份粒子上一次位置
		 * 
		 */		
		public function bakLastPosition():void {
			lastPosition.copy(position);
		}

		public function get age():Number
		{
			return _age;
		}

		public function set age(value:Number):void
		{
			_age = value;
		}

		public function get maxAge():Number
		{
			return _maxAge;
		}

		public function set maxAge(value:Number):void
		{
			_maxAge = value;
		}

		public function get isAlive():Boolean
		{
			return _isAlive;
		}

		public function set isAlive(value:Boolean):void
		{
			_isAlive = value;
		}

		public function get isFaceRight():Boolean
		{
			return _isFaceRight;
		}

		public function set isFaceRight(value:Boolean):void
		{
			_isFaceRight = value;
		}

		public function get rotateZ():Number
		{
			return _rotateZ;
		}

		public function set rotateZ(value:Number):void
		{
			_rotateZ = value;
		}

		public function get velocity():Position3
		{
			return _velocity;
		}

		public function set velocity(value:Position3):void
		{
			_velocity = value;
		}

		public function get originPosition():Position3
		{
			return _originPosition;
		}

		public function set originPosition(value:Position3):void
		{
			_originPosition = value;
		}

		public function get position():Position3
		{
			return _position;
		}

		public function set position(value:Position3):void
		{
			_position = value;
		}

		public function get lastPosition():Position3
		{
			return _lastPosition;
		}

		public function set lastPosition(value:Position3):void
		{
			_lastPosition = value;
		}

		public function get parse():Boolean
		{
			return _parse;
		}

		public function set parse(value:Boolean):void
		{
			_parse = value;
		}
	}
}