/**Created by the Morn,do not modify.*/
package com.canaan.gameEditor.ui.skill {
	import com.canaan.lib.component.controls.*;
	public class SkillTimeLineItemUI extends View {
		public var imgBG:Image;
		public var lblAnimFrame:Label;
		public var imgCircle:Image;
		public var imgRect:Image;
		public var imgSound:Image;
		protected var uiXML:XML =
			<View>
			  <Image url="png.comp.border2" sizeGrid="4,4,4,4" width="16" height="30" var="imgBG" x="0" y="-1"/>
			  <Label text="50" y="28" width="16" height="16" align="center" var="lblAnimFrame" color="0xff0000" size="10" x="0"/>
			  <Clip url="png.comp.clip_selectBox2" x="1" y="0" sizeGrid="5,5,5,5" width="14" height="28" clipX="1" clipY="2" name="selectBox"/>
			  <Image url="png.comp.timeline_circle" x="3" y="17" var="imgCircle"/>
			  <Image url="png.comp.border" x="4" y="15" sizeGrid="2,2,2,2" width="8" height="12" var="imgRect"/>
			  <Image url="png.comp.img_effect_small" x="2" y="0" var="imgSound"/>
			</View>;
		public function SkillTimeLineItemUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}