package roleObject.roleStates
{
	import base.EventManager;
	import base.GameConfig;
	import base.IRoleState;
	import base.MovieManager;
	import base.RoleSetting;
	
	import enumeration.EnumEvent;
	import enumeration.EnumRoleDirection;
	import enumeration.EnumRoleStateID;
	
	import roleObject.Role;

	public class JumpRoleState implements IRoleState
	{
		public var _stateID:int = EnumRoleStateID.ROLE_JUMP;
		
		public function JumpRoleState()
		{
			
		}
		
		public function get stateID():int {
			return _stateID;
		}
		
		public function enterState(role:Role):void {
			role.roleData.state = _stateID;
			role.mcRole = MovieManager.PLAYER_JUMP;
			role.addChild(role.mcRole);
			role.mcRole.gotoAndPlay(1);
		}
		
		public function leaveState(role:Role):void {
//			role.mcRole.stop();
			role.roleData.isCanJump2 = false;
			role.mcRole.gotoAndStop(1);
			role.removeChild(role.mcRole);
		}
		
		public function updateState(role:Role):void {
			role.roleData.isCanJump2 = false;
			role.roleData.isCanSkill = false;
			if (role.mcRole.currentFrame == role.mcRole.framesLoaded) {
				RoleStateControl.ins.changeState(role, EnumRoleStateID.ROLE_IDLE);
				return;
			}
			if ((role.y + RoleSetting.JUMP_SPEED) < GameConfig.GAMEHEIGHT &&　role.mcRole.currentFrame <= 5) {
				role.y -= RoleSetting.JUMP_SPEED;
			} else if (role.mcRole.currentFrame > 7 && role.mcRole.currentFrame <= 10) {
				role.roleData.isCanJump2 = true;
				role.roleData.isCanSkill = true;
			} else if (role.mcRole.currentFrame > 10) {
				role.y += RoleSetting.JUMP_SPEED;
			}
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