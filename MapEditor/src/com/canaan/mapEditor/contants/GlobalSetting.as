package com.canaan.mapEditor.contants
{
	public class GlobalSetting
	{
		public static var TILE_WIDTH:int = 256;
		public static var TILE_HEIGHT:int = 256;
		public static var GRID_WIDTH:int = 60;
		public static var GRID_HEIGHT:int = 40;
		public static var HALF_GRID_WIDTH:int = 30;
		public static var HALF_GRID_HEIGHT:int = 20;
		public static var THUMBNAIL_WIDTH:int = 600;
		public static var THUMBNAIL_HEIGHT:int = 400;
		
		public static var TILE_IMAGE_QUALITY:int = 90;
		public static var AREA_COLOR:int = 0xffff00;
		public static var AREA_ALPHA:Number = 0.5;
		public static var BLOCK_SIZE:int = 17;
		
		public static var BLOCK_COLOR_DICT:Object =  {
			0:0,
			1:0x88ff0000,
			2:0x88ffffff
		};
		public static var BLOCK_SHOW_COLOR_DICT:Object =  {
			0:0x8800ff00,
			1:0x88ff0000,
			2:0x88ffffff
		};
	}
}