package com.canaan.programEditor.view.table
{
	import com.canaan.programEditor.ui.table.TableLineItemUI;
	
	public class TableLineItem extends TableLineItemUI
	{
		private var mLineData:Object;
		
		public function TableLineItem()
		{
			super();
		}
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mLineData = value;
			lblLineID.text = mLineData["number#"];
		}
	}
}