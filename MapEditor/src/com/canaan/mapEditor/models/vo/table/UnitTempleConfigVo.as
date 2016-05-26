package com.canaan.mapEditor.models.vo.table
{
	import com.canaan.lib.core.TableConfig;
	import com.canaan.mapEditor.core.GameRes;

	public class UnitTempleConfigVo
	{
		// 怪物ID
		protected var _id:int;
		// 显示名
		protected var _name:String;
		// 编辑器目录
		protected var _editdir:String;
		// 类型
		protected var _type:int;
		// 子类型
		protected var _subType:int;
		// 面板类型
		protected var _boardType:int;
		// 头像
		protected var _head:int;
		// 等级
		protected var _lev:int;
		// 动画
		protected var _model:int;
		// 大小
		protected var _size:int;
		// 传送点名称
		protected var _teleportID:int;
		// 获得经验
		protected var _exp:int;
		// 技能间隔时间
		protected var _interval:int;
		// 默认AI
		protected var _AI:String;
		// AI模式
		protected var _Aimodel:int;
		// 视野范围
		protected var _sight:int;
		// 追击范围
		protected var _maxmove:int;
		// 巡逻范围
		protected var _patrol:int;
		// 巡逻速度
		protected var _patrolTime:int;
		// 尸体消失时间
		protected var _deadTime:int;
		// 刷新时间
		protected var _refreshTime:int;
		// 移动速度
		protected var _moveTime:int;
		// 进入音效
		protected var _moveInMusic:int;
		// 血量
		protected var _MHP:int;
		// 最小物攻
		protected var _MinATK:int;
		// 最大物攻
		protected var _MaxATK:int;
		// 最小法攻
		protected var _MinMATK:int;
		// 最大法攻
		protected var _MaxMATK:int;
		// 最小物防
		protected var _MinDEF:int;
		// 最大物防
		protected var _MaxDEF:int;
		// 最小法防
		protected var _MinMDEF:int;
		// 最大法防
		protected var _MaxMDEF:int;
		// 命中
		protected var _HIT:int;
		// 闪避
		protected var _DODGE:int;
		// 抗暴击
		protected var _DUCrate:int;
		// 物理攻击减免
		protected var _ADTR:int;
		// 魔法减免
		protected var _MR:int;
		// 抗麻痹
		protected var _DUPAC:int;
		// 战斗中回血速度
		protected var _fightHPup:int;
		// 平时回血速度
		protected var _unfighthpup:int;
		// 地图
		protected var _map:String;
		// 掉落组ID
		protected var _dropID:String;
		// 任务掉落
		protected var _taskdrop:String;
		// 任务掉落几率
		protected var _taskdroprate:Number;
		// 功能ID
		protected var _funcid:String;
		// 功能参数
		protected var _funcparams:String;
		// 功能数据
		protected var _funcdatas:String;
		// 默认对话
		protected var _dialog:String;
		// 简单掉落ID
		protected var _simpleDropID:int;
		// boss积分
		protected var _bossCon:int;
		
		private var _roleResConfig:RoleResTempleConfigVo;
		
		public function UnitTempleConfigVo()
		{
			super();
		}
		
		public function get showText():String {
			return _name + "(" + _id + ")";
		}
		
		public function get roleResConfig():RoleResTempleConfigVo {
			if (_roleResConfig == null) {
				_roleResConfig = TableConfig.getConfigVo(GameRes.TBL_ROLE_RES, _model) as RoleResTempleConfigVo;
			}
			return _roleResConfig;
		}
		
		public function get id():int {
			return _id;
		}
		
		public function set id(value:int):void {
			_id = value;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function set name(value:String):void {
			_name = value;
		}
		
		public function get editdir():String {
			return _editdir;
		}
		
		public function set editdir(value:String):void {
			_editdir = value;
		}
		
		public function get type():int {
			return _type;
		}
		
		public function set type(value:int):void {
			_type = value;
		}
		
		public function get subType():int {
			return _subType;
		}
		
		public function set subType(value:int):void {
			_subType = value;
		}
		
		public function get boardType():int {
			return _boardType;
		}
		
		public function set boardType(value:int):void {
			_boardType = value;
		}
		
		public function get head():int {
			return _head;
		}
		
		public function set head(value:int):void {
			_head = value;
		}
		
		public function get lev():int {
			return _lev;
		}
		
		public function set lev(value:int):void {
			_lev = value;
		}
		
		public function get model():int {
			return _model;
		}
		
		public function set model(value:int):void {
			_model = value;
		}
		
		public function get size():int {
			return _size;
		}
		
		public function set size(value:int):void {
			_size = value;
		}
		
		public function get teleportID():int {
			return _teleportID;
		}
		
		public function set teleportID(value:int):void {
			_teleportID = value;
		}
		
		public function get exp():int {
			return _exp;
		}
		
		public function set exp(value:int):void {
			_exp = value;
		}
		
		public function get interval():int {
			return _interval;
		}
		
		public function set interval(value:int):void {
			_interval = value;
		}
		
		public function get AI():String {
			return _AI;
		}
		
		public function set AI(value:String):void {
			_AI = value;
		}
		
		public function get Aimodel():int {
			return _Aimodel;
		}
		
		public function set Aimodel(value:int):void {
			_Aimodel = value;
		}
		
		public function get sight():int {
			return _sight;
		}
		
		public function set sight(value:int):void {
			_sight = value;
		}
		
		public function get maxmove():int {
			return _maxmove;
		}
		
		public function set maxmove(value:int):void {
			_maxmove = value;
		}
		
		public function get patrol():int {
			return _patrol;
		}
		
		public function set patrol(value:int):void {
			_patrol = value;
		}
		
		public function get patrolTime():int {
			return _patrolTime;
		}
		
		public function set patrolTime(value:int):void {
			_patrolTime = value;
		}
		
		public function get deadTime():int {
			return _deadTime;
		}
		
		public function set deadTime(value:int):void {
			_deadTime = value;
		}
		
		public function get refreshTime():int {
			return _refreshTime;
		}
		
		public function set refreshTime(value:int):void {
			_refreshTime = value;
		}
		
		public function get moveTime():int {
			return _moveTime;
		}
		
		public function set moveTime(value:int):void {
			_moveTime = value;
		}
		
		public function get moveInMusic():int {
			return _moveInMusic;
		}
		
		public function set moveInMusic(value:int):void {
			_moveInMusic = value;
		}
		
		public function get MHP():int {
			return _MHP;
		}
		
		public function set MHP(value:int):void {
			_MHP = value;
		}
		
		public function get MinATK():int {
			return _MinATK;
		}
		
		public function set MinATK(value:int):void {
			_MinATK = value;
		}
		
		public function get MaxATK():int {
			return _MaxATK;
		}
		
		public function set MaxATK(value:int):void {
			_MaxATK = value;
		}
		
		public function get MinMATK():int {
			return _MinMATK;
		}
		
		public function set MinMATK(value:int):void {
			_MinMATK = value;
		}
		
		public function get MaxMATK():int {
			return _MaxMATK;
		}
		
		public function set MaxMATK(value:int):void {
			_MaxMATK = value;
		}
		
		public function get MinDEF():int {
			return _MinDEF;
		}
		
		public function set MinDEF(value:int):void {
			_MinDEF = value;
		}
		
		public function get MaxDEF():int {
			return _MaxDEF;
		}
		
		public function set MaxDEF(value:int):void {
			_MaxDEF = value;
		}
		
		public function get MinMDEF():int {
			return _MinMDEF;
		}
		
		public function set MinMDEF(value:int):void {
			_MinMDEF = value;
		}
		
		public function get MaxMDEF():int {
			return _MaxMDEF;
		}
		
		public function set MaxMDEF(value:int):void {
			_MaxMDEF = value;
		}
		
		public function get HIT():int {
			return _HIT;
		}
		
		public function set HIT(value:int):void {
			_HIT = value;
		}
		
		public function get DODGE():int {
			return _DODGE;
		}
		
		public function set DODGE(value:int):void {
			_DODGE = value;
		}
		
		public function get DUCrate():int {
			return _DUCrate;
		}
		
		public function set DUCrate(value:int):void {
			_DUCrate = value;
		}
		
		public function get ADTR():int {
			return _ADTR;
		}
		
		public function set ADTR(value:int):void {
			_ADTR = value;
		}
		
		public function get MR():int {
			return _MR;
		}
		
		public function set MR(value:int):void {
			_MR = value;
		}
		
		public function get DUPAC():int {
			return _DUPAC;
		}
		
		public function set DUPAC(value:int):void {
			_DUPAC = value;
		}
		
		public function get fightHPup():int {
			return _fightHPup;
		}
		
		public function set fightHPup(value:int):void {
			_fightHPup = value;
		}
		
		public function get unfighthpup():int {
			return _unfighthpup;
		}
		
		public function set unfighthpup(value:int):void {
			_unfighthpup = value;
		}
		
		public function get map():String {
			return _map;
		}
		
		public function set map(value:String):void {
			_map = value;
		}
		
		public function get dropID():String {
			return _dropID;
		}
		
		public function set dropID(value:String):void {
			_dropID = value;
		}
		
		public function get taskdrop():String {
			return _taskdrop;
		}
		
		public function set taskdrop(value:String):void {
			_taskdrop = value;
		}
		
		public function get taskdroprate():Number {
			return _taskdroprate;
		}
		
		public function set taskdroprate(value:Number):void {
			_taskdroprate = value;
		}
		
		public function get funcid():String {
			return _funcid;
		}
		
		public function set funcid(value:String):void {
			_funcid = value;
		}
		
		public function get funcparams():String {
			return _funcparams;
		}
		
		public function set funcparams(value:String):void {
			_funcparams = value;
		}
		
		public function get funcdatas():String {
			return _funcdatas;
		}
		
		public function set funcdatas(value:String):void {
			_funcdatas = value;
		}
		
		public function get dialog():String {
			return _dialog;
		}
		
		public function set dialog(value:String):void {
			_dialog = value;
		}
		
		public function get simpleDropID():int {
			return _simpleDropID;
		}
		
		public function set simpleDropID(value:int):void {
			_simpleDropID = value;
		}
		
		public function get bossCon():int {
			return _bossCon;
		}
		
		public function set bossCon(value:int):void {
			_bossCon = value;
		}
		
	}
}