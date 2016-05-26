package roleObject.roleStates
{
	import base.IRoleState;
	import base.MovieManager;
	
	import enumeration.EnumRoleStateID;
	
	import roleObject.Role;

	public class IdleRoleState implements IRoleState
	{
		public var _stateID:int = EnumRoleStateID.ROLE_IDLE;
		
		public function IdleRoleState()
		{
		}
		
		public function get stateID():int {
			return _stateID;
		}
		
		public function enterState(role:Role):void {
			role.roleData.isCanSkill = true;
			role.roleData.state = _stateID;
			role.mcRole = MovieManager.PLAYER_IDLE;
			role.addChild(role.mcRole);
			role.mcRole.gotoAndPlay(1);
		}
		
		public function leaveState(role:Role):void {
//			role.mcRole.stop();
			role.mcRole.gotoAndStop(1);
			role.removeChild(role.mcRole);
		}
		
		public function updateState(role:Role):void {
			
		}
		
	}
}