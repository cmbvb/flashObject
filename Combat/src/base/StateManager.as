package base
{
	public class StateManager
	{
		public static const STATE_OP_PUSH:int = 0;								// 新状态进入
		public static const STATE_OP_POP:int = 1;								// 新状态退出
		
		private static var _ins:StateManager;									// 实例
		
		public var mCurState:IState;											// 当前状态
		
		private var mStates:Vector.<IState> = new <IState>[];					// 所有状态集合
		
		public function StateManager()
		{
		}
		
		public static function get ins():StateManager
		{
			if (_ins == null) {
				_ins = new StateManager();
			}
			return _ins;
		}

		
		/**
		 * 添加游戏状态
		 * @param state
		 * 
		 */
		public function addState(state:IState):void {
			mStates.push(state);
		}
		
		/**
		 * 处理当前状态逻辑
		 * 
		 */
		public function cycle():void {
			mCurState.cycle();
		}
		
		/**
		 * 处理当前状态渲染
		 * 
		 */
		public function draw():void {
			mCurState.draw();
		}
		
		public function changeState(newState:IState, op:int):void {
			if (op == STATE_OP_PUSH) {
				newState.stateParent = mCurState;
				mCurState = newState;
			} else if (op == STATE_OP_POP) {
				mCurState = mCurState.stateParent;
			}
			mCurState.cycle();
		}
		
	}
}