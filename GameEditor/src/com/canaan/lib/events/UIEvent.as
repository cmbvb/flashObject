package com.canaan.lib.events 
{
	import flash.events.Event;
	
	public class UIEvent extends Event 
	{
		public static const MOVE:String = "move";
		public static const RENDER_COMPLETED:String = "renderCompleted";
		public static const SCROLL:String = "scroll";
		public static const FRAME_CHANGED:String = "frameChanged";
		public static const ITEM_RENDER:String = "listRender";
		public static const IMAGE_LOADED:String = "imageLoaded";
		
		public static const RESIZE:String = "resize";
		public static const VIEW_CREATED:String = "viewCreated";
		public static const CHANGE:String = "change";
		
		public static const TOOL_TIP_CHANGED:String = "toolTipChanged";
		public static const TOOL_TIP_START:String = "toolTipStart";
		public static const TOOL_TIP_SHOW:String = "toolTipShow";
		public static const TOOL_TIP_HIDE:String = "toolTipHide";
		
		public static const UICOMPONENT_GUIDE_ADDED_TO_STAGE:String = "uiComponentGuideAddedToStage";
		public static const UICOMPONENT_GUIDE_REMOVED_FROM_STAGE:String = "uiComponentGuideRemovedFromStage";
		public static const UICOMPONENT_GUIDE_MOUSE_CLICK:String = "uiComponentGuideMouseClick";
		
		private var _data:Object;
		
		public function UIEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		public function get data():Object {
			return _data;
		}
		
		public function set data(value:Object):void {
			_data = value;
		}
	}
}