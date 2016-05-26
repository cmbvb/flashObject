/**Created by the Morn,do not modify.*/
package com.canaan.gameEditor.ui.action {
	import com.canaan.lib.component.controls.*;
	import com.canaan.gameEditor.view.action.ActionActionTypeItem;
	public class ActionActionTypeDialogUI extends Dialog {
		public var listActionType:List;
		public var btnAdd:Button;
		public var txtID:TextInput;
		public var txtName:TextInput;
		protected var uiXML:XML =
			<Dialog>
			  <Image url="png.comp.bg" x="0" y="0" sizeGrid="5,30,5,30" width="500" height="428"/>
			  <Image url="png.comp.blank" x="0" y="1" width="467" height="26" name="drag"/>
			  <Button skin="png.comp.btn_close" x="469" y="3" name="close"/>
			  <Box x="8" y="31">
			    <Image url="png.comp.bg2" sizeGrid="5,5,5,5" width="188" height="387" x="0" y="0"/>
			    <List x="5" y="6" repeatX="1" repeatY="15" var="listActionType">
			      <VScrollBar skin="png.comp.vscroll" width="17" height="375" name="scrollBar" x="161" y="0"/>
			      <ActionActionTypeItem x="0" y="0" name="render" runtime="com.canaan.gameEditor.view.action.ActionActionTypeItem"/>
			    </List>
			  </Box>
			  <Button skin="png.comp.button" x="311" y="112" var="btnAdd" label="添加"/>
			  <Label text="动作编号：" x="218" y="41"/>
			  <Label text="动作名称：" x="218" y="74"/>
			  <TextInput skin="png.comp.textinput" x="285" y="41" var="txtID"/>
			  <TextInput skin="png.comp.textinput" x="285" y="74" var="txtName"/>
			</Dialog>;
		public function ActionActionTypeDialogUI(){}
		override protected function createChildren():void {
			viewClassMap["com.canaan.gameEditor.view.action.ActionActionTypeItem"] = ActionActionTypeItem;
			createView(uiXML);
		}
	}
}