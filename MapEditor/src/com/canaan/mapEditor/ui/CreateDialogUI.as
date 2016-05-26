/**Created by the Morn,do not modify.*/
package com.canaan.mapEditor.ui {
	import com.canaan.lib.component.controls.*;
	public class CreateDialogUI extends Dialog {
		public var btnClose:Button;
		public var txtResName:TextInput;
		public var btnSelect:Button;
		public var btnCreate:Button;
		public var txtMapName:TextInput;
		protected var uiXML:XML =
			<Dialog>
			  <Image url="png.comp.bg" x="0" y="0" sizeGrid="5,30,5,30" width="400" height="300"/>
			  <Image url="png.comp.blank" x="0" y="1" width="368" height="26" name="drag"/>
			  <Button skin="png.comp.btn_close" x="369" y="3" var="btnClose" name="close"/>
			  <Label text="选择地图：" x="14" y="89"/>
			  <TextInput skin="png.comp.textinput" x="80" y="88" var="txtResName" width="228" height="22"/>
			  <Button skin="png.comp.button" x="315" y="87" height="23" label="选择" width="75" var="btnSelect"/>
			  <Button skin="png.comp.button" x="162" y="230" var="btnCreate" label="创建"/>
			  <Label text="地图名称：" x="14" y="48"/>
			  <TextInput skin="png.comp.textinput" x="80" y="47" var="txtMapName" width="228" height="22"/>
			</Dialog>;
		public function CreateDialogUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}