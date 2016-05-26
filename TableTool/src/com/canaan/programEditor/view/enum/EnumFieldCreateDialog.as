package com.canaan.programEditor.view.enum
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.utils.ArrayUtil;
	import com.canaan.lib.utils.StringUtil;
	import com.canaan.programEditor.data.EnumFieldVo;
	import com.canaan.programEditor.data.EnumVo;
	import com.canaan.programEditor.event.GlobalEvent;
	import com.canaan.programEditor.ui.enum.EnumFieldCreateDialogUI;
	import com.canaan.programEditor.view.common.Alert;
	
	public class EnumFieldCreateDialog extends EnumFieldCreateDialogUI
	{
		private var mEnumVo:EnumVo;
		
		public function EnumFieldCreateDialog()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			btnAccept.clickHandler = new Method(onAccept);
		}
		
		public function show(enumVo:EnumVo):void {
			mEnumVo = enumVo;
			var fields:Array = mEnumVo.fields;
			var value:int = fields.length > 0 ? fields[fields.length - 1].value + 1 : 0;
			txtValue.text = value.toString();
		}
		
		private function onAccept():void {
			var field:String = StringUtil.trim(txtField.text);
			if (field == "") {
				Alert.show("字段名不能为空");
				return;
			}
			var value:String = StringUtil.trim(txtValue.text);
			if (value == "") {
				Alert.show("枚举值不能为空");
				return;
			}
			if (ArrayUtil.find(mEnumVo.fields, "name", field) != null) {
				Alert.show("字段名已存在");
				return;
			}
			if (ArrayUtil.find(mEnumVo.fields, "value", int(value)) != null) {
				Alert.show("枚举值已存在");
				return;
			}
			var desc:String = StringUtil.trim(txtDesc.text);
			
			var enumFieldVo:EnumFieldVo = new EnumFieldVo();
			enumFieldVo.name = field;
			enumFieldVo.value = int(value);
			enumFieldVo.desc = desc;
			mEnumVo.fields.push(enumFieldVo);
			mEnumVo.sortFields();
			
			EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.ENUM_FIELDS_REFRESH_LIST));
			close();
		}
		
		override public function close(type:String=null):void {
			super.close(type);
			dispose();
		}
	}
}