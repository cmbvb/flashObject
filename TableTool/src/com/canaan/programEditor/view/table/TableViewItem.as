package com.canaan.programEditor.view.table
{
	import com.canaan.programEditor.constants.TypeTable;
	import com.canaan.programEditor.data.TableVo;
	import com.canaan.programEditor.ui.table.TableViewItemUI;
	
	public class TableViewItem extends TableViewItemUI
	{
		private var mTableVo:TableVo;
		
		public function TableViewItem()
		{
			super();
		}
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mTableVo = value as TableVo;
			lblType.text = TypeTable.TABLE_NAME[mTableVo.type];
			lblTableName.text = mTableVo.name;
		}
	}
}