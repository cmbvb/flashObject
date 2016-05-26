/**Created by the Morn,do not modify.*/
package com.canaan.programEditor.ui {
	import com.canaan.lib.component.controls.*;
	public class SettingDialogUI extends Dialog {
		public var btnAccept:Button;
		public var imgBg:Image;
		public var tab:Tab;
		public var viewStack:ViewStack;
		public var txtTempleOutputServer:TextInput;
		public var btnTempleOutputServer:Button;
		public var txtTempleOutputClient:TextInput;
		public var btnTempleOutputClient:Button;
		public var txtTempleServerImport:TextArea;
		public var txtTempleClientImport:TextArea;
		public var txtTempleServerNameSpace:TextInput;
		public var txtEnumOutputServer:TextInput;
		public var btnEnumOutputServer:Button;
		public var txtEnumOutputClient:TextInput;
		public var btnEnumOutputClient:Button;
		public var txtEnumServerImport:TextArea;
		public var txtEnumClientImport:TextArea;
		public var txtEnumServerNameSpace:TextInput;
		public var txtTableInput:TextInput;
		public var btnTableInput:Button;
		public var txtSettingInput:TextInput;
		public var btnSettingInput:Button;
		public var txtTableOutputServer:TextInput;
		public var btnTableOutputServer:Button;
		public var txtTableOutputClient:TextInput;
		public var btnTableOutputClient:Button;
		public var txtTableOutputSetting:TextInput;
		public var btnTableOutputSetting:Button;
		public var txtProtocolOutputServer:TextInput;
		public var btnProtocolOutputServer:Button;
		public var txtProtocolOutputClient:TextInput;
		public var btnProtocolOutputClient:Button;
		public var txtProtocolServerImport:TextArea;
		public var txtProtocolClientImport:TextArea;
		public var txtProtocolServerNameSpace:TextInput;
		protected var uiXML:XML =
			<Dialog>
			  <Image url="png.comp.bg" x="0" y="0" sizeGrid="5,30,5,30" width="700" height="500"/>
			  <Image url="png.comp.blank" x="0" y="1" width="668" height="26" name="drag"/>
			  <Button skin="png.comp.btn_close" x="669" y="3" name="close"/>
			  <Button skin="png.comp.button" x="312" y="460" var="btnAccept" label="确定"/>
			  <Image url="png.comp.bg2" x="6" y="59" sizeGrid="5,5,5,5" width="687" height="387" var="imgBg"/>
			  <Tab labels="数据管理器,模板管理器,枚举管理器,协议管理器" skin="png.comp.tab" x="11" y="34" var="tab"/>
			  <ViewStack x="10" y="70" var="viewStack">
			    <Box x="0" name="item1" y="0">
			      <Label text="导出设置(不填不导)"/>
			      <Label text="服务器模板目录：" x="45" y="35"/>
			      <TextInput skin="png.comp.textinput" x="155" y="35" sizeGrid="5,5,5,5" width="380" height="22" var="txtTempleOutputServer"/>
			      <Button skin="png.comp.button" x="550" y="34" var="btnTempleOutputServer" label="选择"/>
			      <Label text="客户端模板目录：" x="45" y="65"/>
			      <TextInput skin="png.comp.textinput" x="155" y="64" sizeGrid="5,5,5,5" width="380" height="22" var="txtTempleOutputClient"/>
			      <Button skin="png.comp.button" x="550" y="63" var="btnTempleOutputClient" label="选择"/>
			      <Label text="服务器命名空间导入：" x="21" y="125"/>
			      <Label text="客户端包导入：" x="57" y="247"/>
			      <TextArea skin="png.comp.textarea" x="155" y="125" width="380" height="100" sizeGrid="5,5,5,5" var="txtTempleServerImport"/>
			      <TextArea skin="png.comp.textarea" x="155" y="245" width="380" height="100" sizeGrid="5,5,5,5" var="txtTempleClientImport"/>
			      <Label text="服务器命名空间：" x="45" y="95"/>
			      <TextInput skin="png.comp.textinput" x="155" y="94" sizeGrid="5,5,5,5" width="380" height="22" var="txtTempleServerNameSpace"/>
			    </Box>
			    <Box x="0" name="item2" y="0">
			      <Label text="导出设置(不填不导)"/>
			      <Label text="服务器枚举目录：" x="45" y="35"/>
			      <TextInput skin="png.comp.textinput" x="155" y="35" sizeGrid="5,5,5,5" width="380" height="22" var="txtEnumOutputServer"/>
			      <Button skin="png.comp.button" x="550" y="34" var="btnEnumOutputServer" label="选择"/>
			      <Label text="客户端枚举目录：" x="45" y="65"/>
			      <TextInput skin="png.comp.textinput" x="155" y="64" sizeGrid="5,5,5,5" width="380" height="22" var="txtEnumOutputClient"/>
			      <Button skin="png.comp.button" x="550" y="63" var="btnEnumOutputClient" label="选择"/>
			      <Label text="服务器命名空间导入：" x="21" y="125"/>
			      <Label text="客户端包导入：" x="57" y="247"/>
			      <TextArea skin="png.comp.textarea" x="155" y="125" width="380" height="100" sizeGrid="5,5,5,5" var="txtEnumServerImport"/>
			      <TextArea skin="png.comp.textarea" x="155" y="245" width="380" height="100" sizeGrid="5,5,5,5" var="txtEnumClientImport"/>
			      <Label text="服务器命名空间：" x="45" y="95"/>
			      <TextInput skin="png.comp.textinput" x="155" y="94" sizeGrid="5,5,5,5" width="380" height="22" var="txtEnumServerNameSpace"/>
			    </Box>
			    <Box name="item0" x="0" y="0">
			      <Label text="数据表目录：" x="45" y="35"/>
			      <TextInput skin="png.comp.textinput" x="155" y="35" sizeGrid="5,5,5,5" width="380" height="22" var="txtTableInput"/>
			      <Button skin="png.comp.button" x="550" y="34" var="btnTableInput" label="选择"/>
			      <Label text="设置数据表目录：" x="45" y="65"/>
			      <TextInput skin="png.comp.textinput" x="155" y="64" sizeGrid="5,5,5,5" width="380" height="22" var="txtSettingInput"/>
			      <Button skin="png.comp.button" x="550" y="63" var="btnSettingInput" label="选择"/>
			      <Label text="导入设置(不填不导)" x="0"/>
			      <Image url="png.comp.blank" y="142" width="680" height="1"/>
			      <Label text="导出设置(不填不导)" x="0" y="153"/>
			      <Label text="服务器数据表目录：" x="45" y="188"/>
			      <TextInput skin="png.comp.textinput" x="157" y="188" sizeGrid="5,5,5,5" width="380" height="22" var="txtTableOutputServer"/>
			      <Button skin="png.comp.button" x="550" y="187" var="btnTableOutputServer" label="选择"/>
			      <Label text="客户端数据表目录：" x="45" y="218"/>
			      <TextInput skin="png.comp.textinput" x="157" y="217" sizeGrid="5,5,5,5" width="380" height="22" var="txtTableOutputClient"/>
			      <Button skin="png.comp.button" x="550" y="216" var="btnTableOutputClient" label="选择"/>
			      <Label text="设置数据表目录：" x="43" y="247"/>
			      <TextInput skin="png.comp.textinput" x="157" y="246" sizeGrid="5,5,5,5" width="380" height="22" var="txtTableOutputSetting"/>
			      <Button skin="png.comp.button" x="550" y="245" var="btnTableOutputSetting" label="选择"/>
			    </Box>
			    <Box x="0" name="item3" y="0">
			      <Label text="导出设置(不填不导)"/>
			      <Label text="服务器协议目录：" x="45" y="35"/>
			      <TextInput skin="png.comp.textinput" x="155" y="35" sizeGrid="5,5,5,5" width="380" height="22" var="txtProtocolOutputServer"/>
			      <Button skin="png.comp.button" x="550" y="34" var="btnProtocolOutputServer" label="选择"/>
			      <Label text="客户端协议目录：" x="45" y="65"/>
			      <TextInput skin="png.comp.textinput" x="155" y="64" sizeGrid="5,5,5,5" width="380" height="22" var="txtProtocolOutputClient"/>
			      <Button skin="png.comp.button" x="550" y="63" var="btnProtocolOutputClient" label="选择"/>
			      <Label text="服务器命名空间导入：" x="21" y="125"/>
			      <Label text="客户端包导入：" x="57" y="247"/>
			      <TextArea skin="png.comp.textarea" x="155" y="125" width="380" height="100" sizeGrid="5,5,5,5" var="txtProtocolServerImport"/>
			      <TextArea skin="png.comp.textarea" x="155" y="245" width="380" height="100" sizeGrid="5,5,5,5" var="txtProtocolClientImport"/>
			      <Label text="服务器命名空间：" x="45" y="95"/>
			      <TextInput skin="png.comp.textinput" x="155" y="94" sizeGrid="5,5,5,5" width="380" height="22" var="txtProtocolServerNameSpace"/>
			    </Box>
			  </ViewStack>
			</Dialog>;
		public function SettingDialogUI(){}
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}