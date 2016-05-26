/**Created by the Morn,do not modify.*/
package com.canaan.programEditor.ui.table {
	import com.canaan.lib.component.controls.*;
	public class TableJsonViewUI extends View {
		public var txtJson:TextArea;
		protected var uiXML:XML =
			<View>
			  <TextArea x="0" y="0" isHtml="true" scrollBarSkin="png.comp.vscroll" width="1150" height="762" var="txtJson" editable="false"/>
			</View>;
		public function TableJsonViewUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}