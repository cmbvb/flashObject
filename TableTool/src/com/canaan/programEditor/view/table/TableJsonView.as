package com.canaan.programEditor.view.table
{
	import com.canaan.programEditor.data.TableVo;
	import com.canaan.programEditor.ui.table.TableJsonViewUI;
	
	public class TableJsonView extends TableJsonViewUI
	{
		private var mTableVo:TableVo;
		
		public function TableJsonView()
		{
			super();
		}
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mTableVo = value as TableVo;
			txtJson.text = mTableVo.jsonContent;
		}
	}
}