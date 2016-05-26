/**Created by the Morn,do not modify.*/
package com.canaan.programEditor.ui.table {
	import com.canaan.lib.component.controls.*;
	import com.canaan.programEditor.view.table.TableDataView;
	import com.canaan.programEditor.view.table.TableJsonView;
	import com.canaan.programEditor.view.table.TableTextView;
	import com.canaan.programEditor.view.table.TableViewItem;
	import com.canaan.programEditor.view.table.TableXMLView;
	public class TableViewUI extends View {
		public var listTables:List;
		public var txtSearch:TextInput;
		public var viewStack:ViewStack;
		public var btnRefresh:Button;
		protected var uiXML:XML =
			<View>
			  <Box x="10" y="61">
			    <Image url="png.comp.bg2" sizeGrid="5,5,5,5" width="249" height="762" y="26"/>
			    <List x="6" y="32" repeatX="1" repeatY="30" var="listTables">
			      <TableViewItem name="render" runtime="com.canaan.programEditor.view.table.TableViewItem"/>
			      <VScrollBar skin="png.comp.vscroll" x="220" y="0" name="scrollBar" width="17" height="750"/>
			    </List>
			    <Label text="搜索" y="2" x="10"/>
			    <TextInput skin="png.comp.textinput" x="39" var="txtSearch" sizeGrid="5,5,5,5" y="0" width="187" height="22"/>
			  </Box>
			  <Box x="270" y="63">
			    <Image url="png.comp.bg2" sizeGrid="5,5,5,5" width="1150" height="762" y="24" x="0"/>
			    <Label text="详细数据" x="6"/>
			    <ViewStack x="0" y="24" var="viewStack">
			      <TableDataView x="0" runtime="com.canaan.programEditor.view.table.TableDataView" name="item0"/>
			      <TableJsonView x="0" y="0" name="item1" runtime="com.canaan.programEditor.view.table.TableJsonView"/>
			      <TableXMLView x="0" y="0" runtime="com.canaan.programEditor.view.table.TableXMLView" name="item2"/>
			      <TableTextView x="0" y="0" runtime="com.canaan.programEditor.view.table.TableTextView" name="item3"/>
			    </ViewStack>
			  </Box>
			  <Button skin="png.comp.button" x="10" y="10" var="btnRefresh" label="刷新数据表"/>
			</View>;
		public function TableViewUI(){}
		override protected function createChildren():void {
			viewClassMap["com.canaan.programEditor.view.table.TableDataView"] = TableDataView;
			viewClassMap["com.canaan.programEditor.view.table.TableJsonView"] = TableJsonView;
			viewClassMap["com.canaan.programEditor.view.table.TableTextView"] = TableTextView;
			viewClassMap["com.canaan.programEditor.view.table.TableViewItem"] = TableViewItem;
			viewClassMap["com.canaan.programEditor.view.table.TableXMLView"] = TableXMLView;
			createView(uiXML);
		}
	}
}