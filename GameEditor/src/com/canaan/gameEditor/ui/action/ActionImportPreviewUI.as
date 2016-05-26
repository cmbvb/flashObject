/**Created by the Morn,do not modify.*/
package com.canaan.gameEditor.ui.action {
	import com.canaan.lib.component.controls.*;
	public class ActionImportPreviewUI extends View {
		public var sliderFrame:HSlider;
		public var txtFrameSet:TextInput;
		public var btnPlay:Button;
		public var panelPreview:Panel;
		public var cboDirection:ComboBox;
		public var txtCurrentFrame:Label;
		protected var uiXML:XML =
			<View>
			  <HSlider skin="png.comp.hslider" x="34" y="497" width="562" height="6" sizeGrid="3,2,3,2" tick="1" var="sliderFrame"/>
			  <TextInput text="30" skin="png.comp.textinput" x="203" y="524" width="80" height="22" var="txtFrameSet"/>
			  <Label text="帧频" x="167" y="525"/>
			  <Button skin="png.comp.button" x="520" y="522" label="播放" var="btnPlay"/>
			  <Label text="方向" x="40" y="524"/>
			  <Panel x="18" y="18" width="600" height="450" var="panelPreview">
			    <Image url="png.comp.blank2" x="00" y="0" width="600" height="450"/>
			  </Panel>
			  <ComboBox labels="下" skin="png.comp.combobox" x="75" y="523" width="80" height="23" sizeGrid="10,10,50,10" var="cboDirection" scrollBarSkin="png.comp.vscroll" selectedIndex="0" visibleNum="8"/>
			  <Label text="当前帧索引" x="358" y="524"/>
			  <Label text="0/0" x="435" y="524" var="txtCurrentFrame"/>
			</View>;
		public function ActionImportPreviewUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}