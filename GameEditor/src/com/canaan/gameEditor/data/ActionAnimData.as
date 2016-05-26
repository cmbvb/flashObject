package com.canaan.gameEditor.data
{
	import com.canaan.gameEditor.cfg.ActionTypeConfigVo;
	import com.canaan.gameEditor.core.GameRes;
	import com.canaan.lib.core.SysConfig;
	import com.canaan.lib.utils.ObjectUtil;
	
	import flash.utils.Dictionary;

	public class ActionAnimData
	{
		private var _actionId:int;
		private var _sequences:Dictionary;
		
		public function ActionAnimData()
		{
			_sequences = new Dictionary();
		}
		
		public function get actionTypeConfig():ActionTypeConfigVo {
			return SysConfig.getConfigVo(GameRes.TBL_ACTION_TYPE, _actionId) as ActionTypeConfigVo;
		}
		
		public function merge(animData:ActionAnimData):void {
			for each (var ts:ActionAnimSequence in animData.sequences) {
				var s:ActionAnimSequence = _sequences[ts.direction];
				if (s == null) {
					_sequences[ts.direction] = s = new ActionAnimSequence();
				}
				s.bitmapDatas.concat(ts.bitmapDatas);
			}
		}
		
		public function hasSequences():Boolean {
			return ObjectUtil.count(_sequences) > 0;
		}
		
		public function get actionId():int
		{
			return _actionId;
		}
		
		public function set actionId(value:int):void
		{
			_actionId = value;
		}

		public function get sequences():Dictionary
		{
			return _sequences;
		}

		public function set sequences(value:Dictionary):void
		{
			_sequences = value;
		}
	}
}