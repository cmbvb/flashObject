package roleObject.roleStates
{
	import base.GameConfig;
	import base.IRoleState;
	import base.MovieManager;
	import base.RoleSetting;
	
	import enumeration.EnumRoleDirection;
	import enumeration.EnumRoleStateID;
	
	import roleObject.Role;

	public class FallRoleState implements IRoleState
	{
		private var _stateID:int = EnumRoleStateID.ROLE_FALL;
		
		public function FallRoleState()
		{
		}
		
		public function get stateID():int {
			return _stateID;
		}
		
		public function enterState(role:Role):void {
			role.roleData.state = _stateID;
			role.mcRole = MovieManager.PLAYER_FALL;
			role.addChild(role.mcRole);
			role.mcRole.gotoAndPlay(1);
		}
		
		public function leaveState(role:Role):void {
//			role.mcRole.stop();
			role.mcRole.gotoAndStop(1);
			role.removeChild(role.mcRole);
		}
		
		public function updateState(role:Role):void {
			if (role.mcRole.currentFrame >= role.mcRole.framesLoaded) {
				RoleStateControl.ins.changeState(role, EnumRoleStateID.ROLE_IDLE);
				return;
			}
			if (role.mcRole.currentFrame <= 9) {
				role.y += RoleSetting.JUMP_SPEED;
				// 移动
				if (role.roleData.isMoveing && role.roleData.direction == EnumRoleDirection.LEFT && (role.x - RoleSetting.MOVE_SPEED) > 0) {
					role.scaleX = -1;
					role.x -= RoleSetting.MOVE_SPEED;
				} else if (role.roleData.isMoveing && role.roleData.direction == EnumRoleDirection.RIGHT && (role.x + RoleSetting.MOVE_SPEED) < GameConfig.GAMEWIDTH) {
					role.scaleX = 1;
					role.x += RoleSetting.MOVE_SPEED;
				}
			}
		}
		
	}
}