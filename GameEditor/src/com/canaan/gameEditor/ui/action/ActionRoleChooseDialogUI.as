/**Created by the Morn,do not modify.*/
package com.canaan.gameEditor.ui.action {
	import com.canaan.lib.component.controls.*;
	import com.canaan.gameEditor.view.action.ActionRoleChooseItem;
	public class ActionRoleChooseDialogUI extends Dialog {
		public var listRoles:List;
		public var txtSearch:TextInput;
		public var cboRoleType:ComboBox;
		public var btnAccept:Button;
		public var panelPreview:Panel;
		protected var uiXML:XML =
			<Dialog>
			  <Image url="png.comp.bg" x="0" y="0" sizeGrid="5,30,5,30" width="700" height="500"/>
			  <Image url="png.comp.blank" x="0" y="1" width="667" height="26" name="drag"/>
			  <Button skin="png.comp.btn_close" x="669" y="3" name="close"/>
			  <Box x="9" y="35">
			    <Image url="png.comp.bg2" y="60" sizeGrid="5,5,5,5" width="226" height="361" x="0"/>
			    <List x="6" y="66" repeatX="1" repeatY="14" var="listRoles">
			      <VScrollBar skin="png.comp.vscroll" x="197" width="17" height="350" name="scrollBar" y="0"/>
			      <ActionRoleChooseItem x="0" y="0" name="render" runtime="com.canaan.gameEditor.view.action.ActionRoleChooseItem"/>
			    </List>
			    <TextInput skin="png.comp.textinput" x="30" width="171" height="22" var="txtSearch" y="30"/>
			    <Label text="搜索" y="30" x="0"/>
			    <Label text="类型" y="2" x="0"/>
			    <ComboBox labels="label1,label2" skin="png.comp.combobox" x="30" y="0" width="171" sizeGrid="5,5,50,5" var="cboRoleType" scrollBarSkin="png.comp.vscroll" visibleNum="10"/>
			  </Box>
			  <Button skin="png.comp.button" x="611" y="465" var="btnAccept" label="确定"/>
			  <Panel x="246" y="96" width="440" height="360" var="panelPreview">
			    <Image url="png.comp.borderBlank" width="440" height="360" sizeGrid="2,2,2,2"/>
			  </Panel>
			</Dialog>;
		public function ActionRoleChooseDialogUI(){}
		override protected function createChildren():void {
			viewClassMap["com.canaan.gameEditor.view.action.ActionRoleChooseItem"] = ActionRoleChooseItem;
			createView(uiXML);
		}
	}
}