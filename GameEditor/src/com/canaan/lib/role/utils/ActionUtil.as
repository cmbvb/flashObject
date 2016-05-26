package com.canaan.lib.role.utils
{
	import com.canaan.lib.core.BytesLoader;
	import com.canaan.lib.core.Method;
	
	import flash.utils.ByteArray;

	public class ActionUtil
	{
		/**
		 * 分析加载的流数据
		 * @param bytes
		 * @return 
		 * 
		 */		
		public static function analysis(bytes:ByteArray):Object {
			var lengthHeadData:int = bytes.readInt();
			var lengthSWF:int = bytes.readInt();
			var headDataBytes:ByteArray = new ByteArray();
			var swfBytes:ByteArray = new ByteArray();
			bytes.readBytes(headDataBytes, 0, lengthHeadData);
			bytes.readBytes(swfBytes, 0, lengthSWF);
			var headData:Object = headDataBytes.readObject();
			return {headData:headData, swfBytes:swfBytes};
		}
		
		/**
		 * 提取并加载流数据中的资源
		 * @param bytes
		 * @param callback
		 * 
		 */		
		public static function extract(bytes:ByteArray, callback:Method):void {
			var bytesLoader:BytesLoader = new BytesLoader();
			bytesLoader.load(bytes, callback, true);
		}
	}
}