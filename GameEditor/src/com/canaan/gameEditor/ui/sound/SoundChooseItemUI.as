/**Created by the Morn,do not modify.*/
package com.canaan.gameEditor.ui.sound {
	import com.canaan.lib.component.controls.*;
	public class SoundChooseItemUI extends View {
		public var imgIcon:Image;
		public var lblSound:Label;
		protected var uiXML:XML =
			<View>
			  <Clip url="png.comp.clip_selectBox" x="0" clipX="1" clipY="2" y="0" width="195" height="25" name="selectBox"/>
			  <Image url="png.comp.img_music" x="2" y="2" var="imgIcon"/>
			  <Label text="音频" x="27" y="2" width="165" height="20" var="lblSound"/>
			</View>;
		public function SoundChooseItemUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}