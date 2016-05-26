/**Created by the Morn,do not modify.*/
package com.canaan.gameEditor.ui.action {
	import com.canaan.lib.component.controls.*;
	import com.canaan.gameEditor.view.action.ActionEditImageItem;
	import com.canaan.gameEditor.view.action.ActionEditTimeLineItem;
	import com.canaan.gameEditor.view.action.ActionViewActionItem;
	public class ActionEditViewUI extends View {
		public var listImages:List;
		public var panelPreview:Panel;
		public var panelDetail:Panel;
		public var listTimeLine:List;
		public var txtFrameSet:TextInput;
		public var cboDirection:ComboBox;
		public var btnPlay:Button;
		public var txtCurrentFrame:Label;
		public var txtSeconds:Label;
		public var btnCopyTimeLine:Button;
		public var btnSave:Button;
		public var listActions:List;
		public var txtID:TextInput;
		public var txtDesc:TextArea;
		public var cboRoleType:ComboBox;
		protected var uiXML:XML =
			<View>
			  <Box x="874" y="188">
			    <Label text="图片库"/>
			    <List y="302" repeatX="5" repeatY="5" spaceX="1" spaceY="1" x="0" var="listImages">
			      <ActionEditImageItem name="render" runtime="com.canaan.gameEditor.view.action.ActionEditImageItem"/>
			      <VScrollBar skin="png.comp.vscroll" x="256" width="17" height="254" name="scrollBar" y="0"/>
			    </List>
			    <Panel x="0" y="24" width="275" height="275" var="panelPreview">
			      <Image url="png.comp.borderBlank" width="275" height="275" sizeGrid="2,2,2,2"/>
			    </Panel>
			  </Box>
			  <Box x="250" y="187">
			    <Label text="场景"/>
			    <Panel x="3" y="25" width="600" height="532" var="panelDetail">
			      <Image url="png.comp.borderBlank" width="600" height="532" sizeGrid="2,2,2,2"/>
			    </Panel>
			  </Box>
			  <Box x="251" y="4">
			    <Label text="时间轴"/>
			    <List y="29" repeatX="50" repeatY="2" var="listTimeLine" x="76">
			      <ActionEditTimeLineItem name="render" runtime="com.canaan.gameEditor.view.action.ActionEditTimeLineItem"/>
			    </List>
			    <TextInput text="30" skin="png.comp.textinput" x="222" y="156" width="80" height="22" var="txtFrameSet" editable="false"/>
			    <Label text="帧频" x="192" y="157"/>
			    <Label text="方向" y="157" x="73"/>
			    <ComboBox labels="下" skin="png.comp.combobox" x="103" y="155" width="80" height="23" sizeGrid="10,10,50,10" var="cboDirection" scrollBarSkin="png.comp.vscroll" selectedIndex="0" visibleNum="5"/>
			    <Button skin="png.comp.button" x="564" y="156" label="播放" var="btnPlay"/>
			    <Label text="当前帧索引" x="317" y="157"/>
			    <Label text="50/50" x="385" y="157" var="txtCurrentFrame" align="left" width="35" height="18" color="0xff0000"/>
			    <Label text="动画帧" x="38" y="29" size="10"/>
			    <Label text="图片帧" x="38" y="73" size="10"/>
			    <Label text="(F5:插入帧 SHIFT+F5:删除帧 F6:插入音频 SHIFT+F6:删除音频)" x="584" y="4" size="10"/>
			    <Label text="时间" x="435" y="157"/>
			    <Label text="0.333s/0.333s" x="467" y="157" var="txtSeconds" color="0xff0000"/>
			    <Button skin="png.comp.button" x="648" y="156" var="btnCopyTimeLine" label="拷贝帧频"/>
			  </Box>
			  <Button skin="png.comp.button" x="1074" y="753" label="保存" var="btnSave"/>
			  <Box x="10" y="189">
			    <Image url="png.comp.bg2" y="23" sizeGrid="5,5,5,5" width="215" height="533" x="0"/>
			    <List x="7" y="29" repeatX="1" repeatY="13" spaceY="0" var="listActions">
			      <VScrollBar skin="png.comp.vscroll" x="185" width="17" height="520" name="scrollBar" y="0"/>
			      <ActionViewActionItem x="0" y="0" name="render" runtime="com.canaan.gameEditor.view.action.ActionViewActionItem"/>
			    </List>
			    <Label text="动作列表" x="2"/>
			  </Box>
			  <Box x="7" y="7">
			    <Label text="编号："/>
			    <TextInput skin="png.comp.textinput" x="43" width="170" height="22" sizeGrid="10,10,10,10" var="txtID"/>
			    <Label text="备注：" y="54" x="0"/>
			    <TextArea skin="png.comp.textarea" x="43" y="57" width="170" height="110" scrollBarSkin="png.comp.vscroll" sizeGrid="10,10,10,10" var="txtDesc"/>
			    <Label text="类型：" x="0" y="28"/>
			    <ComboBox labels="label1,label2" skin="png.comp.combobox" x="43" y="28" sizeGrid="10,10,50,10" width="170" var="cboRoleType" scrollBarSkin="png.comp.vscroll" visibleNum="10"/>
			  </Box>
			</View>;
		public function ActionEditViewUI(){}
		override protected function createChildren():void {
			viewClassMap["com.canaan.gameEditor.view.action.ActionEditImageItem"] = ActionEditImageItem;
			viewClassMap["com.canaan.gameEditor.view.action.ActionEditTimeLineItem"] = ActionEditTimeLineItem;
			viewClassMap["com.canaan.gameEditor.view.action.ActionViewActionItem"] = ActionViewActionItem;
			createView(uiXML);
		}
	}
}