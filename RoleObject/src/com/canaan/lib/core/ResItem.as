package com.canaan.lib.core
{
	public class ResItem
	{
		public var url:String;
		public var id:String;
		public var name:String;
		public var completeHandlers:Vector.<Method>;
		public var progressHandlers:Vector.<Method>;
		public var cacheContent:Boolean;
		public var priority:int;
		public var bytesLoaded:int;
		public var bytesTotal:int;
		
		public function ResItem(url:String = "", id:String = "", name:String = "", completeHandlers:Vector.<Method> = null, progressHandlers:Vector.<Method> = null, cacheContent:Boolean = true, priority:int = 2)
		{
			this.url = url;
			this.id = id || url;
			this.name = name || url;
			this.completeHandlers = completeHandlers || new Vector.<Method>();
			this.progressHandlers = progressHandlers || new Vector.<Method>();
			this.cacheContent = cacheContent;
			this.priority = priority;
		}
		
		public function removeCompleteHandler(method:Method):void {
			var index:int = completeHandlers.indexOf(method);
			if (index != -1) {
				completeHandlers.splice(index, 1);
			}
		}
		
		public function get progress():Number {
			if (bytesTotal == 0) {
				return 0;
			}
			return bytesLoaded / bytesTotal;
		}
	}
}