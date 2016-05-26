/**Created by the Morn,do not modify.*/
package com.canaan.gameEditor.ui.skill {
	import com.canaan.lib.component.controls.*;
	import com.canaan.gameEditor.view.skill.SkillPreviewView;
	import com.canaan.gameEditor.view.skill.SkillViewItem;
	public class SkillViewUI extends View {
		public var btnAdd:Button;
		public var listSkills:List;
		public var txtSearch:TextInput;
		public var container:Box;
		public var skillPreview:SkillPreviewView;
		protected var uiXML:XML =
			<View width="1430" height="860">
			  <Button skin="png.comp.button" x="10" y="10" label="新建技能" var="btnAdd"/>
			  <Box x="10" y="64">
			    <Image url="png.comp.bg2" y="26" sizeGrid="5,5,5,5" width="226" height="761" x="0"/>
			    <List x="6" y="32" repeatX="1" repeatY="30" var="listSkills">
			      <VScrollBar skin="png.comp.vscroll" x="197" width="17" height="750" name="scrollBar"/>
			      <SkillViewItem x="0" y="0" name="render" runtime="com.canaan.gameEditor.view.skill.SkillViewItem"/>
			    </List>
			    <TextInput skin="png.comp.textinput" x="30" width="171" height="22" var="txtSearch"/>
			    <Label text="搜索"/>
			  </Box>
			  <Box x="257" y="64" var="container">
			    <Label text="技能预览" x="3"/>
			    <Image url="png.comp.bg2" y="26" sizeGrid="5,5,5,5" width="1165" height="761" x="0"/>
			    <SkillPreviewView x="28" y="60" runtime="com.canaan.gameEditor.view.skill.SkillPreviewView" var="skillPreview"/>
			  </Box>
			</View>;
		public function SkillViewUI(){}
		override protected function createChildren():void {
			viewClassMap["com.canaan.gameEditor.view.skill.SkillPreviewView"] = SkillPreviewView;
			viewClassMap["com.canaan.gameEditor.view.skill.SkillViewItem"] = SkillViewItem;
			createView(uiXML);
		}
	}
}