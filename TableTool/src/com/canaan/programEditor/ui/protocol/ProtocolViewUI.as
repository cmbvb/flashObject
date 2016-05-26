/**Created by the Morn,do not modify.*/
package com.canaan.programEditor.ui.protocol {
	import com.canaan.lib.component.controls.*;
	import com.canaan.programEditor.view.protocol.ProtocolViewItem;
	public class ProtocolViewUI extends View {
		public var txtSearch:TextInput;
		public var treeProtocols:Tree;
		public var btnCreateFolder:Button;
		public var btnChangeFolder:Button;
		public var btnSave:Button;
		public var txtID:TextInput;
		public var txtDesc:TextArea;
		public var txtContent:TextArea;
		public var txtName:TextInput;
		public var btnCreateProtocol:Button;
		protected var uiXML:XML =
			<View>
			  <Box x="10" y="61">
			    <Image url="png.comp.bg2" sizeGrid="5,5,5,5" width="249" height="762" y="26"/>
			    <Label text="搜索" y="2" x="10"/>
			    <TextInput skin="png.comp.textinput" x="39" var="txtSearch" sizeGrid="5,5,5,5" width="187" height="22"/>
			    <Tree x="8" y="32" var="treeProtocols" canSelectFolder="true" width="220" height="750">
			      <ProtocolViewItem name="render" runtime="com.canaan.programEditor.view.protocol.ProtocolViewItem"/>
			      <VScrollBar skin="png.comp.vscroll" x="220" height="750" name="scrollBar"/>
			    </Tree>
			  </Box>
			  <Button skin="png.comp.button" x="10" y="10" var="btnCreateFolder" label="创建目录"/>
			  <Button skin="png.comp.button" x="100" y="10" var="btnChangeFolder" label="修改目录"/>
			  <Box x="270" y="63">
			    <Image url="png.comp.bg2" sizeGrid="5,5,5,5" width="1150" height="762" y="24" x="0"/>
			    <Label text="详细数据" x="6"/>
			    <Button skin="png.comp.button" x="1063" y="751" label="保存" var="btnSave"/>
			    <Label text="协议ID：" x="35" y="50"/>
			    <TextInput skin="png.comp.textinput" x="90" y="49" width="500" height="22" sizeGrid="5,5,5,5" var="txtID" restrict="0-9"/>
			    <Label text="协议说明：" x="23" y="119"/>
			    <TextArea skin="png.comp.textarea" x="90" y="121" sizeGrid="5,5,5,5" width="500" height="100" var="txtDesc" scrollBarSkin="png.comp.vscroll"/>
			    <Label text="协议内容：" x="23" y="233"/>
			    <TextArea skin="png.comp.textarea" x="90" y="235" sizeGrid="5,5,5,5" width="500" height="500" var="txtContent" scrollBarSkin="png.comp.vscroll"/>
			    <Label text="协议名称：" x="23" y="86"/>
			    <TextInput skin="png.comp.textinput" x="90" y="85" width="500" height="22" sizeGrid="5,5,5,5" var="txtName"/>
			  </Box>
			  <Button skin="png.comp.button" x="190" y="10" var="btnCreateProtocol" label="创建协议"/>
			  <Label text="数据操作不会直接保存，操作后务必点击“保存”按钮或按“Ctrl+S”键保存" x="1000" y="20" color="0xff0000" bold="true"/>
			</View>;
		public function ProtocolViewUI(){}
		override protected function createChildren():void {
			viewClassMap["com.canaan.programEditor.view.protocol.ProtocolViewItem"] = ProtocolViewItem;
			createView(uiXML);
		}
	}
}