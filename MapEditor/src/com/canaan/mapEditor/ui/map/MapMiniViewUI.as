/**Created by the Morn,do not modify.*/
package com.canaan.mapEditor.ui.map {
	import com.canaan.lib.component.controls.*;
	public class MapMiniViewUI extends View {
		public var imgMap:Image;
		public var lblMapName:Label;
		public var lblMapSize:Label;
		public var lblMapGrid:Label;
		public var lblResName:Label;
		protected var uiXML:XML =
			<View>
			  <Image url="png.comp.border" width="252" height="202" sizeGrid="3,3,3,3" x="0" y="0"/>
			  <Image x="1" y="1" width="250" height="200" var="imgMap"/>
			  <Label text="地图名称：" x="6" y="207"/>
			  <Label x="66" y="208" width="186" height="18" var="lblMapName" text="shabake"/>
			  <Label text="地图尺寸：" x="6" y="245"/>
			  <Label x="66" y="246" width="186" height="18" var="lblMapSize" text="10000*8000"/>
			  <Label text="地图格子：" x="6" y="264"/>
			  <Label x="66" y="265" width="186" height="18" var="lblMapGrid" text="255*222"/>
			  <Label text="资源名称：" x="6" y="226"/>
			  <Label x="66" y="227" width="186" height="18" var="lblResName" text="shabake"/>
			</View>;
		public function MapMiniViewUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}