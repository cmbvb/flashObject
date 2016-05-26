package com.canaan.mapEditor.models.contants
{
	/**
	 * 地图功能类型
	 * @author xujianan
	 * 
	 */	
	public class TypeMapFunction
	{
		public static const CANT_ATTACK:int = 1;											// 不可攻击
		public static const CANT_CROSS_PLAYER:int = 2;										// 不可穿人
		public static const CANT_CROSS_MONSTER:int = 3;										// 不可穿怪
		public static const CANT_RIDING:int = 4;											// 不可骑乘
		public static const CAN_STALL:int = 5;												// 允许摆摊
		public static const CANT_USE_SKILL:int = 6;											// 不可使用指定技能
		public static const CANT_USE_ITEM:int = 7;											// 不可使用指定道具
		public static const TRANSFER:int = 8;												// 传送
		public static const PLAY_AUDIO_MUSIC:int = 9;										// 播放音乐
		public static const PLAY_AUDIO_EFFECT:int = 10;										// 播放音效
		public static const SHOW_MESSAGE:int = 11;											// 提示信息
		public static const PROHIBIT_SKILL:int = 12;										// 不可使用技能
		public static const CANT_MOVE:int = 13;												// 不可移动
		public static const CANT_DROP:int = 14;												// 不可丢弃
		public static const CANT_RELIVE:int = 15;											// 不可原地复活
		public static const CANT_DEAD_DROP:int = 16;										// 死亡不掉落物品
		public static const PK_AREA:int = 17;												// PK区域
		public static const RED_AREA:int = 18;												// 红名区
		public static const CANT_AUTO_FIGHT:int = 19;										// 禁止自动挂机
		public static const CANT_TEAM_TRANSFER:int = 20;									// 禁止天人合一技能
	}
}