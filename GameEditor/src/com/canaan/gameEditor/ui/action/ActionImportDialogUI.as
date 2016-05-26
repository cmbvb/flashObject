/**Created by the Morn,do not modify.*/
package com.canaan.gameEditor.ui.action {
	import com.canaan.lib.component.controls.*;
	import com.canaan.gameEditor.view.action.ActionImportItem;
	import com.canaan.gameEditor.view.action.ActionImportPreview;
	public class ActionImportDialogUI extends Dialog {
		public var btnSave:Button;
		public var btnImport:Button;
		public var listActions:List;
		public var txtID:TextInput;
		public var txtQuality:TextInput;
		public var txtDesc:TextArea;
		public var cboRoleType:ComboBox;
		public var preview:ActionImportPreview;
		protected var uiXML:XML =
			<Dialog>
			  <Image url="png.comp.bg" x="0" y="0" sizeGrid="5,30,5,30" width="900" height="690"/>
			  <Image url="png.comp.blank" x="0" y="0" width="867" height="26" name="drag"/>
			  <Button skin="png.comp.btn_close" x="869" y="3" name="close"/>
			  <HBox x="720" y="646" space="10">
			    <Button skin="png.comp.button" x="101" var="btnSave" label="保存"/>
			    <Button skin="png.comp.button" y="0" var="btnImport" label="导入" x="0"/>
			  </HBox>
			  <Box x="16" y="272">
			    <Image url="png.comp.bg2" y="23" sizeGrid="5,5,5,5" width="215" height="334"/>
			    <List x="7" y="29" repeatX="1" repeatY="8" spaceY="0" var="listActions">
			      <VScrollBar skin="png.comp.vscroll" x="185" width="17" height="320" name="scrollBar"/>
			      <ActionImportItem x="0" y="0" name="render" runtime="com.canaan.gameEditor.view.action.ActionImportItem"/>
			    </List>
			    <Label text="动作列表" x="2"/>
			  </Box>
			  <Box x="16" y="34">
			    <Label text="角色信息" x="1"/>
			    <Image url="png.comp.bg2" y="24" sizeGrid="5,5,5,5" width="215" height="206" x="0"/>
			    <Label text="编号：" y="33" x="10"/>
			    <TextInput skin="png.comp.textinput" x="56" y="32" width="150" height="22" sizeGrid="10,10,10,10" var="txtID"/>
			    <Label text="品质：" y="90" x="10"/>
			    <TextInput skin="png.comp.textinput" x="56" y="89" width="150" height="22" sizeGrid="10,10,10,10" var="txtQuality" text="100"/>
			    <Label text="(图片品质1-100 不建议修改)" y="115" x="55" color="0xff0000"/>
			    <Label text="备注：" x="10" y="134"/>
			    <TextArea skin="png.comp.textarea" x="56" y="136" width="150" height="85" scrollBarSkin="png.comp.vscroll" sizeGrid="10,10,10,10" var="txtDesc"/>
			    <Label text="类型：" x="10" y="60"/>
			    <ComboBox labels="label1,label2" skin="png.comp.combobox" x="56" y="60" sizeGrid="10,10,50,10" width="150" var="cboRoleType" scrollBarSkin="png.comp.vscroll" visibleNum="10"/>
			  </Box>
			  <Box x="246" y="34">
			    <Image url="png.comp.bg2" y="24" sizeGrid="5,5,5,5" width="636" height="571" x="0"/>
			    <Label text="预览"/>
			    <ActionImportPreview x="0" y="24" runtime="com.canaan.gameEditor.view.action.ActionImportPreview" var="preview"/>
			  </Box>
			</Dialog>;
		public function ActionImportDialogUI(){}
		override protected function createChildren():void {
			viewClassMap["com.canaan.gameEditor.view.action.ActionImportItem"] = ActionImportItem;
			viewClassMap["com.canaan.gameEditor.view.action.ActionImportPreview"] = ActionImportPreview;
			createView(uiXML);
		}
	}
}