package com.canaan.lib.role.utils
{
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
	}
}