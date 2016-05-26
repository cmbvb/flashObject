package com.canaan.gameEditor.cfg
{
	import com.canaan.gameEditor.core.GameRes;
	import com.canaan.lib.abstract.AbstractVo;
	import com.canaan.lib.core.SysConfig;
	
	public class SkillResConfigVo extends AbstractVo
	{
		public static const TITLES:Array = ["id", "desc", "roleResId", "action", "lockTarget", "unLoackTarget", "nonTargetSelf", "releaseEffectId", "releaseEffectFrame", "directionEffectId", "directionEffectFrame", "missileEffectType", "missileSpeed", "missileEffectId", "missileEffectFrame", "missileHitEffectId"];
		public static const OUTPUT_DESC:Array = ["编号", "备注", "动作", "技能锁定目标", "不锁定目标", "无目标时对自己使用", "自身特效ID", "自身特效起始帧", "技能8方向特效ID", "技能8方向特效起始帧", "飞行道具类型（有轨迹1, 无轨迹不黏人2，无轨迹黏人3）", "飞行道具速度（仅对有轨迹有效）", "飞行道具ID", "飞行道具起始帧", "撞击特效ID"];
		public static const OUTPUT_TITLES:Array = ["id", "desc", "action", "lockTarget", "unLoackTarget", "nonTargetSelf", "releaseEffectId", "releaseEffectFrame", "directionEffectId", "directionEffectFrame", "missileEffectType", "missileSpeed", "missileEffectId", "missileEffectFrame", "missileHitEffectId"];
		public static const OUTPUT_TYPE:Array = ["int", "string", "int", "bool", "bool", "bool", "int", "int", "int", "int", "int", "int", "int", "int", "int"];
		
		// 编号
		private var _id:int;
		// 备注
		private var _desc:String;
		// 角色ID
		private var _roleResId:int;
		// 动作
		private var _action:int;
		// 技能锁定目标
		private var _lockTarget:int;
		// 不锁定目标
		private var _unLoackTarget:int;
		// 无目标时对自己使用
		private var _nonTargetSelf:int;
		// 自身特效ID
		private var _releaseEffectId:int;
		// 自身特效起始帧
		private var _releaseEffectFrame:int;
		// 技能8方向特效ID
		private var _directionEffectId:int;
		// 技能8方向特效起始帧
		private var _directionEffectFrame:int;
		// 飞行道具类型（有轨迹1, 无轨迹不黏人2，无轨迹黏人3）
		private var _missileEffectType:int;
		// 飞行道具速度（仅对有轨迹有效）
		private var _missileSpeed:int;
		// 飞行道具ID
		private var _missileEffectId:int;
		// 飞行道具起始帧
		private var _missileEffectFrame:int;
		// 撞击特效ID
		private var _missileHitEffectId:int;
		
		private var _roleConfig:RoleResConfigVo;
		private var _releaseEffectRoleResConfig:RoleResConfigVo;
		private var _directionEffectRoleResConfig:RoleResConfigVo;
		private var _missileEffectRoleResConfig:RoleResConfigVo;
		private var _missileHitEffectRoleResConfig:RoleResConfigVo;
		
		public function SkillResConfigVo()
		{
			super();
		}
		
		public function get cfgData():Object {
			var data:Object = {};
			data["id"] = _id;
			data["desc"] = _desc;
			data["roleResId"] = _roleResId;
			data["action"] = _action;
			data["lockTarget"] = _lockTarget;
			data["unLoackTarget"] = _unLoackTarget;
			data["nonTargetSelf"] = _nonTargetSelf;
			data["releaseEffectId"] = _releaseEffectId;
			data["releaseEffectFrame"] = _releaseEffectFrame;
			data["directionEffectId"] = _directionEffectId;
			data["directionEffectFrame"] = _directionEffectFrame;
			data["missileEffectType"] = _missileEffectType;
			data["missileSpeed"] = _missileSpeed;
			data["missileEffectId"] = _missileEffectId;
			data["missileEffectFrame"] = _missileEffectFrame;
			data["missileHitEffectId"] = _missileHitEffectId;
			return data;
		}
		
		public function get showText():String {
			return _id + (_desc ? "(" + _desc + ")" : "(未备注)");
		}
		
		public function get roleConfig():RoleResConfigVo {
			if (_roleConfig == null) {
				_roleConfig = SysConfig.getConfigVo(GameRes.TBL_ROLE_RES, _roleResId) as RoleResConfigVo;
			}
			return _roleConfig;
		}

		public function get releaseEffectRoleResConfig():RoleResConfigVo {
			if (_releaseEffectRoleResConfig == null) {
				_releaseEffectRoleResConfig = SysConfig.getConfigVo(GameRes.TBL_ROLE_RES, _releaseEffectId) as RoleResConfigVo;
			}
			return _releaseEffectRoleResConfig;
		}
		
		public function get directionEffectRoleResConfig():RoleResConfigVo {
			if (_directionEffectRoleResConfig == null) {
				_directionEffectRoleResConfig = SysConfig.getConfigVo(GameRes.TBL_ROLE_RES, _directionEffectId) as RoleResConfigVo;
			}
			return _directionEffectRoleResConfig;
		}
		
		public function get missileEffectRoleResConfig():RoleResConfigVo {
			if (_missileEffectRoleResConfig == null) {
				_missileEffectRoleResConfig = SysConfig.getConfigVo(GameRes.TBL_ROLE_RES, _missileEffectId) as RoleResConfigVo;
			}
			return _missileEffectRoleResConfig;
		}
		
		public function get missileHitEffectRoleResConfig():RoleResConfigVo {
			if (_missileHitEffectRoleResConfig == null) {
				_missileHitEffectRoleResConfig = SysConfig.getConfigVo(GameRes.TBL_ROLE_RES, _missileHitEffectId) as RoleResConfigVo;
			}
			return _missileHitEffectRoleResConfig;
		}

		public function get id():int {
			return _id;
		}
		
		public function set id(value:int):void {
			_id = value;
		}
		
		public function get desc():String {
			return _desc;
		}
		
		public function set desc(value:String):void {
			_desc = value;
		}
		
		public function get roleResId():int {
			return _roleResId;
		}
		
		public function set roleResId(value:int):void {
			_roleResId = value;
		}
		
		public function get action():int {
			return _action;
		}
		
		public function set action(value:int):void {
			_action = value;
		}
		
		public function get lockTarget():int {
			return _lockTarget;
		}
		
		public function set lockTarget(value:int):void {
			_lockTarget = value;
		}
		
		public function get unLoackTarget():int {
			return _unLoackTarget;
		}
		
		public function set unLoackTarget(value:int):void {
			_unLoackTarget = value;
		}
		
		public function get nonTargetSelf():int {
			return _nonTargetSelf;
		}
		
		public function set nonTargetSelf(value:int):void {
			_nonTargetSelf = value;
		}
		
		public function get releaseEffectId():int {
			return _releaseEffectId;
		}
		
		public function set releaseEffectId(value:int):void {
			_releaseEffectId = value;
		}
		
		public function get releaseEffectFrame():int {
			return _releaseEffectFrame;
		}
		
		public function set releaseEffectFrame(value:int):void {
			_releaseEffectFrame = value;
		}
		
		public function get directionEffectId():int {
			return _directionEffectId;
		}
		
		public function set directionEffectId(value:int):void {
			_directionEffectId = value;
		}
		
		public function get directionEffectFrame():int {
			return _directionEffectFrame;
		}
		
		public function set directionEffectFrame(value:int):void {
			_directionEffectFrame = value;
		}
		
		public function get missileEffectType():int {
			return _missileEffectType;
		}
		
		public function set missileEffectType(value:int):void {
			_missileEffectType = value;
		}
		
		public function get missileSpeed():int {
			return _missileSpeed;
		}
		
		public function set missileSpeed(value:int):void {
			_missileSpeed = value;
		}
		
		public function get missileEffectId():int {
			return _missileEffectId;
		}
		
		public function set missileEffectId(value:int):void {
			_missileEffectId = value;
		}
		
		public function get missileEffectFrame():int {
			return _missileEffectFrame;
		}
		
		public function set missileEffectFrame(value:int):void {
			_missileEffectFrame = value;
		}
		
		public function get missileHitEffectId():int {
			return _missileHitEffectId;
		}
		
		public function set missileHitEffectId(value:int):void {
			_missileHitEffectId = value;
		}
	}
}