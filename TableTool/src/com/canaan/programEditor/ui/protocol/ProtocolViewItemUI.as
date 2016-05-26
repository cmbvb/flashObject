/**Created by the Morn,do not modify.*/
package com.canaan.programEditor.ui.protocol {
	import com.canaan.lib.component.controls.*;
	public class ProtocolViewItemUI extends TreeItem {
		public var lblName:Label;
		public var btnDelete:Button;
		public var imgIcon:Image;
		protected var uiXML:XML =
			<TreeItem>
			  <Clip url="png.comp.clip_selectBox" x="0" clipX="1" clipY="2" y="0" width="220" height="25" name="selectBox"/>
			  <Box x="0" y="0" width="220" height="25">
			    <Label text="MonsterTemple" x="19" width="198" height="20" var="lblName" y="2"/>
			    <Button skin="png.comp.btn_close" x="189" var="btnDelete" y="2"/>
			    <Image url="png.comp.img_folder" y="4" var="imgIcon" x="2"/>
			  </Box>
			</TreeItem>;
		public function ProtocolViewItemUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}