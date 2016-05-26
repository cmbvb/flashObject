/**Created by the Morn,do not modify.*/
package com.canaan.mapEditor.ui.map {
	import com.canaan.lib.component.controls.*;
	public class MapAttrViewUI extends View {
		public var imgBg:Image;
		public var viewStack:ViewStack;
		public var txtAreaName:TextInput;
		public var chkNonAttack:CheckBox;
		public var chkNonCrossPlayer:CheckBox;
		public var chkNonCrossMonster:CheckBox;
		public var chkNonRide:CheckBox;
		public var chkCanStall:CheckBox;
		public var txtShieldSkills:TextInput;
		public var txtShieldItems:TextInput;
		public var txtTransfer:TextInput;
		public var txtPlayMusic:TextInput;
		public var txtPlayEffect:TextInput;
		public var txtShowMessage:TextInput;
		public var txtAreaExtraData:TextInput;
		public var chkProhibitSkill:CheckBox;
		public var chkCantMove:CheckBox;
		public var chkCantDrop:CheckBox;
		public var chkCantRelive:CheckBox;
		public var chkCantDeadDrop:CheckBox;
		public var chkPKArea:CheckBox;
		public var chkRedArea:CheckBox;
		public var chkCantAutoFight:CheckBox;
		public var chkCantTeamTransfer:CheckBox;
		public var txtObjectName:TextInput;
		public var txtObjectUnitId:TextInput;
		public var txtObjectMapPos:TextInput;
		public var txtObjectRealPos:TextInput;
		public var txtObjectShowText:TextInput;
		public var txtObjectExtraData:TextInput;
		public var chkObjectFixedDir:CheckBox;
		public var chkObjectCantMove:CheckBox;
		public var txtObjectShowDelay:TextInput;
		public var btnClose:Button;
		public var btnSave:Button;
		protected var uiXML:XML =
			<View>
			  <Image url="png.comp.bg" x="0" y="0" sizeGrid="10,35,10,35" width="350" height="535" var="imgBg"/>
			  <ViewStack x="11" y="35" var="viewStack">
			    <Box name="item0">
			      <Label text="区域名称" y="1"/>
			      <TextInput skin="png.comp.textinput" x="58" var="txtAreaName"/>
			      <Label text="区域属性" y="33" x="0"/>
			      <CheckBox label="不可攻击" skin="png.comp.checkbox" x="58" y="35" var="chkNonAttack"/>
			      <CheckBox label="不可穿人" skin="png.comp.checkbox" x="127" y="35" var="chkNonCrossPlayer"/>
			      <CheckBox label="不可穿怪" skin="png.comp.checkbox" x="196" y="35" var="chkNonCrossMonster"/>
			      <CheckBox label="不可骑乘" skin="png.comp.checkbox" x="265" y="35" var="chkNonRide"/>
			      <CheckBox label="允许摆摊" skin="png.comp.checkbox" x="58" y="61" var="chkCanStall"/>
			      <Box x="55" y="138">
			        <Label text="屏蔽技能（技能表ID）"/>
			        <TextInput skin="png.comp.textinput" x="127" width="145" height="37" wordWrap="true" multiline="true" y="1" var="txtShieldSkills"/>
			        <Label text="（“|”分割）" x="27" y="17"/>
			      </Box>
			      <Box x="55" y="183">
			        <Label text="屏蔽道具（道具表ID）"/>
			        <TextInput skin="png.comp.textinput" x="127" width="145" height="37" wordWrap="true" multiline="true" y="1" var="txtShieldItems"/>
			        <Label text="（“|”分割）" x="27" y="14"/>
			      </Box>
			      <Box x="55" y="229">
			        <Label text="传送到（传送点表ID）" y="1"/>
			        <TextInput skin="png.comp.textinput" x="127" var="txtTransfer" restrict="0-9" width="145" height="22"/>
			      </Box>
			      <Box x="55" y="259">
			        <Label text="进入音乐（音效表ID）" y="1"/>
			        <TextInput skin="png.comp.textinput" x="127" var="txtPlayMusic" restrict="0-9" width="145"/>
			      </Box>
			      <Box x="55" y="289">
			        <Label text="进入音效（音效表ID）"/>
			        <TextInput skin="png.comp.textinput" x="127" var="txtPlayEffect" restrict="0-9" width="145"/>
			      </Box>
			      <Box x="55" y="319">
			        <Label text="文字提示（“|”分割）"/>
			        <TextInput skin="png.comp.textinput" x="127" var="txtShowMessage" width="145"/>
			      </Box>
			      <Label text="扩展数据" y="354" x="0"/>
			      <TextInput skin="png.comp.textinput" x="57" y="356" width="273" height="100" multiline="true" wordWrap="true" var="txtAreaExtraData"/>
			      <CheckBox label="禁止技能" skin="png.comp.checkbox" x="127" y="61" var="chkProhibitSkill" toolTip="角色站在此区域上无法使用技能，只能普通攻击"/>
			      <CheckBox label="禁止移动" skin="png.comp.checkbox" x="196" y="61" var="chkCantMove"/>
			      <CheckBox label="禁止丢弃" skin="png.comp.checkbox" x="265" y="61" var="chkCantDrop" toolTip="禁止在此区域内丢弃物品"/>
			      <CheckBox label="禁止复活" skin="png.comp.checkbox" x="58" y="87" var="chkCantRelive" toolTip="禁止在此区域内原地复活"/>
			      <CheckBox label="禁止掉落" skin="png.comp.checkbox" x="127" y="87" var="chkCantDeadDrop" toolTip="死亡后不掉落物品"/>
			      <CheckBox label="战斗区域" skin="png.comp.checkbox" x="196" y="87" var="chkPKArea" toolTip="PK不变名且不增加善恶值"/>
			      <CheckBox label="红名区" skin="png.comp.checkbox" x="265" y="87" var="chkRedArea" toolTip="加快善恶值减少"/>
			      <CheckBox label="禁止挂机" skin="png.comp.checkbox" x="58" y="112" var="chkCantAutoFight" toolTip="禁止自动挂机"/>
			      <CheckBox label="禁止天人合一" skin="png.comp.checkbox" x="127" y="112" var="chkCantTeamTransfer" toolTip="禁止使用天人合一技能"/>
			    </Box>
			    <Box name="item1" x="0" y="0">
			      <Label text="对象名称" y="1" x="0"/>
			      <TextInput skin="png.comp.textinput" x="58" var="txtObjectName" y="0"/>
			      <Label text="单位表ID" y="32" x="0"/>
			      <TextInput skin="png.comp.textinput" x="58" var="txtObjectUnitId" y="31" editable="false"/>
			      <Label text="地图坐标" y="63" x="0"/>
			      <TextInput skin="png.comp.textinput" x="58" var="txtObjectMapPos" y="62" editable="false"/>
			      <Label text="实际坐标" y="94" x="0"/>
			      <TextInput skin="png.comp.textinput" x="58" var="txtObjectRealPos" y="93" editable="false"/>
			      <Label text="显示文本" y="126" x="0"/>
			      <TextInput skin="png.comp.textinput" x="58" var="txtObjectShowText" y="125" editable="true"/>
			      <Label text="（仅装饰生效）" y="126" x="187"/>
			      <Label text="扩展数据" y="189" x="0"/>
			      <TextInput skin="png.comp.textinput" x="58" y="191" width="273" height="100" multiline="true" wordWrap="true" var="txtObjectExtraData"/>
			      <CheckBox label="强制设定方向" skin="png.comp.checkbox" x="0" y="301" var="chkObjectFixedDir"/>
			      <CheckBox label="不可移动" skin="png.comp.checkbox" x="99" y="301" var="chkObjectCantMove"/>
			      <Label text="显示间隔" y="158" x="0"/>
			      <TextInput skin="png.comp.textinput" x="58" var="txtObjectShowDelay" y="157" editable="true"/>
			      <Label text="（仅装饰生效 单位：秒）" y="158" x="187"/>
			    </Box>
			  </ViewStack>
			  <Button skin="png.comp.button" x="262" y="500" var="btnClose" label="关闭"/>
			  <Button skin="png.comp.button" x="180" y="500" var="btnSave" label="保存"/>
			</View>;
		public function MapAttrViewUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}