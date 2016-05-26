/**Created by the Morn,do not modify.*/
package com.canaan.gameEditor.ui.action {
	import com.canaan.lib.component.controls.*;
	public class ActionViewRoleItemUI extends View {
		public var lblRole:Label;
		public var btnDelete:Button;
		protected var uiXML:XML =
			<View>
			  <Clip url="png.comp.clip_selectBox" x="0" clipX="1" clipY="2" y="0" width="195" height="25" name="selectBox"/>
			  <Label text="角色" x="2" y="2" width="190" height="20" var="lblRole"/>
			  <Button skin="png.comp.btn_close" x="164" y="2" var="btnDelete"/>
			</View>;
		public function ActionViewRoleItemUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}