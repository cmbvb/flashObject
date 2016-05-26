/**Created by the Morn,do not modify.*/
package uiCreate.dialogs {
	import morn.core.components.*;
	public class SettingDialogUI extends Dialog {
		public var inputW:TextInput = null;
		public var inputH:TextInput = null;
		public var lblSavePath:Label = null;
		public var btnSavePath:Button = null;
		protected static var uiView:XML =
			<Dialog width="600" height="400">
			  <Image skin="png.comp.bg" x="0" y="0" width="317" height="198" sizeGrid="30,30,30,30"/>
			  <Label text="格子宽(width)：" x="12" y="54.5"/>
			  <Label text="格子高(height)：" x="12" y="85.5"/>
			  <TextInput skin="png.comp.blank" x="132" y="53" var="inputW"/>
			  <TextInput skin="png.comp.blank" x="132" y="84" var="inputH"/>
			  <Button skin="png.comp.btn_close" x="286" y="3" name="close"/>
			  <Image skin="png.comp.blank" x="0" y="0" width="286" height="25" name="drag"/>
			  <Label text="客户端数据保存路径：" x="12" y="125"/>
			  <Label x="132" y="126" background="true" backgroundColor="0x999999" width="128" height="18" var="lblSavePath"/>
			  <Button label="选择" skin="png.comp.button" x="266" y="123.5" width="36" height="23" var="btnSavePath"/>
			</Dialog>;
		public function SettingDialogUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}