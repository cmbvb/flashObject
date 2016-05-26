package com.canaan.programEditor.view.table
{
	import com.canaan.programEditor.data.TableVo;
	import com.canaan.programEditor.ui.table.TableXMLViewUI;
	
	public class TableXMLView extends TableXMLViewUI
	{
		private var mTableVo:TableVo;
		
		public function TableXMLView()
		{
			super();
		}
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mTableVo = value as TableVo;
			txtXML.text = mTableVo.xmlContent;
		}
	}
}