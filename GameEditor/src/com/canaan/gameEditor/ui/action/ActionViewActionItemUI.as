/**Created by the Morn,do not modify.*/
package com.canaan.gameEditor.ui.action {
	import com.canaan.lib.component.controls.*;
	public class ActionViewActionItemUI extends View {
		public var imgPreview:Image;
		public var lblAction:Label;
		protected var uiXML:XML =
			<View>
			  <Clip url="png.comp.clip_selectBox" x="0" clipX="1" clipY="2" y="0" width="185" height="40" name="selectBox"/>
			  <Image url="png.comp.blank" width="40" height="40" var="imgPreview" name="imgPreview" x="0" y="0"/>
			  <Label text="动作" x="46" y="10" var="lblAction" name="lblAction" width="137" height="20"/>
			</View>;
		public function ActionViewActionItemUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}