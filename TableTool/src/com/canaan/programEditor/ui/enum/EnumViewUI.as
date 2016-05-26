/**Created by the Morn,do not modify.*/
package com.canaan.programEditor.ui.enum {
	import com.canaan.lib.component.controls.*;
	import com.canaan.programEditor.view.enum.EnumFieldItem;
	import com.canaan.programEditor.view.enum.EnumViewItem;
	public class EnumViewUI extends View {
		public var listEnums:List;
		public var txtSearch:TextInput;
		public var btnSave:Button;
		public var btnAddField:Button;
		public var listFields:List;
		public var btnCreate:Button;
		protected var uiXML:XML =
			<View>
			  <Box x="10" y="61">
			    <Image url="png.comp.bg2" sizeGrid="5,5,5,5" width="249" height="762" y="26"/>
			    <List x="6" y="32" repeatX="1" repeatY="30" var="listEnums">
			      <VScrollBar skin="png.comp.vscroll" x="220" y="0" name="scrollBar" width="17" height="750"/>
			      <EnumViewItem x="0" y="0" name="render" runtime="com.canaan.programEditor.view.enum.EnumViewItem"/>
			    </List>
			    <Label text="搜索" y="2" x="10"/>
			    <TextInput skin="png.comp.textinput" x="39" var="txtSearch" sizeGrid="5,5,5,5" width="187" height="22"/>
			  </Box>
			  <Box x="270" y="63">
			    <Image url="png.comp.bg2" sizeGrid="5,5,5,5" width="1150" height="762" y="24" x="0"/>
			    <Label text="详细数据" x="6"/>
			    <Button skin="png.comp.button" x="1063" y="751" label="保存" var="btnSave"/>
			    <Button skin="png.comp.button" x="10" y="32" sizeGrid="5,5,5,5" label="添加" var="btnAddField"/>
			    <List x="10" y="62" repeatX="1" repeatY="26" var="listFields">
			      <EnumFieldItem name="render" runtime="com.canaan.programEditor.view.enum.EnumFieldItem"/>
			      <VScrollBar skin="png.comp.vscroll" x="601" y="0" name="scrollBar" width="17" height="702"/>
			    </List>
			  </Box>
			  <Button skin="png.comp.button" x="10" y="10" var="btnCreate" label="创建枚举"/>
			  <Label text="数据操作不会直接保存，操作后务必点击“保存”按钮或按“Ctrl+S”键保存" x="1000" y="20" color="0xff0000" bold="true"/>
			</View>;
		public function EnumViewUI(){}
		override protected function createChildren():void {
			viewClassMap["com.canaan.programEditor.view.enum.EnumFieldItem"] = EnumFieldItem;
			viewClassMap["com.canaan.programEditor.view.enum.EnumViewItem"] = EnumViewItem;
			createView(uiXML);
		}
	}
}