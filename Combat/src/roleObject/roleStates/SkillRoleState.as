package roleObject.roleStates
{
	import base.IRoleState;
	import base.MovieManager;
	
	import enumeration.EnumRoleStateID;
	
	import roleObject.Role;

	public class SkillRoleState implements IRoleState
	{
		private var _stateID:int = EnumRoleStateID.ROLE_SKILL;
		private var mFrameCount:int;
		
		public function SkillRoleState()
		{
		}
		
		public function get stateID():int {
			return _stateID;
		}
		
		public function enterState(role:Role):void {
			role.roleData.state = _stateID;
			switch (role.roleData.skillNum) {
				case 0:
					mFrameCount = 0;
					role.mcRole = MovieManager.PLAYER_COMMONATK1;
					break;
				case 1:
					mFrameCount = 0;
					role.mcRole = MovieManager.PLAYER_COMMONATK2;
					break;
				case 2:
					mFrameCount = 0;
					role.mcRole = MovieManager.PLAYER_COMMONATK3;
					break;
			}
			role.addChild(role.mcRole);
			role.mcRole.gotoAndPlay(1);
		}
		
		public function leaveState(role:Role):void {
			role.roleData.isCanComboSkill = false;
			role.roleData.skillNum = 0;
			role.mcRole.gotoAndStop(1);
			role.removeChild(role.mcRole);
		}
		
		public function updateState(role:Role):void {
			mFrameCount ++;
			if (role.mcRole.currentFrame == role.mcRole.framesLoaded) {
				role.roleData.isCanComboSkill = true;
				if (mFrameCount - role.mcRole.framesLoaded > 5) {
					role.roleData.isCanComboSkill = false;
					RoleStateControl.ins.changeState(role, EnumRoleStateID.ROLE_IDLE);
				}
			} else {
				role.roleData.isCanComboSkill = false;
			}
		}
		
	}
}