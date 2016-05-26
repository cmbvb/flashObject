package com.canaan.mapEditor.models.entities
{
	import com.canaan.lib.core.TableConfig;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.mapEditor.core.GameRes;
	import com.canaan.mapEditor.events.GlobalEvent;
	import com.canaan.mapEditor.models.contants.TypeUnit;
	import com.canaan.mapEditor.models.events.ModelUnitEvent;
	import com.canaan.mapEditor.models.vo.table.UnitTempleConfigVo;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class ModelUnit extends EventDispatcher
	{
		private var _unitDict:Dictionary;
		
		public function ModelUnit()
		{
			super();
			initialize();
		}
		
		private function initialize():void {
			EventManager.getInstance().addEventListener(GlobalEvent.UPDATE_CONFIG, onUpdateConfig);
			initUnits();
		}
		
		private function onUpdateConfig(event:GlobalEvent):void {
			initUnits();
		}
		
		private function initUnits():void {
			_unitDict = new Dictionary();
			var configs:Dictionary = TableConfig.getConfig(GameRes.TBL_UNIT);
			for each (var config:UnitTempleConfigVo in configs) {
				if (TypeUnit.TYPE_NAME[config.type]) {
					if (_unitDict[config.type] == null) {
						_unitDict[config.type] = new Dictionary();
					}
					if (_unitDict[config.type][config.editdir] == null) {
						_unitDict[config.type][config.editdir] = [];
					}
					_unitDict[config.type][config.editdir].push(config);
				}
			}
			
			for each (var editDict:Dictionary in _unitDict) {
				for each (var units:Array in editDict) {
					units.sortOn("id", Array.NUMERIC);
				}
			}
			
			dispatchEvent(new ModelUnitEvent(ModelUnitEvent.UPDATE_UNIT));
		}
		
		public function get unitDict():Dictionary {
			return _unitDict;
		}
	}
}