package com.canaan.lib.map.data
{
	public class MultiLayersMapData
	{
		private var _mVo:MapVo;
		private var _fVo:MapVo;
		private var _bVos:Vector.<MapVo>;
		private var _renderWidth:Number;
		private var _renderHeight:Number;
		
		public function MultiLayersMapData()
		{
			_bVos = new Vector.<MapVo>();
		}
		
		public function initialize(value:Object):void {
			var mObj:Object = value.m;
			if (mObj != null) {
				_mVo = new MapVo();
				_mVo.id = mObj.id;
				_mVo.mapWidth = mObj.mapWidth;
				_mVo.mapHeight = mObj.mapHeight;
				_mVo.tileWidth = mObj.tileWidth;
				_mVo.tileHeight = mObj.tileHeight;
				_mVo.mapRenderWidth = _renderWidth;
				_mVo.mapRenderHeight = _renderHeight;
			}
			var fObj:Object = value.f;
			if (fObj != null) {
				_fVo = new MapVo();
				_fVo.id = fObj.id;
				_fVo.mapWidth = fObj.mapWidth;
				_fVo.mapHeight = fObj.mapHeight;
				_fVo.tileWidth = fObj.tileWidth;
				_fVo.tileHeight = fObj.tileHeight;
				_fVo.mapRenderWidth = _renderWidth;
				_fVo.mapRenderHeight = _renderHeight;
			}
			var bObjs:Array = value.b;
			if (bObjs != null) {
				var bVo:MapVo;
				for each (var bObj:Object in bObjs) {
					bVo = new MapVo();
					bVo.id = bObj.id;
					bVo.mapWidth = bObj.mapWidth;
					bVo.mapHeight = bObj.mapHeight;
					bVo.tileWidth = bObj.tileWidth;
					bVo.tileHeight = bObj.tileHeight;
					bVo.mapRenderWidth = _renderWidth;
					bVo.mapRenderHeight = _renderHeight;
					_bVos.push(bVo);
				}
			}
		}
		
		public function setRenderSize(renderWidth:Number, renderHeight:Number):void {
			_renderWidth = renderWidth;
			_renderHeight = renderHeight;
			if (_mVo != null) {
				_mVo.mapRenderWidth = renderWidth;
				_mVo.mapRenderHeight = renderHeight;
			}
			if (_fVo != null) {
				_fVo.mapRenderWidth = renderWidth;
				_fVo.mapRenderHeight = renderHeight;
			}
			for each (var bVo:MapVo in bVos) {
				bVo.mapRenderWidth = renderWidth;
				bVo.mapRenderHeight = renderHeight;
			}
		}
		
		public function hasFront():Boolean {
			return _fVo != null;
		}
		
		public function hasBackground():Boolean {
			return _bVos.length > 0;
		}
		
		public function get mVo():MapVo {
			return _mVo;
		}
		
		public function get fVo():MapVo {
			return _fVo;
		}
		
		public function get bVos():Vector.<MapVo> {
			return _bVos;
		}
	}
}