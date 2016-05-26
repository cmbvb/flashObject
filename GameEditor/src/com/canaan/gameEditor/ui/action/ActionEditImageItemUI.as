/**Created by the Morn,do not modify.*/
package com.canaan.gameEditor.ui.action {
	import com.canaan.lib.component.controls.*;
	public class ActionEditImageItemUI extends View {
		public var imgIcon:Image;
		public var lblIndex:Label;
		protected var uiXML:XML =
			<View>
			  <Image url="png.comp.border" x="0" y="0" sizeGrid="2,2,2,2" width="50" height="50"/>
			  <Clip url="png.comp.clip_selectBox" x="1" y="1" clipX="1" clipY="2" width="48" height="48" name="selectBox"/>
			  <Image width="48" height="48" x="1" y="1" var="imgIcon"/>
			  <Label text="1" x="2" y="32" var="lblIndex" width="46" height="18" align="right" color="0xff0000"/>
			</View>;
		public function ActionEditImageItemUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}