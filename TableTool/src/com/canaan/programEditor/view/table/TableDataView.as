package com.canaan.programEditor.view.table
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.utils.StringUtil;
	import com.canaan.programEditor.data.TableVo;
	import com.canaan.programEditor.event.GlobalEvent;
	import com.canaan.programEditor.ui.table.TableDataViewUI;
	
	import flash.events.Event;
	
	public class TableDataView extends TableDataViewUI
	{
		private var mFilterKeywords:String;
		private var mTableVo:TableVo;
		
		public function TableDataView()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			txtSearch.addEventListener(Event.CHANGE, onTextChange);
			listLines.selectHandler = new Method(onLineSelect);
		}
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mTableVo = value as TableVo;
			refreshList();
		}
		
		private function onLineSelect(index:int):void {
			if (index == -1) {
				listLineDatas.selectedIndex = -1;
				listLineDatas.array = null;
				return;
			}
			var array:Array = [];
			var lineData:Object = listLines.array[index];
			var obj:Object;
			for (var i:int = 0; i < mTableVo.tblFields.length; i++) {
				obj = {};
				obj.title = mTableVo.tblFields[i];
				obj.desc = mTableVo.tblDescs[i];
				obj.type = mTableVo.tblTypes[i];
				obj.value = lineData[obj.title];
				array.push(obj);
			}
			listLineDatas.array = array;
		}
		
		private function onTextChange(event:Event):void {
			mFilterKeywords = StringUtil.trim(txtSearch.text);
			refreshList();
		}
		
		private function refreshList(event:GlobalEvent = null):void {
			var tblDatas:Array = mTableVo.tblDatas.concat();
			if (mFilterKeywords) {
				tblDatas = tblDatas.filter(filterFunc);
			}
			tblDatas.sortOn("number#", Array.NUMERIC);
			listLines.array = tblDatas;
			onLineSelect(listLines.selectedIndex);
		}
		
		private function filterFunc(element:*, index:int, arr:Array):Boolean {
			if (element.id.toString().indexOf(mFilterKeywords) == -1) {
				return false;
			}
			return true;
		}
	}
}