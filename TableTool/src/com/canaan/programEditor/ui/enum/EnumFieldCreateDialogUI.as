/**Created by the Morn,do not modify.*/
package com.canaan.programEditor.ui.enum {
	import com.canaan.lib.component.controls.*;
	public class EnumFieldCreateDialogUI extends Dialog {
		public var btnAccept:Button;
		public var txtField:TextInput;
		public var txtValue:TextInput;
		public var txtDesc:TextInput;
		protected var uiXML:XML =
			<Dialog>
			  <Image url="png.comp.bg" x="0" y="0" sizeGrid="5,30,5,30" width="300" height="200"/>
			  <Button skin="png.comp.btn_close" x="269" y="3" name="close"/>
			  <Image url="png.comp.blank" x="0" y="0" width="266" height="26" name="drag"/>
			  <Button skin="png.comp.button" x="112" y="155" label="创建" var="btnAccept"/>
			  <Label text="字段名：" x="28" y="42"/>
			  <TextInput skin="png.comp.textinput" x="82" y="42" sizeGrid="5,5,5,5" width="190" height="22" var="txtField"/>
			  <Label text="枚举值：" x="28" y="72"/>
			  <TextInput skin="png.comp.textinput" x="82" y="72" sizeGrid="5,5,5,5" width="190" height="22" var="txtValue" restrict="0-9"/>
			  <Label text="备注：" x="40" y="103"/>
			  <TextInput skin="png.comp.textinput" x="82" y="103" sizeGrid="5,5,5,5" width="190" height="22" var="txtDesc"/>
			</Dialog>;
		public function EnumFieldCreateDialogUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}