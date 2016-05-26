package com.canaan.lib.map
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.display.BaseSprite;
	import com.canaan.lib.managers.ResManager;
	import com.canaan.lib.map.constants.MapSetting;
	import com.canaan.lib.map.data.MultiLayersMapData;
	
	import flash.geom.Point;

	public class MultiLayersMap
	{
		/**
		 * 后景层
		 */		
		protected var _containerB:BaseSprite;
		
		/**
		 * 中景层
		 */		
		protected var _containerM:BaseSprite;
		
		/**
		 * 前景层
		 */		
		protected var _containerF:BaseSprite;
		
		/**
		 * 便宜坐标
		 */		
		protected var _offset:Point;
		
		/**
		 * 地图数据
		 */		
		protected var _mapData:MultiLayersMapData;
		
		/**
		 * 后景
		 */		
		protected var mapBs:Vector.<Map>;
		
		/**
		 * 中景map
		 */		
		protected var mapM:Map;
		
		/**
		 * 前景map
		 */		
		protected var mapF:Map;
		
		/**
		 * 渲染宽度
		 */		
		protected var renderWidth:Number;
		
		/**
		 * 渲染高度
		 */		
		protected var renderHeight:Number;
		
		/**
		 * 限制区域起始X坐标
		 */		
		protected var rangeStartX:Number;
		
		/**
		 * 限制区域起始Y坐标
		 */		
		protected var rangeStartY:Number;
		
		/**
		 * 限制区域结束X坐标
		 */		
		protected var rangeEndX:Number;
		
		/**
		 * 限制区域结束Y坐标
		 */		
		protected var rangeEndY:Number;
		
		/**
		 * 延迟响应的函数
		 */		
		protected var callLaters:Vector.<Method>;
		
		public function MultiLayersMap()
		{
			_containerB = new BaseSprite();
			_containerM = new BaseSprite();
			_containerF = new BaseSprite();
			_offset = new Point();
			mapBs = new Vector.<Map>();
			callLaters = new Vector.<Method>();
		}
		
		/**
		 * 设置渲染尺寸
		 * @param renderWidth
		 * @param renderHeight
		 * 
		 */		
		public function setRenderSize(renderWidth:Number, renderHeight:Number):void {
			this.renderWidth = renderWidth;
			this.renderHeight = renderHeight;
			if (_mapData) {
				_mapData.setRenderSize(renderWidth, renderHeight);
			}
		}
		
		/**
		 * 设置显示区域限制
		 * @param rangeStartX
		 * @param rangeStartY
		 * @param rangeEndX
		 * @param rangeEndY
		 * 
		 */			
		public function setRange(rangeStartX:Number, rangeStartY:Number, rangeEndX:Number, rangeEndY:Number):void {
			if (isNaN(rangeStartX) || isNaN(rangeStartY) || isNaN(rangeEndX) || isNaN(rangeEndY)) {
				return;
			}
			if (_mapData == null) {
				callLaters.push(new Method(setRange, [rangeStartX, rangeStartY, rangeEndX, rangeEndY]));
				return;
			}
			rangeStartX = rangeStartX;
			this.rangeStartY = rangeStartY;
			this.rangeEndX = rangeEndX;
			this.rangeEndY = rangeEndY;
			if (mapM) {
				mapM.setRange(rangeStartX, rangeStartY, rangeEndX, rangeEndY);
			}
			if (mapF) {
				mapF.setRange(rangeStartX, rangeStartY, rangeEndX, rangeEndY);
			}
		}
		
		/**
		 * 设置偏移
		 * @param offset
		 * 
		 */		
		public function setOffset(offsetX:Number, offsetY:Number):void {
			_offset.setTo(offsetX, offsetY);
			refreshContainerPosition();
		}
		
		/**
		 * 初始化
		 * @param mapId
		 * 
		 */		
		public function initialize(mapId:String):void {
			_containerB.removeAllChildren();
			_containerM.removeAllChildren();
			_containerF.removeAllChildren();
			mapM = null;
			mapF = null;
			mapBs.length = 0;
			_mapData = null;
			var fileName:String = mapId + ".mapdata";
			ResManager.getInstance().loadAsync(MapSetting.root + "maps/" + fileName, "", "", new Method(loadMapDataComplete));
		}
		
		protected function loadMapDataComplete(content:*):void {
			_mapData = new MultiLayersMapData();
			_mapData.setRenderSize(renderWidth, renderHeight);
			_mapData.initialize(content);
			if (_mapData.mVo) {
				mapM = new Map();
				mapM.initialize(_mapData.mVo);
				_containerM.addChild(mapM.drawBuffer);
				_containerM.addChild(mapM.animation);
			}
			if (_mapData.fVo) {
				mapF = new Map();
				mapF.initialize(_mapData.fVo);
				_containerF.addChild(mapF.drawBuffer);
				_containerF.addChild(mapF.animation);
			}
			var mapB:Map;
			for (var i:int = _mapData.bVos.length - 1; i >= 0; i--) {
				mapB = new Map();
				mapB.initialize(_mapData.bVos[i]);
				_containerB.addChild(mapB.drawBuffer);
				_containerB.addChild(mapB.animation);
				mapBs.push(mapB);
			}
			refreshContainerPosition();
			for each (var method:Method in callLaters) {
				method.apply();
			}
			callLaters.length = 0;
		}
		
		protected function refreshContainerPosition():void {
			_containerB.moveTo(_offset.x, _offset.y);
			_containerM.moveTo(_offset.x, _offset.y);
			if (_mapData.fVo) {
				_containerF.moveTo(_offset.x ,_offset.y + _mapData.mVo.mapHeight - _mapData.fVo.mapHeight);
			}
		}
		
		public function moveTo(x:Number, y:Number):void {
			if (_mapData == null) {
				callLaters.push(new Method(moveTo, [x, y]));
				return;
			}
			if (mapM) {
				mapM.moveTo(x, y);
			}
			if (mapF) {
				mapF.moveTo(x, y);
			}
			for each (var mapB:Map in mapBs) {
				if (mapM) {
					var tmpX:Number = mapM.center.x - mapM.mapVo.halfRenderWidth;
					var bOffsetX:Number = mapM.mapVo.halfRenderWidth + mapB.mapVo.moveableWidth / mapM.mapVo.moveableWidth * tmpX;
					mapB.moveTo(bOffsetX, y);
				}
			}
		}
		
		public function moveToOffset(offsetX:Number, offsetY:Number):void {
			if (_mapData == null) {
				callLaters.push(new Method(moveToOffset, [offsetX, offsetY]));
				return;
			}
			if (mapM) {
				mapM.moveToOffset(offsetX, offsetY);
			}
			if (mapF) {
				mapF.moveToOffset(offsetX, offsetY);
			}
			for each (var mapB:Map in mapBs) {
				if (mapM) {
					var bOffsetX:Number = mapB.mapVo.moveableWidth / mapM.mapVo.moveableWidth * offsetX;
					mapB.moveToOffset(bOffsetX, offsetY);
				}
			}
		}
		
		public function resize():void {
			if (_mapData == null) {
				callLaters.push(new Method(resize));
				return;
			}
			if (mapM) {
				mapM.resize();
			}
			if (mapF) {
				mapF.resize();
			}
			for each (var mapB:Map in mapBs) {
				mapB.resize();
			}
			refreshContainerPosition();
		}
		
		public function get center():Point {
			return mapM.center;
		}
		
		public function get leftTop():Point {
			return mapM.leftTop;
		}

		public function get containerB():BaseSprite {
			return _containerB;
		}
		
		public function get containerM():BaseSprite {
			return _containerM;
		}
		
		public function get containerF():BaseSprite {
			return _containerF;
		}
		
		public function get mapData():MultiLayersMapData {
			return _mapData;
		}
	}
}