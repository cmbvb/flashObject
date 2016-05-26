package com.canaan.lib.algorithm.behaviorTree.constants
{
	/**
	 * 节点运行状态
	 * @author Administrator
	 * 
	 */	
	public class BevRunningStatus
	{
		public static const EXECUTING:int = 0;										// 运行中
		public static const FINISH:int = 1;											// 运行完成
		public static const ERROR_TRANSITION:int = -1;								// 转换错误
	}
}