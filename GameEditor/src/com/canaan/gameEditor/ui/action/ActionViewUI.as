/**Created by the Morn,do not modify.*/
package com.canaan.gameEditor.ui.action {
	import com.canaan.lib.component.controls.*;
	import com.canaan.gameEditor.view.action.ActionEditView;
	import com.canaan.gameEditor.view.action.ActionViewRoleItem;
	public class ActionViewUI extends View {
		public var btnImport:Button;
		public var listRoles:List;
		public var txtSearch:TextInput;
		public var cboRoleType:ComboBox;
		public var editView:ActionEditView;
		public var btnRoleType:Button;
		public var btnActionType:Button;
		public var btnSaveAll:Button;
		protected var uiXML:XML =
			<View width="1430" height="860">
			  <Button skin="png.comp.button" x="10" y="10" label="导入动作" var="btnImport"/>
			  <Box x="10" y="60">
			    <Image url="png.comp.bg2" y="53" sizeGrid="5,5,5,5" width="226" height="736" x="0"/>
			    <List x="6" y="59" repeatX="1" repeatY="29" spaceY="0" var="listRoles">
			      <VScrollBar skin="png.comp.vscroll" x="197" width="17" height="725" name="scrollBar" y="0"/>
			      <ActionViewRoleItem x="0" y="0" name="render" runtime="com.canaan.gameEditor.view.action.ActionViewRoleItem"/>
			    </List>
			    <TextInput skin="png.comp.textinput" x="30" width="171" height="22" var="txtSearch" y="27"/>
			    <Label text="搜索" y="27"/>
			    <Label text="类型" y="2"/>
			    <ComboBox labels="label1,label2" skin="png.comp.combobox" x="30" width="171" sizeGrid="5,5,50,5" var="cboRoleType" scrollBarSkin="png.comp.vscroll" visibleNum="10"/>
			  </Box>
			  <Box x="262" y="43">
			    <Label text="角色编辑"/>
			    <Image url="png.comp.bg2" y="21" sizeGrid="5,5,5,5" width="1165" height="785"/>
			    <ActionEditView y="20" var="editView" runtime="com.canaan.gameEditor.view.action.ActionEditView" x="0"/>
			  </Box>
			  <Button skin="png.comp.button" x="95" y="10" label="角色类型" var="btnRoleType"/>
			  <Button skin="png.comp.button" x="180" y="10" label="动作类型" var="btnActionType"/>
			  <Button skin="png.comp.button" x="265" y="10" label="保存全部" var="btnSaveAll"/>
			</View>;
		public function ActionViewUI(){}
		override protected function createChildren():void {
			viewClassMap["com.canaan.gameEditor.view.action.ActionEditView"] = ActionEditView;
			viewClassMap["com.canaan.gameEditor.view.action.ActionViewRoleItem"] = ActionViewRoleItem;
			createView(uiXML);
		}
	}
}