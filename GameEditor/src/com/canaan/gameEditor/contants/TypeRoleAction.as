package com.canaan.gameEditor.contants
{
	/**
	 * 角色动作
	 * @author xujianan
	 * 
	 */	
	public class TypeRoleAction
	{
		public static const IDLE:int = 1;										// 空闲
		public static const WALK:int = 2;										// 行走
		public static const RUN:int = 3;										// 跑步
		public static const ATTACK:int = 4;										// 攻击
		public static const SKILL:int = 5;										// 技能
		public static const BE_ATTACK:int = 6;									// 受伤
		public static const DEAD:int = 7;										// 死亡
		public static const PREPARE:int = 8;									// 备战
		public static const COLLECT:int = 9;									// 采集
		public static const MEDITATION:int = 10;								// 打坐
		public static const CRIT:int = 11;										// 暴击
		
		public static const BASE_DIRECTION:Object = {
			1:"上",
			2:"右上",
			3:"右",
			4:"右下",
			5:"下",
			6:"左下",
			7:"左",
			8:"左上"
		};
	}
}