/**Created by the Morn,do not modify.*/
package com.canaan.gameEditor.ui.action {
	import com.canaan.lib.component.controls.*;
	public class ActionRoleTypeItemUI extends View {
		public var lblType:Label;
		public var btnDelete:Button;
		protected var uiXML:XML =
			<View>
			  <Clip url="png.comp.clip_selectBox" x="0" clipX="1" clipY="2" y="0" width="160" height="25" name="selectBox"/>
			  <Label text="0(默认)" x="3" y="2" width="155" height="20" var="lblType"/>
			  <Button skin="png.comp.btn_close" x="130" y="2" var="btnDelete"/>
			</View>;
		public function ActionRoleTypeItemUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}