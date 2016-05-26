/**Created by the Morn,do not modify.*/
package com.canaan.programEditor.ui.enum {
	import com.canaan.lib.component.controls.*;
	public class EnumViewItemUI extends View {
		public var lblEnumName:Label;
		public var btnDelete:Button;
		protected var uiXML:XML =
			<View>
			  <Clip url="png.comp.clip_selectBox" x="0" clipX="1" clipY="2" y="0" width="220" height="25" name="selectBox"/>
			  <Label text="MonsterTemple" x="3" y="2" width="215" height="20" var="lblEnumName"/>
			  <Button skin="png.comp.btn_close" x="190" y="2" var="btnDelete"/>
			</View>;
		public function EnumViewItemUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}