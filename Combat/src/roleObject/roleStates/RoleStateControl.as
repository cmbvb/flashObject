package roleObject.roleStates
{
	import flash.utils.Dictionary;
	
	import base.IRoleState;
	
	import roleObject.Role;

	public class RoleStateControl
	{
		private static var _ins:RoleStateControl;
		private var mRoleStateDic:Dictionary = new Dictionary();					// 状态字典
		private var mDefaultState:IRoleState;										// 默认状态
		
		public function RoleStateControl()
		{
		}
		
		/**
		 * 设置默认状态
		 * @param state
		 * 
		 */
		public function setDefaultState(role:Role, state:IRoleState):void {
			registerState(state);
			mDefaultState = state;
			mDefaultState.enterState(role);
		}
		
		/**
		 * 注册状态
		 * @param state
		 * 
		 */
		public function registerState(state:IRoleState):void {
			if (mRoleStateDic[state.stateID] == null) {
				mRoleStateDic[state.stateID] = state;
			}
		}
		
		/**
		 * 注销状态
		 * @param state
		 * 
		 */
		public function cancelState(state:IRoleState):void {
			delete mRoleStateDic[state.stateID];
		}
		
		/**
		 * 改变状态
		 * @param role
		 * @param state
		 * 
		 */
		public function changeState(role:Role, stateID:int):void {
			var leaveState:IRoleState = mRoleStateDic[role.roleData.state];
			if (leaveState.stateID != stateID) {
				leaveState.leaveState(role);
			}
			var enterState:IRoleState = mRoleStateDic[stateID];
			enterState.enterState(role);
		}
		
		/**
		 * 当前状态更新
		 * @param role
		 * 
		 */
		public function updateState(role:Role):void {
			var curState:IRoleState = mRoleStateDic[role.roleData.state];
			curState.updateState(role);
		}

		public static function get ins():RoleStateControl
		{
			if (_ins == null) {
				_ins = new RoleStateControl();
			}
			return _ins;
		}

		
	}
}