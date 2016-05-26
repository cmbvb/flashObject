/**Created by the Morn,do not modify.*/
package com.canaan.programEditor.ui.table {
	import com.canaan.lib.component.controls.*;
	public class TableViewItemUI extends View {
		public var lblTableName:Label;
		public var lblType:Label;
		protected var uiXML:XML =
			<View>
			  <Clip url="png.comp.clip_selectBox" x="0" clipX="1" clipY="2" y="0" width="220" height="25" name="selectBox"/>
			  <Label text="MonsterTemple" x="63" y="3" width="155" height="20" var="lblTableName"/>
			  <Label text="SETTING" x="2" y="3" bold="true" var="lblType"/>
			  <Image url="png.comp.blank" x="60" y="2" height="20" width="1"/>
			</View>;
		public function TableViewItemUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}