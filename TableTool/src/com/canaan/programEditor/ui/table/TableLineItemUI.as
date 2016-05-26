/**Created by the Morn,do not modify.*/
package com.canaan.programEditor.ui.table {
	import com.canaan.lib.component.controls.*;
	public class TableLineItemUI extends View {
		public var lblLineID:Label;
		protected var uiXML:XML =
			<View>
			  <Clip url="png.comp.clip_selectBox" x="0" clipX="1" clipY="2" y="0" width="160" height="25" name="selectBox"/>
			  <Label text="MonsterTemple" x="2" y="2" width="155" height="20" var="lblLineID"/>
			</View>;
		public function TableLineItemUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}