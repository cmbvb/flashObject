package com.canaan.gameEditor.utils
{
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;

	public class GlobalEffect
	{
		/**
		 * 根据颜色创建发光滤镜
		 * @param color
		 * @return 
		 * 
		 */		
		public static function createColorFilter(color:uint):GlowFilter {
			return new GlowFilter(color, 0.5, 5, 5, 2);
		}
		
		/**
		 * 灰度滤镜
		 */		
		public static const GRAY_FILTER:ColorMatrixFilter = new ColorMatrixFilter([	
			0.3086,	0.6094, 0.0820, 0,	0,
			0.3086, 0.6094, 0.0820, 0,	0,
			0.3086, 0.6094, 0.0820, 0,	0,
			0,		0,		0,		1,	0
		]);
		
		/**
		 * 高亮滤镜
		 */		
		public static const HIGHT_LIGHT_FILTER:ColorMatrixFilter = new ColorMatrixFilter([
			1,	0,	0,	0,	50, 
			0,	1,	0,	0,	50, 
			0,	0,	1,	0,	50, 
			0,	0,	0,	1,	0
		]);
		
		/**
		 * 选中滤镜
		 */		
		public static const SELECT_FILTER:GlowFilter = new GlowFilter(0xFFCC00, 1, 5, 5, 3);
		
		/**
		 * 警告滤镜
		 */		
		public static const WARING_FILTER:ColorMatrixFilter = new ColorMatrixFilter([
			1,	1,	1,	1,	100, 
			0,	1,	0,	0,	0, 
			0,	0,	1,	0,	0, 
			0,	0,	0,	1,	0
		]);
	}
}