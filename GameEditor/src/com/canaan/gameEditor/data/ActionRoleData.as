package com.canaan.gameEditor.data
{
	import com.canaan.lib.utils.ObjectUtil;
	
	import flash.utils.Dictionary;

	public class ActionRoleData
	{
		private var _actions:Dictionary;
		private var _desc:String;
		
		public function ActionRoleData()
		{
			_actions = new Dictionary();
		}
		
		public function merge(roleData:ActionRoleData):void {
			ObjectUtil.merge(_actions, roleData.actions);
		}
		
		public function hasActions():Boolean {
			return ObjectUtil.count(_actions) > 0;
		}

		public function get actions():Dictionary
		{
			return _actions;
		}

		public function set actions(value:Dictionary):void
		{
			_actions = value;
		}

		public function get desc():String
		{
			return _desc;
		}

		public function set desc(value:String):void
		{
			_desc = value;
		}

	}
}