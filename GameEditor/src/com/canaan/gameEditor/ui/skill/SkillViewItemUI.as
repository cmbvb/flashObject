/**Created by the Morn,do not modify.*/
package com.canaan.gameEditor.ui.skill {
	import com.canaan.lib.component.controls.*;
	public class SkillViewItemUI extends View {
		public var lblSkill:Label;
		public var btnDelete:Button;
		protected var uiXML:XML =
			<View>
			  <Clip url="png.comp.clip_selectBox" x="0" clipX="1" clipY="2" y="0" width="195" height="25" name="selectBox"/>
			  <Label text="技能" x="2" y="2" width="165" height="20" var="lblSkill"/>
			  <Button skin="png.comp.btn_close" x="164" y="2" var="btnDelete"/>
			</View>;
		public function SkillViewItemUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}