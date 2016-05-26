package roleObject
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import base.EventManager;
	import base.StateManager;
	
	import enumeration.EnumEvent;
	import enumeration.EnumRoleStateID;
	
	import roleObject.roleStates.FallRoleState;
	import roleObject.roleStates.IdleRoleState;
	import roleObject.roleStates.JumpRoleState;
	import roleObject.roleStates.JumpTwoRoleState;
	import roleObject.roleStates.MoveRoleState;
	import roleObject.roleStates.RoleStateControl;
	import roleObject.roleStates.SkillRoleState;

	public class Role extends Sprite
	{
		private var _roleData:RoleData = new RoleData();
		private var _mcRole:MovieClip = new MovieClip();
		
		public function Role()
		{
		}

		public function init():void {
			RoleStateControl.ins.setDefaultState(this, new IdleRoleState);
			addChild(_mcRole);
			// 注册状态
			RoleStateControl.ins.registerState(new MoveRoleState());
			RoleStateControl.ins.registerState(new JumpRoleState());
			RoleStateControl.ins.registerState(new JumpTwoRoleState());
			RoleStateControl.ins.registerState(new FallRoleState());
			RoleStateControl.ins.registerState(new SkillRoleState());
			// 动作开始事件
			EventManager.ins.addEventListener(EnumEvent.ROLE_MOVE_EVENT, toMove);
			EventManager.ins.addEventListener(EnumEvent.ROLE_JUMP_EVENT, toJump);
			EventManager.ins.addEventListener(EnumEvent.ROLE_SKILL_EVENT, toSkill);
			// 动作结束事件
			EventManager.ins.addEventListener(EnumEvent.ROLE_MOVEEND_EVENT, onMoveEnd);
		}
		
		//------------------------------end event hander------------------------------------
		private function onMoveEnd(event:EnumEvent):void {
			roleData.isMoveing = false;
			if (roleData.state == EnumRoleStateID.ROLE_MOVE) {
				doIdelAction();
			}
		}
		
		//------------------------------start event hander-----------------------------------
		private function toSkill(event:EnumEvent):void {
			if (roleData.isCanSkill && !roleData.isCanComboSkill) {
				doSkillAction();
			} else if (roleData.isCanSkill && roleData.isCanComboSkill) {
				roleData.skillNum++;
				doSkillAction();
			}
		}
		
		private function toJump(event:EnumEvent):void {
			if (roleData.state == EnumRoleStateID.ROLE_IDLE) {
				doJumpAction();
			} else if (roleData.state == EnumRoleStateID.ROLE_JUMP && roleData.isCanJump2) {
				doJump2Action();
			}
		}
		
		private function toMove(event:EnumEvent):void {
			var direction:int = int(event.data);
			roleData.direction = direction;
			roleData.isMoveing = true;
			if (roleData.state == EnumRoleStateID.ROLE_IDLE) {
				doMoveAction();
			}
		}
		
		//------------------------------do action hander-------------------------------------
		public function doIdelAction():void {
			RoleStateControl.ins.changeState(this, EnumRoleStateID.ROLE_IDLE);
		}
		
		public function doMoveAction():void {
			RoleStateControl.ins.changeState(this, EnumRoleStateID.ROLE_MOVE);
		}
		
		public function doJumpAction():void {
			RoleStateControl.ins.changeState(this, EnumRoleStateID.ROLE_JUMP);
		}
		
		public function doJump2Action():void {
			RoleStateControl.ins.changeState(this, EnumRoleStateID.ROLE_JUMP2);
		}
		
		public function doFallAction():void {
			RoleStateControl.ins.changeState(this, EnumRoleStateID.ROLE_FALL);
		}
		
		public function doSkillAction():void {
			RoleStateControl.ins.changeState(this, EnumRoleStateID.ROLE_SKILL);
		}
		
		//----------------------------------update-------------------------------------------
		public function update():void {
			if (mcRole.currentFrameLabel != null) {
				trace(roleData.state, mcRole.currentFrame, mcRole.currentFrameLabel);
			}
			RoleStateControl.ins.updateState(this);
		}
		
		public function get roleData():RoleData
		{
			return _roleData;
		}

		public function set roleData(value:RoleData):void
		{
			_roleData = value;
		}

		public function get mcRole():MovieClip
		{
			return _mcRole;
		}

		public function set mcRole(value:MovieClip):void
		{
			_mcRole = value;
		}


	}
}