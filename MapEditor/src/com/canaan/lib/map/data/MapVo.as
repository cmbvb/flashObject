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
		public var tileWidth:Number;							// 切片宽度
		public var tileHeight:Number;							// 切片高度
		public var hasAnimation:Boolean;						// 是否有动画
		
		public function MapVo()
		{
			super();
		}
		
		public function get maxTileX():int {
			return Math.ceil(mapWidth / tileWidth);
		}
		
		public function get maxTileY():int {
			return Math.ceil(mapHeight / tileHeight);
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
		
		public function get thumbnailPath():String {
			var fileName:String = id + ".jpg";
			return ResManager.formatUrl(MapSetting.root + "images/thumbnails/" + fileName); 
		}
		
		public function get animationPath():String {
			var fileName:String = id + ".swf";
			return ResManager.formatUrl(MapSetting.root + "animations/" + fileName);
		}
		
		public function getTileKey(tileX:int, tileY:int):String {
			return id + "_" + tileX + "_" + tileY;
		}
		
		public function getTilePath(tileX:int, tileY:int):String {
			var fileName:String = tileX + "_" + tileY + ".jpg";
			return ResManager.formatUrl(MapSetting.root + "images/tiles/" + id + "/" + fileName);
		}
	}
}