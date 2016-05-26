/**Created by the Morn,do not modify.*/
package com.canaan.programEditor.ui.table {
	import com.canaan.lib.component.controls.*;
	import com.canaan.programEditor.view.table.TableLineDataItem;
	import com.canaan.programEditor.view.table.TableLineItem;
	public class TableDataViewUI extends View {
		public var listLines:List;
		public var txtSearch:TextInput;
		public var listLineDatas:List;
		protected var uiXML:XML =
			<View>
			  <Box x="7" y="13">
			    <Image url="png.comp.bg2" sizeGrid="5,5,5,5" width="189" height="688" y="34" x="0"/>
			    <List x="6" y="40" repeatX="1" repeatY="27" var="listLines">
			      <VScrollBar skin="png.comp.vscroll" x="160" y="0" name="scrollBar" width="17" height="675"/>
			      <TableLineItem x="0" y="0" name="render" runtime="com.canaan.programEditor.view.table.TableLineItem"/>
			    </List>
			    <Label text="搜索" y="2"/>
			    <TextInput skin="png.comp.textinput" x="30" var="txtSearch"/>
			  </Box>
			  <Box x="219" y="46">
			    <Image url="png.comp.bg2" sizeGrid="5,5,5,5" width="922" height="688"/>
			    <List x="6" y="7" var="listLineDatas" spaceY="2" repeatX="1" repeatY="26">
			      <TableLineDataItem name="render" runtime="com.canaan.programEditor.view.table.TableLineDataItem"/>
			      <VScrollBar skin="png.comp.vscroll" x="893" y="0" width="17" height="674" name="scrollBar"/>
			    </List>
			  </Box>
			</View>;
		public function TableDataViewUI(){}
		override protected function createChildren():void {
			viewClassMap["com.canaan.programEditor.view.table.TableLineDataItem"] = TableLineDataItem;
			viewClassMap["com.canaan.programEditor.view.table.TableLineItem"] = TableLineItem;
			createView(uiXML);
		}
	}
}