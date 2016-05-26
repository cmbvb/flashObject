package com.canaan.lib.core
{
	public class ResItem
	{
		public var url:String;
		public var id:String;
		public var name:String;
		public var completeHandler:Method;
		public var progressHandler:Method;
		
		public function ResItem(url:String, id:String = "", name:String = "", completeHandler:Method = null, progressHandler:Method = null)
		{
			this.url = url;
			this.id = id || url;
			this.name = name;
			this.completeHandler = completeHandler;
			this.progressHandler = progressHandler;
		}
	}
}