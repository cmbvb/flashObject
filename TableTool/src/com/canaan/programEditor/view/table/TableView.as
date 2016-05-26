package com.canaan.programEditor.view.table
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.utils.StringUtil;
	import com.canaan.programEditor.core.DataCenter;
	import com.canaan.programEditor.data.TableVo;
	import com.canaan.programEditor.event.GlobalEvent;
	import com.canaan.programEditor.ui.table.TableViewUI;
	
	import flash.events.Event;
	
	public class TableView extends TableViewUI
	{
		private var mFilterKeywords:String;
		
		public function TableView()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			btnRefresh.clickHandler = new Method(onRefresh);
			txtSearch.addEventListener(Event.CHANGE, onTextChange);
			listTables.selectHandler = new Method(onTablesSelect);
		}
		
		public function onShow():void {
			listTables.array = DataCenter.tables;
			listTables.selectedIndex = 0;
			EventManager.getInstance().addEventListener(GlobalEvent.REFRESH_PATH, refreshPath);
		}
		
		public function onHide():void {
			EventManager.getInstance().removeEventListener(GlobalEvent.REFRESH_PATH, refreshPath);
		}
		
		private function onRefresh():void {
			refreshPath();
		}
		
		private function onTablesSelect(index:int):void {
			var tableVo:TableVo = listTables.selectedItem as TableVo;
			if (tableVo) {
				viewStack.visible = true;
				var vsIndex:int;
				if (tableVo.isTable) {
					vsIndex = 0;
				} else if (tableVo.isJson) {
					vsIndex = 1;
				} else if (tableVo.isXML) {
					vsIndex = 2;
				} else {
					vsIndex = 3;
				}
				viewStack.setIndexHandler.applyWith([vsIndex]);
				Object(viewStack.selection).dataSource = tableVo;
			} else {
				viewStack.visible = false;
			}
		}
		
		private function refreshPath(event:GlobalEvent = null):void {
			DataCenter.readTables();
			var tables:Array = DataCenter.tables.concat();
			if (mFilterKeywords) {
				tables = tables.filter(filterFunc);
			}
			tables.sortOn("type", Array.NUMERIC);
			listTables.array = tables;
			onTablesSelect(listTables.selectedIndex);
		}
		
		private function onTextChange(event:Event):void {
			mFilterKeywords = StringUtil.trim(txtSearch.text);
			refreshPath();
		}
		
		private function filterFunc(element:*, index:int, arr:Array):Boolean {
			var tableVo:TableVo = element as TableVo;
			if (tableVo.name.indexOf(mFilterKeywords) == -1) {
				return false;
			}
			return true;
		}
	}
}