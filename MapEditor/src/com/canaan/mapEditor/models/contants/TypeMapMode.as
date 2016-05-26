package com.canaan.mapEditor.models.contants
{
	import flash.utils.Dictionary;

	public class TypeMapMode
	{
		public static const SELECT:int = 0;
		public static const PLACE_OBJECT:int = 1;
		public static const SET_NORMAL:int = 2;
		public static const SET_ALPHA:int = 3;
		public static const SET_OBSTACLE:int = 4;
		public static const SET_AREA:int = 5;
		
		public static const BLOCK_MAP:Dictionary = new Dictionary();
		BLOCK_MAP[SET_NORMAL] = TypeMapBlock.NORMAL;
		BLOCK_MAP[SET_ALPHA] = TypeMapBlock.TRANSPARENT;
		BLOCK_MAP[SET_OBSTACLE] = TypeMapBlock.OBSTACLE;
	}
}