package com.canaan.lib.utils
{
	public class IntUtil
	{
		private static var counter:int = -10000000;
		
		public static function createUniqueId():int {
			return ++counter;
		}
	}
}