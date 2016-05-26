package module.mainUI
{
	import flash.events.MouseEvent;
	
	import base.EventManager;
	
	import enumeration.EnumEvent;
	import enumeration.EnumRoleDirection;
	
	import morn.core.handlers.Handler;
	
	import uiCreate.mainUI.mainControlBottomLeftUI;
	
	public class MainControlBottomLeft extends mainControlBottomLeftUI
	{
		public function MainControlBottomLeft()
		{
			super();
		}
		
		override protected function initialize():void {
			btnLeft.addEventListener(MouseEvent.MOUSE_DOWN, onBtnLeft);
			btnRight.addEventListener(MouseEvent.MOUSE_DOWN, onBtnRight);
			btnUp.addEventListener(MouseEvent.MOUSE_DOWN, onBtnUp);
			btnJump.clickHandler = new Handler(onBtnJump);
		}
		
		private function onBtnLeft(event:MouseEvent):void {
			EventManager.ins.dispatchEvent(new EnumEvent(EnumEvent.ROLE_MOVE_EVENT, EnumRoleDirection.LEFT));
			btnLeft.addEventListener(MouseEvent.MOUSE_UP, onMoveEnd);
			btnLeft.addEventListener(MouseEvent.MOUSE_OUT, onMoveEnd);
		}
		
		private function onBtnRight(event:MouseEvent):void {
			EventManager.ins.dispatchEvent(new EnumEvent(EnumEvent.ROLE_MOVE_EVENT, EnumRoleDirection.RIGHT));
			btnRight.addEventListener(MouseEvent.MOUSE_UP, onMoveEnd);
			btnRight.addEventListener(MouseEvent.MOUSE_OUT, onMoveEnd);
		}
		
		private function onBtnUp(event:MouseEvent):void {
			EventManager.ins.dispatchEvent(new EnumEvent(EnumEvent.ROLE_MOVE_EVENT));
			btnUp.addEventListener(MouseEvent.MOUSE_UP, onMoveEnd);
			btnUp.addEventListener(MouseEvent.MOUSE_OUT, onMoveEnd);
		}
		
		private function onBtnJump():void {
			EventManager.ins.dispatchEvent(new EnumEvent(EnumEvent.ROLE_JUMP_EVENT));
		}
		
		private function onMoveEnd(event:MouseEvent):void {
			EventManager.ins.dispatchEvent(new EnumEvent(EnumEvent.ROLE_MOVEEND_EVENT));
			btnLeft.removeEventListener(MouseEvent.MOUSE_UP, onMoveEnd);
			btnLeft.removeEventListener(MouseEvent.MOUSE_OUT, onMoveEnd);
			btnRight.removeEventListener(MouseEvent.MOUSE_UP, onMoveEnd);
			btnRight.removeEventListener(MouseEvent.MOUSE_OUT, onMoveEnd);
			btnUp.removeEventListener(MouseEvent.MOUSE_UP, onMoveEnd);
			btnUp.removeEventListener(MouseEvent.MOUSE_OUT, onMoveEnd);
		}
		
	}
}