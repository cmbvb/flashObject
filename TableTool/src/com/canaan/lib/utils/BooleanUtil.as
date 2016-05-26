package com.canaan.lib.utils
{
	public class BooleanUtil
	{
		public static function toBoolean(value:Object):Boolean {
			if (value != null && value != false && value != "" && value != "null" && value != "false" && value != "undefined" && value != 0 && value != "0") {
        		return true;
        	}
        	return false;
		}
	}
}