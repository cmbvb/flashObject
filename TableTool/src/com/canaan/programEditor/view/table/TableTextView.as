package com.canaan.programEditor.view.table
{
	import com.canaan.programEditor.data.TableVo;
	import com.canaan.programEditor.ui.table.TableTextViewUI;
	
	public class TableTextView extends TableTextViewUI
	{
		private var mTableVo:TableVo;
		
		public function TableTextView()
		{
			super();
		}
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mTableVo = value as TableVo;
			txtText.text = mTableVo.content;
		}
	}
}