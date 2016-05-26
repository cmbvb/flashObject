/**Created by the Morn,do not modify.*/
package uiCreate.mainUI {
	import morn.core.components.*;
	public class mainControlBottomRightUI extends View {
		public var btnSkill:Button = null;
		public var btnBash:Button = null;
		public var btnSkill1:Button = null;
		public var btnSkill2:Button = null;
		public var btnSkill3:Button = null;
		protected static var uiView:XML =
			<View width="210" height="140">
			  <Button label="普攻" skin="png.comp.button" x="140" y="70" width="70" height="70" var="btnSkill"/>
			  <Button label="冲刺" skin="png.comp.button" x="0" y="70" width="70" height="70" var="btnBash"/>
			  <Button label="技能1" skin="png.comp.button" x="0" y="0" width="70" height="70" var="btnSkill1"/>
			  <Button label="技能2" skin="png.comp.button" x="70" y="0" width="70" height="70" var="btnSkill2"/>
			  <Button label="技能3" skin="png.comp.button" x="140" y="0" width="70" height="70" var="btnSkill3"/>
			</View>;
		public function mainControlBottomRightUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}