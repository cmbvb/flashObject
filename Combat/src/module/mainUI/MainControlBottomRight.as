package module.mainUI
{
	import base.EventManager;
	
	import enumeration.EnumEvent;
	
	import morn.core.handlers.Handler;
	
	import uiCreate.mainUI.mainControlBottomRightUI;
	
	public class MainControlBottomRight extends mainControlBottomRightUI
	{
		public function MainControlBottomRight()
		{
			super();
		}
		
		override protected function initialize():void {
			btnSkill.clickHandler = new Handler(onBtnSkill);
		}
		
		private function onBtnSkill():void {
			EventManager.ins.dispatchEvent(new EnumEvent(EnumEvent.ROLE_SKILL_EVENT));
		}
		
	}
}