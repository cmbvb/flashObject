package com.canaan.gameEditor.event
{
	import flash.events.Event;
	
	public class GlobalEvent extends Event
	{
		public static const SOUND_VIEW_REFRESH_LIST:String = "soundViewRefreshList";
		public static const SOUND_CHOOSE_COMPLETE:String = "soundChooseComplete";
		
		public static const ACTION_VIEW_REFRESH_LIST:String = "actionViewRefreshList";
		public static const ACTION_EDIT_SWAP_TIME_LINE:String = "actionEditSwapTimeLine";
		public static const ACTION_EDIT_SET_TIME_LINE:String = "actionEditSetTimeLine";
		public static const ACTION_ROLE_TYPE_REFRESH_LIST:String = "actionRoleTypeRefreshList";
		public static const ACTION_ACTION_TYPE_REFRESH_LIST:String = "actionActionTypeRefreshList";
		public static const ACTION_RES_LOAD_COMPLETE:String = "actionResLoadComplete";
		public static const ACTION_RES_DELETE_ACTION:String = "actionResDeleteAction";
		public static const ACTION_RES_REFRESH_LIST:String = "actionResRefreshList";
		public static const ACTION_IMAGES_SAVE_COMPLETE:String = "actionImagesSaveComplete";
		public static const ACTION_CHOOSE_COMPLETE:String = "actionChooseComplete";
		
		public static const SKILL_VIEW_REFRESH_LIST:String = "SkillViewRefreshList";
		
		private var _data:Object;
		
		public function GlobalEvent(type:String, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}
	}
}