/**Created by the Morn,do not modify.*/
package com.canaan.programEditor.ui.enum {
	import com.canaan.lib.component.controls.*;
	public class EnumFieldItemUI extends View {
		public var txtValue:TextInput;
		public var txtName:TextInput;
		public var txtDesc:TextInput;
		public var btnDelete:Button;
		protected var uiXML:XML =
			<View>
			  <Image url="png.comp.blank" x="0" y="0" width="600" height="27"/>
			  <TextInput text="0" skin="png.comp.textinput" x="3" y="2" restrict="0-9" sizeGrid="5,5,5,5" width="50" height="22" var="txtValue"/>
			  <TextInput text="TestEnum" skin="png.comp.textinput" x="56" y="2" sizeGrid="5,5,5,5" width="209" height="22" var="txtName"/>
			  <TextInput text="注释" skin="png.comp.textinput" x="267" y="2" sizeGrid="5,5,5,5" width="300" height="22" var="txtDesc"/>
			  <Button skin="png.comp.btn_close" x="569" y="3" var="btnDelete"/>
			</View>;
		public function EnumFieldItemUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}