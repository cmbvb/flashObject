/**Created by the Morn,do not modify.*/
package com.canaan.mapEditor.ui.map {
	import com.canaan.lib.component.controls.*;
	import com.canaan.mapEditor.view.map.MapObjectTreeItem;
	import com.canaan.mapEditor.view.map.MapResLibTreeItem;
	public class MapEditViewUI extends View {
		public var tabEdit:Tab;
		public var viewStack:ViewStack;
		public var rdoGridType:RadioGroup;
		public var cboGridSize:ComboBox;
		public var btnClearAll:Button;
		public var btnClearObstacle:Button;
		public var btnClearTransparent:Button;
		public var txtSet:TextInput;
		public var btnSetAll:Button;
		public var btnSetObstacle:Button;
		public var btnSetTransparent:Button;
		public var btnClearMonster:Button;
		public var btnClearNPC:Button;
		public var btnClearDecoration:Button;
		public var treeObjects:Tree;
		public var viewStackArea:ViewStack;
		public var btnCreateArea:Button;
		public var btnSaveArea:Button;
		public var treeResLib:Tree;
		protected var uiXML:XML =
			<View>
			  <Image url="png.comp.border" width="252" height="500" sizeGrid="3,3,3,3" x="0" y="25"/>
			  <Tab labels="地形编辑,地图对象,资源库" skin="png.comp.tab" x="0" y="0" var="tabEdit"/>
			  <ViewStack x="3" y="28" var="viewStack">
			    <Box name="item0">
			      <Label text="笔刷类型 (1 2 3)"/>
			      <RadioGroup x="15" y="27" var="rdoGridType" selectedIndex="0">
			        <RadioButton label="普通" skin="png.comp.radio" name="item0" data="2"/>
			        <RadioButton label="透明" skin="png.comp.radio" x="62" name="item1" data="3"/>
			        <RadioButton label="障碍" skin="png.comp.radio" x="124" name="item2" data="4"/>
			      </RadioGroup>
			      <Label text="笔刷尺寸(PageUp PageDown)" y="47"/>
			      <ComboBox labels="1,3,5,7,9" skin="png.comp.combobox" x="15" y="73" width="164" height="23" sizeGrid="10,10,50,10" visibleNum="10" selectedIndex="0" var="cboGridSize"/>
			      <Button skin="png.comp.button" x="15" y="129" label="清除所有点" width="70" height="23" var="btnClearAll"/>
			      <Button skin="png.comp.button" x="88" y="129" label="清除障碍点" width="70" height="23" var="btnClearObstacle"/>
			      <Button skin="png.comp.button" x="161" y="129" label="清除透明点" width="70" height="23" var="btnClearTransparent"/>
			      <Label text="一键清除点" y="104"/>
			      <Label text="快捷设置路点" y="160"/>
			      <Label text="设置地图边缘" x="15" y="186"/>
			      <TextInput text="20" skin="png.comp.textinput" x="93" y="186" width="22" height="22" maxChars="2" restrict="0-9" align="center" var="txtSet"/>
			      <Label text="个格子为" x="117" y="186"/>
			      <Button skin="png.comp.button" x="17" y="214" label="普通点" width="45" height="23" var="btnSetAll"/>
			      <Button skin="png.comp.button" x="66" y="214" label="障碍点" width="45" height="23" var="btnSetObstacle"/>
			      <Button skin="png.comp.button" x="115" y="214" label="透明点" width="45" height="23" var="btnSetTransparent"/>
			      <Button skin="png.comp.button" x="17" y="275" label="清除怪物" width="60" height="23" var="btnClearMonster"/>
			      <Label text="一键清除对象" y="247" x="0"/>
			      <Button skin="png.comp.button" x="80" y="275" label="清除NPC" width="60" height="23" var="btnClearNPC"/>
			      <Button skin="png.comp.button" x="143" y="275" label="清除装饰" width="60" height="23" var="btnClearDecoration"/>
			    </Box>
			    <Box name="item1" x="0" y="0">
			      <Tree width="240" height="470" var="treeObjects" x="0" y="0">
			        <MapObjectTreeItem x="0" y="1" name="render" runtime="com.canaan.mapEditor.view.map.MapObjectTreeItem"/>
			        <VScrollBar skin="png.comp.vscroll" x="223" name="scrollBar" width="17" height="470" y="0"/>
			      </Tree>
			      <ViewStack x="0" y="472" var="viewStackArea">
			        <Button skin="png.comp.button" label="创建区域" var="btnCreateArea" name="item0"/>
			        <Button skin="png.comp.button" label="保存区域" var="btnSaveArea" x="0" y="0" name="item1"/>
			      </ViewStack>
			    </Box>
			    <Box name="item2" y="0" x="0">
			      <Tree width="240" height="495" var="treeResLib">
			        <MapResLibTreeItem name="render" y="1" runtime="com.canaan.mapEditor.view.map.MapResLibTreeItem"/>
			        <VScrollBar skin="png.comp.vscroll" x="223" name="scrollBar" width="17" height="495" y="0"/>
			      </Tree>
			    </Box>
			  </ViewStack>
			  <Tab x="-279" y="235"/>
			</View>;
		public function MapEditViewUI(){}
		override protected function createChildren():void {
			viewClassMap["com.canaan.mapEditor.view.map.MapObjectTreeItem"] = MapObjectTreeItem;
			viewClassMap["com.canaan.mapEditor.view.map.MapResLibTreeItem"] = MapResLibTreeItem;
			createView(uiXML);
		}
	}
}