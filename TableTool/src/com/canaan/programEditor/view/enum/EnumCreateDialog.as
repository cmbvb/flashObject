package com.canaan.programEditor.view.enum
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.utils.ArrayUtil;
	import com.canaan.lib.utils.StringUtil;
	import com.canaan.programEditor.core.DataCenter;
	import com.canaan.programEditor.data.EnumVo;
	import com.canaan.programEditor.event.GlobalEvent;
	import com.canaan.programEditor.ui.enum.EnumCreateDialogUI;
	import com.canaan.programEditor.view.common.Alert;
	
	public class EnumCreateDialog extends EnumCreateDialogUI
	{
		public function EnumCreateDialog()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			btnAccept.clickHandler = new Method(onAccept);
		}
		
		private function onAccept():void {
			var name:String = StringUtil.trim(txtName.text);
			if (ArrayUtil.find(DataCenter.enums, "name", name) != null) {
				Alert.show("枚举已存在");
				return;
			}
			
			var enumVo:EnumVo = new EnumVo();
			enumVo.name = name;
			DataCenter.enums.push(enumVo);
			
			Alert.show("创建成功！");
			EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.ENUM_VIEW_REFRESH_LIST));
			close();
		}
		
		override public function close(type:String=null):void {
			super.close(type);
			dispose();
		}
	}
}