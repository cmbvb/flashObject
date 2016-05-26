package com.canaan.programEditor.view.table
{
	import com.canaan.programEditor.ui.table.TableLineDataItemUI;
	
	public class TableLineDataItem extends TableLineDataItemUI
	{
		private var mLineData:Object;
		
		public function TableLineDataItem()
		{
			super();
		}
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mLineData = value;
			lblType.text = mLineData.type;
			lblName.text = mLineData.title + "(" + mLineData.desc + ")";
			lblContent.text = mLineData.value.toString();
		}
	}
}