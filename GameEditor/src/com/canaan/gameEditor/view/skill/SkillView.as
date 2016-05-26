package com.canaan.gameEditor.view.skill
{
	import com.canaan.gameEditor.cfg.SkillResConfigVo;
	import com.canaan.gameEditor.core.GameRes;
	import com.canaan.gameEditor.event.GlobalEvent;
	import com.canaan.gameEditor.ui.skill.SkillViewUI;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.core.SysConfig;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.utils.ObjectUtil;
	import com.canaan.lib.utils.StringUtil;
	
	import flash.events.Event;
	
	public class SkillView extends SkillViewUI
	{
		private var mFilterKeywords:String;
		
		public function SkillView()
		{
			super();
		}
		
		override protected function onViewCreated():void {
			super.onViewCreated();
			txtSearch.addEventListener(Event.CHANGE, onTextChange);
			listSkills.selectHandler = new Method(onListSelect);
			btnAdd.clickHandler = new Method(onAdd);
			
			refreshList();
		}
		
		public function onShow():void {
			EventManager.getInstance().addEventListener(GlobalEvent.SKILL_VIEW_REFRESH_LIST, refreshList);
		}
		
		public function onHide():void {
			EventManager.getInstance().removeEventListener(GlobalEvent.SKILL_VIEW_REFRESH_LIST, refreshList);
		}
		
		private function onAdd():void {
			var dialog:SkillCreateDialog = new SkillCreateDialog();
			dialog.create();
			dialog.popup(true);
		}
		
		private function refreshList(event:GlobalEvent = null):void {
			var skillList:Array = ObjectUtil.objectToArray(SysConfig.getConfig(GameRes.TBL_SKILL_RES));
			if (mFilterKeywords) {
				skillList = skillList.filter(filterFunc);
			}
			skillList.sort(sortFunc);
			listSkills.array = skillList;
			onListSelect(listSkills.selectedIndex);
		}
		
		private function filterFunc(element:*, index:int, arr:Array):Boolean {
			var config:SkillResConfigVo = element as SkillResConfigVo;
			if (config.id.toString().indexOf(mFilterKeywords) == -1 && config.desc.indexOf(mFilterKeywords) == -1) {
				return false;
			}
			return true;
		}
		
		private function sortFunc(configA:SkillResConfigVo, configB:SkillResConfigVo):int {
			return configA.id > configB.id ? 1 : -1;
		}
		
		private function onTextChange(event:Event):void {
			mFilterKeywords = StringUtil.trim(txtSearch.text);
			refreshList();
		}
		
		private function onListSelect(index:int):void {
			if (index != -1) {
				skillPreview.visible = true;
				skillPreview.dataSource = listSkills.selectedItem;
			} else {
				skillPreview.visible = false;
			}
		}
	}
}