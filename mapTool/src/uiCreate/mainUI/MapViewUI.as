/**Created by the Morn,do not modify.*/
package uiCreate.mainUI {
	import morn.core.components.*;
	public class MapViewUI extends View {
		public var imgMap:Image = null;
		protected static var uiView:XML =
			<View width="600" height="400">
			  <Image x="0" y="0" width="100" height="100" var="imgMap"/>
			</View>;
		public function MapViewUI(){}
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}