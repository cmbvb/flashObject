/**Created by the Morn,do not modify.*/
package com.canaan.gameEditor.ui.sound {
	import com.canaan.lib.component.controls.*;
	public class SoundImportDialogUI extends Dialog {
		public var txtID:TextInput;
		public var cboType:ComboBox;
		public var txtFile:TextInput;
		public var txtDesc:TextArea;
		public var btnSave:Button;
		public var btnPlay:Button;
		protected var uiXML:XML =
			<Dialog>
			  <Image url="png.comp.bg" x="0" y="0" sizeGrid="5,30,5,30" width="273" height="325"/>
			  <Image url="png.comp.blank" x="0" y="0" width="240" height="26" name="drag"/>
			  <Button skin="png.comp.btn_close" x="242" y="3" name="close"/>
			  <Label text="编号：" x="11" y="37"/>
			  <TextInput skin="png.comp.textinput" x="54" y="36" width="200" height="22" sizeGrid="10,10,10,10" var="txtID"/>
			  <Label text="类型：" x="11" y="65"/>
			  <ComboBox labels="音乐,音效" skin="png.comp.combobox" x="54" y="64" width="200" height="23" sizeGrid="10,10,50,10" selectedIndex="1" var="cboType"/>
			  <Label text="文件：" x="11" y="94"/>
			  <TextInput skin="png.comp.textinput" x="54" y="93" width="200" sizeGrid="10,10,10,10" var="txtFile" editable="true"/>
			  <Label text="备注：" x="11" y="123"/>
			  <TextArea skin="png.comp.textarea" x="54" y="122" width="200" height="150" scrollBarSkin="png.comp.vscroll" sizeGrid="10,10,10,10" var="txtDesc"/>
			  <HBox x="94" y="285" space="10">
			    <Button skin="png.comp.button" x="101" var="btnSave" label="保存"/>
			    <Button skin="png.comp.button" y="0" var="btnPlay" label="播放" x="0"/>
			  </HBox>
			</Dialog>;
		public function SoundImportDialogUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}