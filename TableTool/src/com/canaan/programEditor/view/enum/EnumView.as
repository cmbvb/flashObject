package com.canaan.programEditor.view.enum
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.events.KeyEvent;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.managers.KeyboardManager;
	import com.canaan.lib.utils.StringUtil;
	import com.canaan.programEditor.core.DataCenter;
	import com.canaan.programEditor.data.EnumFieldVo;
	import com.canaan.programEditor.data.EnumVo;
	import com.canaan.programEditor.event.GlobalEvent;
	import com.canaan.programEditor.ui.enum.EnumViewUI;
	import com.canaan.programEditor.view.common.Alert;
	
	import flash.events.Event;
	import flash.ui.Keyboard;
	
	public class EnumView extends EnumViewUI
	{
		private var mFilterKeywords:String;
		
		public function EnumView()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			listEnums.selectHandler = new Method(onEnumSelect);
			btnCreate.clickHandler = new Method(onCreate);
			btnAddField.clickHandler = new Method(onAddField);
			btnSave.clickHandler = new Method(onSave);
			txtSearch.addEventListener(Event.CHANGE, onTextChange);
			
			refreshEnums();
		}
		
		public function onShow():void {
			KeyboardManager.getInstance().addEventListener(KeyEvent.KEY_DOWN, onKeyDown);
			EventManager.getInstance().addEventListener(GlobalEvent.ENUM_VIEW_REFRESH_LIST, refreshEnums);
			EventManager.getInstance().addEventListener(GlobalEvent.ENUM_FIELDS_REFRESH_LIST, refreshFields);
		}
		
		public function onHide():void {
			KeyboardManager.getInstance().removeEventListener(KeyEvent.KEY_DOWN, onKeyDown);
			EventManager.getInstance().removeEventListener(GlobalEvent.ENUM_VIEW_REFRESH_LIST, refreshEnums);
			EventManager.getInstance().removeEventListener(GlobalEvent.ENUM_FIELDS_REFRESH_LIST, refreshFields);
		}
		
		private function onKeyDown(event:KeyEvent):void {
			var keyCode:int = event.keyCode;
			var shift:Boolean = event.shiftKey;
			var ctrl:Boolean = event.ctrlKey;
			switch (keyCode) {
				case Keyboard.S:
					if (ctrl) {
						onSave();
					}
					break;
			}
		}
		
		private function refreshEnums(event:GlobalEvent = null):void {
			var enums:Array = DataCenter.enums.concat();
			if (mFilterKeywords) {
				enums = enums.filter(filterFunc);
			}
			enums.sortOn("name");
			listEnums.array = enums;
			onEnumSelect(listEnums.selectedIndex);
		}
		
		private function refreshFields(event:GlobalEvent = null):void {
			var enum:EnumVo = listEnums.selectedItem as EnumVo;
			if (enum) {
				var fields:Array = [];
				for each (var enumFieldVo:EnumFieldVo in enum.fields) {
					fields.push({enum:enum, field:enumFieldVo});
				}
				fields.sort(fieldSortFunc);
				listFields.array = fields;
			} else {
				listFields.array = null;
			}
		}
		
		private function fieldSortFunc(fieldA:Object, fieldB:Object):int {
			return fieldA.field.value > fieldB.field.value ? 1 : -1;
		}
		
		private function onEnumSelect(index:int):void {
			refreshFields();
		}
		
		private function onCreate():void {
			var dialog:EnumCreateDialog = new EnumCreateDialog();
			dialog.popup(true);
		}
		
		private function onAddField():void {
			var enum:EnumVo = listEnums.selectedItem as EnumVo;
			if (!enum) {
				Alert.show("未选中枚举类");
				return;
			}
			var dialog:EnumFieldCreateDialog = new EnumFieldCreateDialog();
			dialog.show(enum);
			dialog.popup(true);
		}
		
		private function onSave():void {
			DataCenter.saveEnums();
			Alert.show("保存成功");
		}
		
		private function onTextChange(event:Event):void {
			mFilterKeywords = StringUtil.trim(txtSearch.text);
			refreshEnums();
		}
		
		private function filterFunc(element:*, index:int, arr:Array):Boolean {
			var enumVo:EnumVo = element as EnumVo;
			if (enumVo.name.indexOf(mFilterKeywords) == -1) {
				return false;
			}
			return true;
		}
	}
}