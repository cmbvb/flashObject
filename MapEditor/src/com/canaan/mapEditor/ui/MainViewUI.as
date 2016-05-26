/**Created by the Morn,do not modify.*/
package com.canaan.mapEditor.ui {
	import com.canaan.lib.component.controls.*;
	import com.canaan.mapEditor.view.map.MapAttrView;
	import com.canaan.mapEditor.view.map.MapEditView;
	import com.canaan.mapEditor.view.map.MapMiniView;
	import com.canaan.mapEditor.view.map.MapView;
	public class MainViewUI extends View {
		public var containerSetting:Box;
		public var btnSetting:Button;
		public var containerEdit:Box;
		public var imgBg:Image;
		public var miniView:MapMiniView;
		public var editView:MapEditView;
		public var chkShowGrid:CheckBox;
		public var chkShowObjectInfo:CheckBox;
		public var chkShowObjectLayer:CheckBox;
		public var chkShowAreaLayer:CheckBox;
		public var chkShowBlockLayer:CheckBox;
		public var containerButton:Box;
		public var btnCreate:Button;
		public var btnOpen:Button;
		public var btnSave:Button;
		public var btnOutput:Button;
		public var btnOutputMini:Button;
		public var mapView:MapView;
		public var mapAttrView:MapAttrView;
		protected var uiXML:XML =
			<View>
			  <Box x="1401" y="1" var="containerSetting">
			    <Button skin="png.comp.button_setting" var="btnSetting" toolTip="设置"/>
			  </Box>
			  <Box var="containerEdit" x="1185" y="35">
			    <Image url="png.comp.blank" width="258" height="889" var="imgBg" x="0" y="0"/>
			    <MapMiniView x="3" y="3" runtime="com.canaan.mapEditor.view.map.MapMiniView" var="miniView"/>
			    <MapEditView x="3" y="292" runtime="com.canaan.mapEditor.view.map.MapEditView" var="editView"/>
			    <CheckBox label="F1显示网格" skin="png.comp.checkbox" x="7" y="824" var="chkShowGrid"/>
			    <CheckBox label="F2显示对象信息" skin="png.comp.checkbox" x="104" y="824" var="chkShowObjectInfo"/>
			    <CheckBox label="F3显示对象层" skin="png.comp.checkbox" x="7" y="844" var="chkShowObjectLayer" selected="true"/>
			    <CheckBox label="F4显示区域层" skin="png.comp.checkbox" x="104" y="844" var="chkShowAreaLayer" selected="true"/>
			    <CheckBox label="F5显示地形层" skin="png.comp.checkbox" x="7" y="864" var="chkShowBlockLayer" selected="true"/>
			  </Box>
			  <Box x="5" y="5" var="containerButton">
			    <Button skin="png.comp.button" label="新建" width="40" var="btnCreate"/>
			    <Button skin="png.comp.button" x="45" label="打开" width="40" var="btnOpen"/>
			    <Button skin="png.comp.button" x="90" label="保存" width="40" var="btnSave"/>
			    <Button skin="png.comp.button" x="135" label="切图" width="40" var="btnOutput"/>
			    <Button skin="png.comp.button" x="180" label="生成缩略图" var="btnOutputMini"/>
			  </Box>
			  <MapView x="0" y="35" var="mapView" runtime="com.canaan.mapEditor.view.map.MapView"/>
			  <MapAttrView x="0" y="364" var="mapAttrView" runtime="com.canaan.mapEditor.view.map.MapAttrView"/>
			</View>;
		public function MainViewUI(){}
		override protected function createChildren():void {
			viewClassMap["com.canaan.mapEditor.view.map.MapAttrView"] = MapAttrView;
			viewClassMap["com.canaan.mapEditor.view.map.MapEditView"] = MapEditView;
			viewClassMap["com.canaan.mapEditor.view.map.MapMiniView"] = MapMiniView;
			viewClassMap["com.canaan.mapEditor.view.map.MapView"] = MapView;
			createView(uiXML);
		}
	}
}