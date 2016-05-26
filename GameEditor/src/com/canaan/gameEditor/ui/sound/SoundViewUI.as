/**Created by the Morn,do not modify.*/
package com.canaan.gameEditor.ui.sound {
	import com.canaan.lib.component.controls.*;
	import com.canaan.gameEditor.view.sound.SoundViewItem;
	public class SoundViewUI extends View {
		public var btnImport:Button;
		public var listSounds:List;
		public var txtSearch:TextInput;
		public var container:Box;
		public var txtID:TextInput;
		public var cboType:ComboBox;
		public var txtFile:TextInput;
		public var txtDesc:TextArea;
		public var btnSave:Button;
		public var btnPlay:Button;
		public var btnStop:Button;
		public var btnSaveAll:Button;
		protected var uiXML:XML =
			<View width="1430" height="860">
			  <Button skin="png.comp.button" x="10" y="10" label="导入音频" var="btnImport"/>
			  <Box x="10" y="64">
			    <Image url="png.comp.bg2" y="26" sizeGrid="5,5,5,5" width="226" height="761" x="0"/>
			    <List x="6" y="32" repeatX="1" repeatY="30" var="listSounds">
			      <SoundViewItem name="render" y="0" runtime="com.canaan.gameEditor.view.sound.SoundViewItem"/>
			      <VScrollBar skin="png.comp.vscroll" x="197" width="17" height="750" name="scrollBar"/>
			    </List>
			    <TextInput skin="png.comp.textinput" x="30" width="171" height="22" var="txtSearch"/>
			    <Label text="搜索"/>
			  </Box>
			  <Box x="257" y="64" var="container">
			    <Label text="音频信息" x="3"/>
			    <Image url="png.comp.bg2" y="26" sizeGrid="5,5,5,5" width="1165" height="761" x="0"/>
			    <Label text="编号：" x="10" y="38"/>
			    <TextInput skin="png.comp.textinput" x="53" y="38" width="200" height="22" sizeGrid="10,10,10,10" var="txtID" editable="false"/>
			    <Label text="类型：" x="10" y="67"/>
			    <ComboBox labels="音乐,音效" skin="png.comp.combobox" x="53" y="66" width="200" height="23" sizeGrid="10,10,50,10" selectedIndex="1" var="cboType"/>
			    <Label text="文件：" x="10" y="96"/>
			    <TextInput skin="png.comp.textinput" x="53" y="95" width="200" sizeGrid="10,10,10,10" var="txtFile" editable="false"/>
			    <Label text="备注：" x="10" y="125"/>
			    <TextArea skin="png.comp.textarea" x="53" y="124" width="200" height="150" scrollBarSkin="png.comp.vscroll" sizeGrid="10,10,10,10" var="txtDesc" editable="false"/>
			    <HBox x="9" y="290" space="10">
			      <Button skin="png.comp.button" x="101" var="btnSave" label="保存" visible="false"/>
			      <Button skin="png.comp.button" y="0" var="btnPlay" label="播放" x="0"/>
			      <Button skin="png.comp.button" y="0" var="btnStop" label="停止" x="0"/>
			    </HBox>
			  </Box>
			  <Button skin="png.comp.button" x="95" y="10" label="保存全部" var="btnSaveAll"/>
			</View>;
		public function SoundViewUI(){}
		override protected function createChildren():void {
			viewClassMap["com.canaan.gameEditor.view.sound.SoundViewItem"] = SoundViewItem;
			createView(uiXML);
		}
	}
}