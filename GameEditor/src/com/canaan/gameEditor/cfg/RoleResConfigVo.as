package com.canaan.gameEditor.cfg
{
	import com.canaan.gameEditor.core.GameRes;
	import com.canaan.lib.abstract.AbstractVo;
	import com.canaan.lib.core.SysConfig;
	
	public class RoleResConfigVo extends AbstractVo
	{
		public static const TITLES:Array = ["id", "type", "desc", "actions"];
		public static const OUTPUT_DESC:Array = ["编号", "类型", "动作"];
		public static const OUTPUT_TITLES:Array = ["id", "type", "actions"];
		public static const OUTPUT_TYPE:Array = ["int", "int", "string[]"];
		
		private var _id:int;
		private var _type:int;
		private var _desc:String;
		private var _actions:String;
		
		private var _actionConfigs:Object;
		
		public function RoleResConfigVo()
		{
			super();
		}
		
		public function get cfgData():Object {
			var data:Object = {};
			data["id"] = _id;
			data["type"] = _type;
			data["desc"] = _desc;
			var actionArray:Array = [];
			for (var actionId:int in actionConfigs) {
				actionArray.push(actionId + "|" + actionConfigs[actionId].id);
			}
			data["actions"] = actionArray.join(",");
			return data;
		}
		
		public function get showText():String {
			return _id + (_desc ? "(" + _desc + ")" : "(未备注)");
		}
		
		public function get typeConfig():RoleTypeConfigVo {
			return SysConfig.getConfigVo(GameRes.TBL_ROLE_TYPE, _type) as RoleTypeConfigVo;
		}
		
		/**
		 * 根据动作ID获取动作资源
		 * @param actionId
		 * @return 
		 * 
		 */		
		public function getActionByActionId(actionId:int):ActionResConfigVo {
			return actionConfigs[actionId];
		}
		
		/**
		 * 动作配置
		 * @return 
		 * 
		 */		
		public function get actionConfigs():Object {
			if (_actionConfigs == null) {
				_actionConfigs = new Object();
				if (_actions) {
					var actionInfos:Array = _actions.split(",");
					var actionDetails:Array;
					var actionId:int;
					var actionResId:String;
					for each (var actionInfo:String in actionInfos) {
						actionDetails = actionInfo.split("|");
						actionId = int(actionDetails[0]);
						actionResId = actionDetails[1];
						_actionConfigs[actionId] = SysConfig.getConfigVo(GameRes.TBL_ACTION_RES, actionResId) as ActionResConfigVo;
					}
				}
			}
			return _actionConfigs;
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function set type(value:int):void
		{
			_type = value;
		}

		public function get desc():String
		{
			return _desc;
		}

		public function set desc(value:String):void
		{
			_desc = value;
		}

		public function get actions():String
		{
			return _actions;
		}

		public function set actions(value:String):void
		{
			_actions = value;
		}
	}
}