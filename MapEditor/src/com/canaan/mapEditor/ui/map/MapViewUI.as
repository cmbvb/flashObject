/**Created by the Morn,do not modify.*/
package com.canaan.mapEditor.ui.map {
	import com.canaan.lib.component.controls.*;
	public class MapViewUI extends View {
		public var vscroll:VScrollBar;
		public var hscroll:HScrollBar;
		protected var uiXML:XML =
			<View>
			  <VScrollBar skin="png.comp.vscroll2" x="0" y="0" var="vscroll"/>
			  <HScrollBar skin="png.comp.hscroll2" x="0" y="0" var="hscroll"/>
			</View>;
		public function MapViewUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}