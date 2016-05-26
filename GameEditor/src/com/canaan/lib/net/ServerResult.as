package com.canaan.lib.net
{
	public class ServerResult
	{
		private var mData:Object;
		
		public function ServerResult(data:Object = null)
		{
			setData(data);
		}
		
		public function setData(data:Object):void {
			mData = data;
		}
		
		public function get protocol():* {
			return mData.protocol;
		}
		
		public function get error():* {
			return mData.error;
		}
		
		public function get data():Object {
			return mData.data;
		}
		
		public function get success():Boolean {
			return error == 0;
		}
	}
}