package mapTool.model.entities
{
	import flash.utils.Dictionary;
	
	import mapTool.model.vo.MapDataVo;
	import mapTool.model.vo.MapObjVo;

	public class ModelMap
	{
		private var mMapDataVo:MapDataVo;
		private var mMapObjArr:Dictionary;
		private var _loaderDic:Dictionary;
		
		public function ModelMap()
		{
			mMapDataVo = new MapDataVo();
		}
		
		public function set mapDataVo(value:MapDataVo):void {
			mMapDataVo = value;
		}
		
		public function get mapDataVo():MapDataVo {
			return mMapDataVo;
		}
		
		public function get mapObjArr():Dictionary {
			if (mMapObjArr == null) {
				mMapObjArr = new Dictionary();
				var i:int = 0;
				var j:int = 0;
				var mapObjVo:MapObjVo;
				for (i = 0; i < mMapDataVo.mapRow; i++) {
					mMapObjArr[i] = new Dictionary();
					for (j = 0; j < mMapDataVo.mapCol; j++) {
						mapObjVo = new MapObjVo();
						var obj:Object = _loaderDic ? _loaderDic[i][j] : null;
						if (obj) {
							mapObjVo.setdata(obj);
						} else {
							mapObjVo.walkAble = 1;
							mapObjVo.hideAble = 0;
							mapObjVo.row = i;
							mapObjVo.col = j;
						}
						mMapObjArr[i][j] = mapObjVo;
					}
				}
			}
			return mMapObjArr;
		}
		
		public function getMapObjByRowAndCol(row:int, col:int):MapObjVo {
			return mapObjArr[row][col] as MapObjVo;
		}

		public function set loaderDic(value:Dictionary):void
		{
			_loaderDic = value;
		}

		
	}
}