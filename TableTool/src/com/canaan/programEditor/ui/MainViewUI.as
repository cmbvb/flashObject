/**Created by the Morn,do not modify.*/
package com.canaan.programEditor.ui {
	import com.canaan.lib.component.controls.*;
	import com.canaan.programEditor.view.enum.EnumView;
	import com.canaan.programEditor.view.protocol.ProtocolView;
	import com.canaan.programEditor.view.table.TableView;
	public class MainViewUI extends View {
		public var imgBg:Image;
		public var tab:Tab;
		public var viewStack:ViewStack;
		public var btnSetting:Button;
		public var btnRelease:Button;
		protected var uiXML:XML =
			<View>
			  <Image url="png.comp.bg2" x="5" y="35" sizeGrid="5,5,5,5" width="1430" height="860" var="imgBg"/>
			  <Tab labels="数据管理器,枚举管理器,协议管理器" skin="png.comp.tab" x="10" y="10" var="tab"/>
			  <ViewStack x="5" y="35" var="viewStack">
			    <TableView x="0" y="0" name="item0" runtime="com.canaan.programEditor.view.table.TableView"/>
			    <EnumView x="0" y="0" name="item1" runtime="com.canaan.programEditor.view.enum.EnumView"/>
			    <ProtocolView x="0" y="0" name="item2" runtime="com.canaan.programEditor.view.protocol.ProtocolView"/>
			  </ViewStack>
			  <Button skin="png.comp.button_setting" x="1401" y="1" var="btnSetting" toolTip="设置"/>
			  <Button skin="png.comp.button" x="1363" y="1" sizeGrid="5,5,5,5" width="32" height="32" label="发布" var="btnRelease" toolTip="发布资源 快捷键F12"/>
			</View>;
		public function MainViewUI(){}
		override protected function createChildren():void {
			viewClassMap["com.canaan.programEditor.view.enum.EnumView"] = EnumView;
			viewClassMap["com.canaan.programEditor.view.protocol.ProtocolView"] = ProtocolView;
			viewClassMap["com.canaan.programEditor.view.table.TableView"] = TableView;
			createView(uiXML);
		}
	}
}