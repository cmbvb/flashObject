/**Created by the Morn,do not modify.*/
package com.canaan.gameEditor.ui.skill {
	import com.canaan.lib.component.controls.*;
	import com.canaan.gameEditor.view.skill.SkillTimeLineItem;
	public class SkillCreateDialogUI extends Dialog {
		public var txtID:TextInput;
		public var txtRole:TextInput;
		public var txtDesc:TextArea;
		public var btnInfoRoleChoose:Button;
		public var lblRoleDesc:Label;
		public var cboRoleAction:ComboBox;
		public var containerEdit:Box;
		public var listTimeLine:List;
		public var txtReleaseId:TextInput;
		public var btnRelease:Button;
		public var txtReleaseFrame:TextInput;
		public var txtDirectionId:TextInput;
		public var btnDirection:Button;
		public var txtDirectionFrame:TextInput;
		public var txtMissileId:TextInput;
		public var btnMissile:Button;
		public var txtMissileFrame:TextInput;
		public var cboMissileType:ComboBox;
		public var containerMissileSpeed:Box;
		public var txtMissileSpeed:TextInput;
		public var txtMissileHitId:TextInput;
		public var btnMissileHit:Button;
		public var btnPlay:Button;
		public var txtCurrentFrame:Label;
		public var txtSeconds:Label;
		public var panelDetail:Panel;
		public var btnSave:Button;
		public var chkLockTarget:CheckBox;
		public var chkNonTargetSelf:CheckBox;
		public var chkUnLockTarget:CheckBox;
		protected var uiXML:XML =
			<Dialog>
			  <Image url="png.comp.bg" x="0" y="0" sizeGrid="5,30,5,30" width="1100" height="750"/>
			  <Image url="png.comp.blank" x="0" y="0" width="1066" height="26" name="drag"/>
			  <Button skin="png.comp.btn_close" x="1069" y="3" name="close"/>
			  <Box x="12" y="32">
			    <Image url="png.comp.bg2" sizeGrid="5,5,5,5" width="212" height="645" x="1" y="23"/>
			    <Label text="编号：" x="11" y="34"/>
			    <TextInput skin="png.comp.textinput" x="54" y="33" width="150" height="22" sizeGrid="10,10,10,10" var="txtID"/>
			    <Label text="角色：" x="11" y="64"/>
			    <TextInput skin="png.comp.textinput" x="54" y="63" width="58" sizeGrid="10,10,10,10" var="txtRole" editable="true" height="22"/>
			    <Label text="备注：" x="11" y="142"/>
			    <TextArea skin="png.comp.textarea" x="54" y="143" width="150" height="100" scrollBarSkin="png.comp.vscroll" sizeGrid="10,10,10,10" var="txtDesc"/>
			    <Label text="(仅做动作演示，可重用于任何角色)" x="12" y="87" color="0xff0000"/>
			    <Label text="技能信息"/>
			    <Button skin="png.comp.button" x="174" y="62" label="选择" var="btnInfoRoleChoose" width="30" height="23"/>
			    <Label text="未备注" x="115" y="64" width="60" height="18" var="lblRoleDesc"/>
			    <Label text="动作：" x="11" y="112"/>
			    <ComboBox labels="待机,走路" skin="png.comp.combobox" x="54" y="111" width="150" height="23" sizeGrid="10,10,50,10" selectedIndex="0" var="cboRoleAction" scrollBarSkin="png.comp.vscroll" visibleNum="10"/>
			  </Box>
			  <Box x="12" y="294"/>
			  <Box x="235" y="32">
			    <Image url="png.comp.bg2" sizeGrid="5,5,5,5" width="846" height="645" x="1" y="23"/>
			    <Label text="技能编辑"/>
			    <Box x="16" y="36" var="containerEdit">
			      <List var="listTimeLine" repeatX="50" repeatY="2">
			        <SkillTimeLineItem name="render" runtime="com.canaan.gameEditor.view.skill.SkillTimeLineItem"/>
			      </List>
			      <Box y="98" x="0">
			        <Label text="自身特效" y="1"/>
			        <TextInput skin="png.comp.textinput" x="64" y="1" sizeGrid="5,5,5,5" width="65" height="22" restrict="0-9" var="txtReleaseId"/>
			        <Button skin="png.comp.button" x="133" width="30" height="23" sizeGrid="5,5,5,5" label="选择" y="0" var="btnRelease"/>
			        <Label text="帧" x="208" y="1"/>
			        <TextInput skin="png.comp.textinput" x="187" y="1" sizeGrid="5,5,5,5" width="20" height="22" restrict="0-9" maxChars="2" var="txtReleaseFrame" text="0"/>
			        <Label text="第" x="170" y="1"/>
			      </Box>
			      <Box y="126" x="0">
			        <Label text="8方向特效" y="1"/>
			        <TextInput skin="png.comp.textinput" x="64" y="1" sizeGrid="5,5,5,5" width="65" height="22" restrict="0-9" var="txtDirectionId"/>
			        <Button skin="png.comp.button" x="133" width="30" height="23" sizeGrid="5,5,5,5" label="选择" var="btnDirection"/>
			        <Label text="帧" x="208" y="1"/>
			        <TextInput skin="png.comp.textinput" x="187" y="1" sizeGrid="5,5,5,5" width="20" height="22" restrict="0-9" maxChars="2" var="txtDirectionFrame" text="0"/>
			        <Label text="第" x="170" y="1" width="16" height="19"/>
			      </Box>
			      <Box y="154" x="0">
			        <Label text="飞行特效" y="1"/>
			        <TextInput skin="png.comp.textinput" x="64" y="1" sizeGrid="5,5,5,5" width="65" height="22" restrict="0-9" var="txtMissileId"/>
			        <Button skin="png.comp.button" x="133" width="30" height="23" sizeGrid="5,5,5,5" label="选择" y="0" var="btnMissile"/>
			        <Label text="帧" x="208" y="1"/>
			        <TextInput skin="png.comp.textinput" x="187" y="1" sizeGrid="5,5,5,5" width="20" height="22" restrict="0-9" maxChars="2" var="txtMissileFrame" text="0"/>
			        <Label text="第" x="170" y="1"/>
			        <Label text="飞行特效类型" x="232" y="2"/>
			        <ComboBox labels="1(有轨迹 例如火符),2(无轨迹不黏人 例如雷电),3(无轨迹黏人 例如毒)" skin="png.comp.combobox" x="316" y="1" width="160" height="23" sizeGrid="10,10,50,10" selectedIndex="0" var="cboMissileType" scrollBarSkin="png.comp.vscroll"/>
			        <Box x="482" y="2" var="containerMissileSpeed">
			          <Label text="飞行速度" y="2"/>
			          <TextInput skin="png.comp.textinput" x="54" sizeGrid="5,5,5,5" width="49" height="22" restrict="0-9" maxChars="4" var="txtMissileSpeed" text="1000"/>
			        </Box>
			      </Box>
			      <Box y="182" x="0">
			        <Label text="撞击特效" y="1"/>
			        <TextInput skin="png.comp.textinput" x="64" y="1" sizeGrid="5,5,5,5" width="65" height="22" restrict="0-9" var="txtMissileHitId"/>
			        <Button skin="png.comp.button" x="133" width="30" height="23" sizeGrid="5,5,5,5" label="选择" var="btnMissileHit"/>
			      </Box>
			      <Box x="640" y="135">
			        <Label text="手动填写特效或按键插入特效：" x="7" size="10" multiline="false" wordWrap="false" isHtml="false" y="0"/>
			        <Label text="自身特效 F6:插入 SHIFT+F6 移除" x="6" y="17" size="10"/>
			        <Label text="8方向特效 F7:插入 SHIFT+F7 移除" y="34" size="10"/>
			        <Label text="飞行特效 F8:插入 SHIFT+F8 移除" x="6" y="51" size="10"/>
			      </Box>
			      <Label text="(飞行特效撞击敌人后自动播放)" x="173" y="183"/>
			      <Box x="478" y="100">
			        <Button skin="png.comp.button" x="247" label="播放" var="btnPlay"/>
			        <Label text="当前帧索引" y="1"/>
			        <Label text="50/50" x="68" y="1" var="txtCurrentFrame" align="left" width="35" height="18" color="0xff0000"/>
			        <Label text="时间" x="118" y="1"/>
			        <Label text="0.333s/0.333s" x="150" y="1" var="txtSeconds" color="0xff0000"/>
			      </Box>
			      <Box x="0" y="218">
			        <Image url="png.comp.borderBlank" width="820" height="400" sizeGrid="2,2,2,2"/>
			        <Panel width="820" height="400" var="panelDetail"/>
			      </Box>
			    </Box>
			  </Box>
			  <Button skin="png.comp.button" x="1007" y="712" var="btnSave" label="保存"/>
			  <CheckBox label="永久锁定目标(一般单体技能设置)" skin="png.comp.checkbox" x="21" y="291" var="chkLockTarget"/>
			  <CheckBox label="无目标时对自己使用(如治愈术)" skin="png.comp.checkbox" x="21" y="333" var="chkNonTargetSelf"/>
			  <CheckBox label="不锁定目标(如群隐，打防)" skin="png.comp.checkbox" x="21" y="312" var="chkUnLockTarget"/>
			</Dialog>;
		public function SkillCreateDialogUI(){}
		override protected function createChildren():void {
			viewClassMap["com.canaan.gameEditor.view.skill.SkillTimeLineItem"] = SkillTimeLineItem;
			createView(uiXML);
		}
	}
}