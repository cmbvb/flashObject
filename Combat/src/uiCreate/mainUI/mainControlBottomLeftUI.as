/**Created by the Morn,do not modify.*/
package uiCreate.mainUI {
	import morn.core.components.*;
	public class mainControlBottomLeftUI extends View {
		public var btnUp:Button = null;
		public var btnLeft:Button = null;
		public var btnRight:Button = null;
		public var btnJump:Button = null;
		protected static var uiView:XML =
			<View width="210" height="210">
			  <Button label="上" skin="png.comp.button" x="70" y="0" width="70" height="70" var="btnUp"/>
			  <Button label="左" skin="png.comp.button" x="0" y="70" width="70" height="70" var="btnLeft"/>
			  <Button label="右" skin="png.comp.button" x="140" y="70" width="70" height="70" var="btnRight"/>
			  <Button label="跳" skin="png.comp.button" x="70" y="140" width="70" height="70" var="btnJump"/>
			</View>;
		public function mainControlBottomLeftUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}