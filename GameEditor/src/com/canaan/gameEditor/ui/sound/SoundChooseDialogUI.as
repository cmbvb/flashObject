/**Created by the Morn,do not modify.*/
package com.canaan.gameEditor.ui.sound {
	import com.canaan.lib.component.controls.*;
	import com.canaan.gameEditor.view.sound.SoundChooseItem;
	public class SoundChooseDialogUI extends Dialog {
		public var listSounds:List;
		public var txtSearch:TextInput;
		public var btnAccept:Button;
		protected var uiXML:XML =
			<Dialog>
			  <Image url="png.comp.bg" x="0" y="0" sizeGrid="5,30,5,30" width="247" height="361"/>
			  <Image url="png.comp.blank" x="0" y="1" width="215" height="26" name="drag"/>
			  <Button skin="png.comp.btn_close" x="216" y="3" name="close"/>
			  <Box x="10" y="30">
			    <Image url="png.comp.bg2" y="26" sizeGrid="5,5,5,5" width="226" height="262" x="0"/>
			    <List x="6" y="32" repeatX="1" repeatY="10" var="listSounds">
			      <VScrollBar skin="png.comp.vscroll" x="197" width="17" height="250" name="scrollBar" y="0"/>
			      <SoundChooseItem x="0" y="0" name="render" runtime="com.canaan.gameEditor.view.sound.SoundChooseItem"/>
			    </List>
			    <TextInput skin="png.comp.textinput" x="30" width="171" height="22" var="txtSearch"/>
			    <Label text="搜索"/>
			  </Box>
			  <Button skin="png.comp.button" x="161" y="326" var="btnAccept" label="确定"/>
			</Dialog>;
		public function SoundChooseDialogUI(){}
		override protected function createChildren():void {
			viewClassMap["com.canaan.gameEditor.view.sound.SoundChooseItem"] = SoundChooseItem;
			createView(uiXML);
		}
	}
}