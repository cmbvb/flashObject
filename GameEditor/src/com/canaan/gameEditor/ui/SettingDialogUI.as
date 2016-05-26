/**Created by the Morn,do not modify.*/
package com.canaan.gameEditor.ui {
	import com.canaan.lib.component.controls.*;
	public class SettingDialogUI extends Dialog {
		public var btnAccept:Button;
		public var txtOutput:TextInput;
		public var btnSetOutput:Button;
		public var txtTable:TextInput;
		public var btnSetTable:Button;
		protected var uiXML:XML =
			<Dialog>
			  <Image url="png.comp.bg" x="0" y="0" sizeGrid="5,30,5,30" width="500" height="400"/>
			  <Image url="png.comp.blank" x="0" y="1" width="468" height="26" name="drag"/>
			  <Button skin="png.comp.btn_close" x="469" y="3" name="close"/>
			  <Button skin="png.comp.button" x="212.5" y="360" var="btnAccept" label="确定"/>
			  <Label text="资源导出目录：" x="58" y="53"/>
			  <TextInput skin="png.comp.textinput" x="149" y="52" sizeGrid="5,5,5,5" width="200" height="22" var="txtOutput"/>
			  <Button skin="png.comp.button" x="359" y="51" var="btnSetOutput" label="选择"/>
			  <Label text="数据导出目录：" x="58" y="82"/>
			  <TextInput skin="png.comp.textinput" x="149" y="83" sizeGrid="5,5,5,5" width="200" height="22" var="txtTable"/>
			  <Button skin="png.comp.button" x="359" y="82" var="btnSetTable" label="选择"/>
			</Dialog>;
		public function SettingDialogUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}