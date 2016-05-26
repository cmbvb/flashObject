package com.canaan.programEditor.view.enum
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.utils.ArrayUtil;
	import com.canaan.lib.utils.StringUtil;
	import com.canaan.programEditor.data.EnumFieldVo;
	import com.canaan.programEditor.data.EnumVo;
	import com.canaan.programEditor.event.GlobalEvent;
	import com.canaan.programEditor.ui.enum.EnumFieldItemUI;
	import com.canaan.programEditor.view.common.Alert;
	
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class EnumFieldItem extends EnumFieldItemUI
	{
		private var mEnumVo:EnumVo;
		private var mEnumFieldVo:EnumFieldVo;
		
		public function EnumFieldItem()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			btnDelete.clickHandler = new Method(onDelete);
			txtValue.textField.addEventListener(FocusEvent.FOCUS_OUT, onValueFocusOut);
			txtValue.textField.addEventListener(KeyboardEvent.KEY_DOWN, onValueKeyDown);
			txtName.textField.addEventListener(FocusEvent.FOCUS_OUT, onNameFocusOut);
			txtName.textField.addEventListener(KeyboardEvent.KEY_DOWN, onNameKeyDown);
			txtDesc.textField.addEventListener(FocusEvent.FOCUS_OUT, onDescFocusOut);
			txtDesc.textField.addEventListener(KeyboardEvent.KEY_DOWN, onDescKeyDown);
		}
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mEnumVo = value.enum;
			mEnumFieldVo = value.field;
			txtValue.text = mEnumFieldVo.value.toString();
			txtName.text = mEnumFieldVo.name;
			txtDesc.text = mEnumFieldVo.desc;
		}
		
		private function onDelete():void {
			Alert.show("确定要删除吗？", Alert.TYPE_ACCEPT_CANCEL, new Method(function():void {
				ArrayUtil.removeElements(mEnumVo.fields, mEnumFieldVo);
				EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.ENUM_VIEW_REFRESH_LIST));
			}));
		}
		
		private function onValueFocusOut(event:FocusEvent):void {
			changeValue();
		}
		
		private function onValueKeyDown(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.ENTER) {
				changeValue();
			}
		}
		
		private function onNameFocusOut(event:FocusEvent):void {
			changeField();
		}
		
		private function onNameKeyDown(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.ENTER) {
				changeField();
			}
		}
		
		private function onDescFocusOut(event:FocusEvent):void {
			changeDesc();
		}
		
		private function onDescKeyDown(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.ENTER) {
				changeDesc();
			}
		}
		
		private function changeValue():void {
			var value:String = StringUtil.trim(txtValue.text);
			if (int(value) == mEnumFieldVo.value) {
				txtValue.text = mEnumFieldVo.value.toString();
				return;
			}
			if (value == "") {
				Alert.show("枚举值不能为空");
				txtValue.text = mEnumFieldVo.value.toString();
				return;
			}
			if (ArrayUtil.find(mEnumVo.fields, "value", int(value)) != null) {
				Alert.show("枚举值已存在");
				txtValue.text = mEnumFieldVo.value.toString();
				return;
			}
			mEnumFieldVo.value = int(value);
			mEnumVo.sortFields();
			EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.ENUM_FIELDS_REFRESH_LIST));
		}
		
		private function changeField():void {
			var field:String = StringUtil.trim(txtName.text);
			if (field == mEnumFieldVo.name) {
				txtName.text = mEnumFieldVo.name;
				return;
			}
			if (field == "") {
				Alert.show("字段名不能为空");
				txtName.text = mEnumFieldVo.name;
				return;
			}
			if (ArrayUtil.find(mEnumVo.fields, "name", field) != null) {
				Alert.show("字段名已存在");
				txtName.text = mEnumFieldVo.name;
				return;
			}
			mEnumFieldVo.name = field;
		}
		
		private function changeDesc():void {
			var desc:String = StringUtil.trim(txtDesc.text);
			if (desc == mEnumFieldVo.desc) {
				mEnumFieldVo.desc = desc;
				return;
			}
			mEnumFieldVo.desc = desc;
		}
		
		override public function dispose():void {
			txtValue.textField.removeEventListener(FocusEvent.FOCUS_OUT, onValueFocusOut);
			txtValue.textField.removeEventListener(KeyboardEvent.KEY_DOWN, onValueKeyDown);
			txtName.textField.removeEventListener(FocusEvent.FOCUS_OUT, onNameFocusOut);
			txtName.textField.removeEventListener(KeyboardEvent.KEY_DOWN, onNameKeyDown);
			txtDesc.textField.removeEventListener(FocusEvent.FOCUS_OUT, onDescFocusOut);
			txtDesc.textField.removeEventListener(KeyboardEvent.KEY_DOWN, onDescKeyDown);
			super.dispose();
		}
	}
}