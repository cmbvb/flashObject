/**Created by the Morn,do not modify.*/
package com.canaan.gameEditor.ui.action {
	import com.canaan.lib.component.controls.*;
	public class ActionRoleChooseItemUI extends View {
		public var lblRole:Label;
		protected var uiXML:XML =
			<View>
			  <Clip url="png.comp.clip_selectBox" x="0" clipX="1" clipY="2" y="0" width="195" height="25" name="selectBox"/>
			  <Label text="角色" x="1" y="2" width="189" height="20" var="lblRole"/>
			</View>;
		public function ActionRoleChooseItemUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}