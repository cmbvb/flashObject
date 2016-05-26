/**Created by the Morn,do not modify.*/
package com.canaan.programEditor.ui.table {
	import com.canaan.lib.component.controls.*;
	public class TableLineDataItemUI extends View {
		public var lblName:Label;
		public var lblType:Label;
		public var lblContent:Label;
		protected var uiXML:XML =
			<View>
			  <Image url="png.comp.blank" x="0" y="0" width="250" height="24"/>
			  <Label text="MonsterName" x="56" y="2" height="20" width="191" var="lblName" color="0x7f0055"/>
			  <Label text="string[]" x="0" y="2" height="20" width="50" align="center" var="lblType" color="0x3f5fbf"/>
			  <Image url="png.comp.blank" x="50" y="2" width="1" height="20"/>
			  <Image url="png.comp.blank" x="252" y="0" width="640" height="24"/>
			  <Label text="MonsterName" x="258" y="2" height="20" width="629" var="lblContent" color="0x0"/>
			</View>;
		public function TableLineDataItemUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}