/**Created by the Morn,do not modify.*/
package com.canaan.programEditor.ui.protocol {
	import com.canaan.lib.component.controls.*;
	public class ProtocolCreateDialogUI extends Dialog {
		public var btnAccept:Button;
		public var txtID:TextInput;
		public var txtDesc:TextArea;
		public var txtContent:TextArea;
		public var txtName:TextInput;
		protected var uiXML:XML =
			<Dialog>
			  <Image url="png.comp.bg" x="0" y="0" sizeGrid="5,30,5,30" width="500" height="600"/>
			  <Button skin="png.comp.btn_close" x="469" y="3" name="close"/>
			  <Image url="png.comp.blank" x="0" y="0" width="466" height="26" name="drag"/>
			  <Button skin="png.comp.button" x="212.5" y="560" label="创建" var="btnAccept"/>
			  <Label text="协议ID：" x="27" y="39"/>
			  <TextInput skin="png.comp.textinput" x="82" y="38" width="400" height="22" sizeGrid="5,5,5,5" var="txtID" restrict="0-9"/>
			  <Label text="协议说明：" x="14" y="109"/>
			  <TextArea skin="png.comp.textarea" x="81" y="111" sizeGrid="5,5,5,5" width="400" height="100" var="txtDesc" scrollBarSkin="png.comp.vscroll"/>
			  <Label text="协议内容：" x="14" y="223"/>
			  <TextArea skin="png.comp.textarea" x="81" y="225" sizeGrid="5,5,5,5" width="400" height="320" var="txtContent" scrollBarSkin="png.comp.vscroll"/>
			  <Label text="协议名称：" x="14" y="75"/>
			  <TextInput skin="png.comp.textinput" x="82" y="74" width="400" height="22" sizeGrid="5,5,5,5" var="txtName"/>
			</Dialog>;
		public function ProtocolCreateDialogUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}