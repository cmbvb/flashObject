/**Created by the Morn,do not modify.*/
package com.canaan.programEditor.ui.common {
	import com.canaan.lib.component.controls.*;
	public class AlertUI extends Dialog {
		public var hbox:HBox;
		public var btnSure:Button;
		public var btnCancel:Button;
		public var lblText:Label;
		protected var uiXML:XML =
			<Dialog>
			  <Image url="png.comp.bg" x="0" y="0" sizeGrid="5,30,5,30" width="250" height="140"/>
			  <Button skin="png.comp.btn_close" x="219" y="3" name="close"/>
			  <Image url="png.comp.blank" x="0" y="0" width="216" height="26" name="drag"/>
			  <HBox x="47" y="105" space="10" var="hbox">
			    <Button skin="png.comp.button" label="确定" name="sure" var="btnSure"/>
			    <Button skin="png.comp.button" x="85" name="cancel" label="取消" var="btnCancel"/>
			  </HBox>
			  <Label text="label" x="20" y="40" width="210" height="60" var="lblText" wordWrap="true" multiline="true"/>
			</Dialog>;
		public function AlertUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}