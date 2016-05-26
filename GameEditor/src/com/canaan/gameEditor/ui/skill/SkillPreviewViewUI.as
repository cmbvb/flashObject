/**Created by the Morn,do not modify.*/
package com.canaan.gameEditor.ui.skill {
	import com.canaan.lib.component.controls.*;
	import com.canaan.gameEditor.view.skill.SkillTimeLineItem;
	public class SkillPreviewViewUI extends View {
		public var listTimeLine:List;
		public var btnPlay:Button;
		public var txtCurrentFrame:Label;
		public var txtSeconds:Label;
		public var btnEdit:Button;
		public var panelDetail:Panel;
		protected var uiXML:XML =
			<View>
			  <List var="listTimeLine" repeatX="50" repeatY="2" x="0" y="0">
			    <SkillTimeLineItem name="render" runtime="com.canaan.gameEditor.view.skill.SkillTimeLineItem"/>
			  </List>
			  <Box x="478" y="108">
			    <Button skin="png.comp.button" x="247" label="播放" var="btnPlay"/>
			    <Label text="当前帧索引" y="1"/>
			    <Label text="50/50" x="68" y="1" var="txtCurrentFrame" align="left" width="35" height="18" color="0xff0000"/>
			    <Label text="时间" x="118" y="1"/>
			    <Label text="0.333s/0.333s" x="150" y="1" var="txtSeconds" color="0xff0000"/>
			    <Button skin="png.comp.button" x="247" y="35" label="修改技能" var="btnEdit"/>
			  </Box>
			  <Box y="196" x="0">
			    <Image url="png.comp.borderBlank" width="820" height="400" sizeGrid="2,2,2,2"/>
			    <Panel width="820" height="400" var="panelDetail"/>
			  </Box>
			</View>;
		public function SkillPreviewViewUI(){}
		override protected function createChildren():void {
			viewClassMap["com.canaan.gameEditor.view.skill.SkillTimeLineItem"] = SkillTimeLineItem;
			createView(uiXML);
		}
	}
}