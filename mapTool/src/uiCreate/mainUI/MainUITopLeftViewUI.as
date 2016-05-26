/**Created by the Morn,do not modify.*/
package uiCreate.mainUI {
	import morn.core.components.*;
	public class MainUITopLeftViewUI extends View {
		public var btnSet:Button = null;
		public var btnSave:Button = null;
		public var btnPublish:Button = null;
		public var btnOpen:Button = null;
		public var btnShowGrid:Button = null;
		public var btnCutDown:Button = null;
		protected static var uiView:XML =
			<View width="500" height="33">
			  <Button label="设置" skin="png.comp.button" x="0" y="0" width="75" height="33" var="btnSet"/>
			  <Button label="保存" skin="png.comp.button" x="164" y="0" width="75" height="33" var="btnSave"/>
			  <Button label="发布" skin="png.comp.button" x="328" y="0" width="75" height="33" var="btnPublish"/>
			  <Button label="打开" skin="png.comp.button" x="82" y="0" width="75" height="33" var="btnOpen"/>
			  <Button label="显示格子" skin="png.comp.button" x="410" y="0" height="33" width="75" var="btnShowGrid"/>
			  <Button label="切图" skin="png.comp.button" x="246" y="0" width="75" height="33" var="btnCutDown"/>
			</View>;
		public function MainUITopLeftViewUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}