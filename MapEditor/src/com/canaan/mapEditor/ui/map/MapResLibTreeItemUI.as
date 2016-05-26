/**Created by the Morn,do not modify.*/
package com.canaan.mapEditor.ui.map {
	import com.canaan.lib.component.controls.*;
	public class MapResLibTreeItemUI extends TreeItem {
		public var imgFolder:Image;
		public var lblName:Label;
		protected var uiXML:XML =
			<TreeItem>
			  <Clip url="png.comp.clip_selectBox" x="0" y="0" clipX="1" clipY="2" name="selectBox" width="240" height="20"/>
			  <Image url="png.comp.img_folder" x="2" y="2" var="imgFolder"/>
			  <Label text="赤月恶魔" x="20" y="0" var="lblName" width="220" height="20"/>
			</TreeItem>;
		public function MapResLibTreeItemUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}