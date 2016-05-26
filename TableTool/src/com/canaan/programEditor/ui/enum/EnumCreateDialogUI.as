/**Created by the Morn,do not modify.*/
package com.canaan.programEditor.ui.enum {
	import com.canaan.lib.component.controls.*;
	public class EnumCreateDialogUI extends Dialog {
		public var btnAccept:Button;
		public var txtName:TextInput;
		protected var uiXML:XML =
			<Dialog>
			  <Image url="png.comp.bg" x="0" y="0" sizeGrid="5,30,5,30" width="300" height="150"/>
			  <Button skin="png.comp.btn_close" x="269" y="3" name="close"/>
			  <Image url="png.comp.blank" x="0" y="0" width="269" height="26" name="drag"/>
			  <Button skin="png.comp.button" x="112" y="110" label="创建" var="btnAccept"/>
			  <Label text="枚举类名：" x="18" y="39"/>
			  <TextInput skin="png.comp.textinput" x="29" y="65" sizeGrid="5,5,5,5" width="242" height="22" var="txtName"/>
			</Dialog>;
		public function EnumCreateDialogUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}