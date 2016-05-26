package com.canaan.mapEditor.models.contants
{
	import flash.utils.Dictionary;

	public class TypeUnit
	{
		public static const MONSTER:int = 2;								// 怪物
		public static const NPC:int = 4;									// NPC
		public static const GUARD:int = 5;									// 守卫
		public static const COLLECT:int = 6;								// 采集物
		public static const DECORATION:int = 10;							// 场景
		
		public static const TYPE_NAME:Dictionary = new Dictionary();
		
		TYPE_NAME[MONSTER] = "怪物";
		TYPE_NAME[NPC] = "NPC";
		TYPE_NAME[GUARD] = "守卫";
		TYPE_NAME[COLLECT] = "采集物";
		TYPE_NAME[DECORATION] = "场景装饰";
	}
}