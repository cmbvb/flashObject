package com.canaan.lib.map.data
{
	import com.canaan.lib.abstract.AbstractVo;
	import com.canaan.lib.managers.ResManager;
	import com.canaan.lib.map.constants.MapSetting;
	
	public class MapVo extends AbstractVo
	{
		public var id:String;									// id
		public var mapWidth:Number;								// 地图高
		public var mapHeight:Number;							// 地图宽
		public var mapRenderWidth:Number;						// 渲染宽度
		public var mapRenderHeight:Number;						// 渲染高度
		public var maxTileX:int;								// 最大X坐标
		public var maxTileY:int;								// 最大Y坐标
		public var tileWidth:Number;							// 切片宽度
		public var tileHeight:Number;							// 切片高度
		
		public function MapVo()
		{
			super();
		}
		
		public function get moveableWidth():Number {
			return mapWidth - mapRenderWidth;
		}
		
		public function get moveableHeight():Number {
			return mapHeight - mapRenderHeight;
		}
		
		public function get halfRenderWidth():Number {
			return mapRenderWidth / 2;
		}
		
		public function get halfRenderHeight():Number {
			return mapRenderHeight / 2;
		}
		
		public function get thumbnailRelativePath():String {
			return MapSetting.root + "thumbnails/" + id + ".jpg";
		}
		
		public function get thumbnailPath():String {
			return ResManager.formatUrl(thumbnailRelativePath); 
		}
		
		public function getTileKey(tileX:int, tileY:int):String {
			return id + "_" + tileY + "_" + tileX;
		}
		
		public function getTileRelativePath(tileX:int, tileY:int):String {
			return MapSetting.root + "tiles/" + id + "/" + tileY + "_" + tileX + ".jpg";
		}
		
		public function getTilePath(tileX:int, tileY:int):String {
			return ResManager.formatUrl(getTileRelativePath(tileX, tileY));
		}
	}
}