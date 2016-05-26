package com.canaan.lib.managers
{
	import com.canaan.lib.animation.Tween;
	import com.canaan.lib.component.Styles;
	import com.canaan.lib.component.controls.Dialog;
	import com.canaan.lib.events.DialogEvent;
	import com.canaan.lib.utils.ArrayUtil;
	import com.canaan.lib.utils.DisplayUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class DialogManager extends Sprite
	{
		public static var maskDelay:int = 150;
		
		private static var canInstantiate:Boolean;
		private static var instance:DialogManager;
		
		private var modalMask:Sprite;
		private var dialogs:Array = [];
		private var parallelDialogs:Array = [];
		private var modals:Array = [];
		
		public function DialogManager()
		{
			if (!canInstantiate) {
				throw new Error("Can not instantiate, use getInstance() instead.");
			}
			modalMask = new Sprite();
			modalMask.graphics.beginFill(Styles.dialogModalColor, Styles.dialogModalAlpha);
			modalMask.graphics.drawRect(0, 0, 1, 1);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public static function getInstance():DialogManager {
			if (instance == null) {
				canInstantiate = true;
				instance = new DialogManager();
				canInstantiate = false;
			}
			return instance;
		}
		
		private function onAddedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			StageManager.getInstance().registerHandler(Event.RESIZE, onResize);
			onResize();
		}
		
		public function onResize():void {
			modalMask.width = StageManager.getInstance().screenWidth;
			modalMask.height = StageManager.getInstance().screenHeight;
			var dialog:Dialog;
			for each (dialog in dialogs) {
				if (dialog.popupCenter) {
					dialog.center();
				}
			}
			resizeParallel(false);
		}
		
		public function setParallelDialogs(dialogs:Array):void {
			parallelDialogs = dialogs.concat();
			for each (var dialog:Dialog in dialogs) {
				bringToFront(dialog);
			}
			resizeParallel();
		}
		
		public function resizeParallel(showAnimation:Boolean = true):void {
			var dialog:Dialog;
			var totalWidth:Number = 0;
			var maxHeight:Number = 0;
			for each (dialog in parallelDialogs) {
				totalWidth += dialog.width;
				if (dialog.height > maxHeight) {
					maxHeight = dialog.height;
				}
			}
			var screenWidth:Number = StageManager.getInstance().screenWidth;
			var screenHeight:Number = StageManager.getInstance().screenHeight;
			var xx:Number = (screenWidth - totalWidth) / 2;
			var yy:Number = (screenHeight - maxHeight) / 2;
			for each (dialog in parallelDialogs) {
				if (showAnimation) {
					dialog.moveToTween(xx, yy, maskDelay);
				} else {
					dialog.moveTo(xx, yy);
				}
				xx += dialog.width;
			}
		}
		
		public function popup(dialog:Dialog, modal:Boolean = false, x:Number = NaN, y:Number = NaN):void {
			if (modal) {
				if (!contains(modalMask)) {
					modalMask.alpha = 0;
					var maskTween:Tween = Tween.fromPool(modalMask, maskDelay);
					maskTween.fadeTo(1);
					maskTween.start();
				}
				addChild(modalMask);
				ArrayUtil.addElements(modals, dialog);
			}
			ArrayUtil.removeElements(dialogs, dialog);
			dialogs.push(dialog);
			if (!contains(dialog)) {
				if (dialog.showOpenEffect) {
					dialog.alpha = 0;
					var dialogTween:Tween = Tween.fromPool(dialog, maskDelay);
					dialogTween.fadeTo(1);
					dialogTween.start();
				}
				if (!isNaN(x) && !isNaN(y)) {
					dialog.moveTo(x, y);
				} else if (dialog.popupCenter) {
					dialog.center();
				}
			}
			addChild(dialog);
			dialog.isPopup = true;
			dispatchEvent(new DialogEvent(DialogEvent.SHOW, dialog));
		}
		
		public function close(dialog:Dialog):void {
			if (!dialog.isPopup) {
				return;
			}
			dialog.remove();
			ArrayUtil.removeElements(dialogs, dialog);
			dialog.isPopup = false;
			var modalIndex:int = modals.indexOf(dialog);
			if (modalIndex != -1) {
				modals.splice(modalIndex, 1);
				if (modals.length == 0) {
					removeChild(modalMask);
				} else {
					modalIndex = getChildIndex(modals[modals.length - 1]);
					var maskIndex:int = getChildIndex(modalMask);
					if (maskIndex > modalIndex) {
						setChildIndex(modalMask, modalIndex);
					}
				}
			}
			if (parallelDialogs.indexOf(dialog) != -1) {
				ArrayUtil.removeElements(parallelDialogs, dialog);
				resizeParallel();
			}
			dispatchEvent(new DialogEvent(DialogEvent.CLOSE, dialog));
		}
		
		public function bringToFront(dialog:Dialog):void {
			if (contains(dialog) && getChildIndex(dialog) == numChildren - 1) {
				return;
			}
			popup(dialog, false, dialog.x, dialog.y);
		}
		
		public function closeAll():void {
			var dialog:Dialog;
			while (dialogs.length > 0) {
				dialog = dialogs[0];
				dialog.close();
			}
			DisplayUtil.removeAllChildren(this);
			dialogs.length = 0;
			parallelDialogs.length = 0;
			modals.length = 0;
		}
		
		public function getAllDialogs():Array {
			return dialogs;
		}
		
		public function getParallelDialogs():Array {
			return parallelDialogs;
		}
	}
}