package com.canaan.lib.events
{
	import flash.events.Event;
	
	public class GuideEvent extends Event
	{
		public static const GUIDE_CLICK:String = "GuideEventGuideClick";
		public static const GUIDE_RIGHT_CLICK:String = "GuideEventGuideRightClick";
		public static const GUIDE_DOUBLE_CLICK:String = "GuideEventGuideDoubleClick";
		public static const GUIDE_ADDED_TO_STAGE:String = "GuideAddedToStage";
		public static const GUIDE_REMOVED_FROM_STAGE:String = "GuideRemovedFrameStage";
		public static const GUIDE_REMOVED_CONTROL:String = "GuideRemovedControl";
		
		private var _data:Object;
		
		public function GuideEvent(type:String, data:Object = null)
		{
			super(type);
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