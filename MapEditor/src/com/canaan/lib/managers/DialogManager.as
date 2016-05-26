package com.canaan.lib.managers
{
	import com.canaan.lib.animation.Tween;
	import com.canaan.lib.component.Styles;
	import com.canaan.lib.component.controls.Dialog;
	import com.canaan.lib.utils.ArrayUtil;
	import com.canaan.lib.utils.DisplayUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class DialogManager extends Sprite
	{
		public static var maskDelay:int = 250;
		
		private static var canInstantiate:Boolean;
		private static var instance:DialogManager;
		
		private var modalMask:Sprite;
		private var dialogs:Vector.<Dialog> = new Vector.<Dialog>();
		private var parallelDialogs:Vector.<Dialog> = new Vector.<Dialog>();
		private var modals:Vector.<Dialog> = new Vector.<Dialog>();
		
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
			resizeParallel();
		}
		
		public function resizeParallel():void {
			var dialog:Dialog;
			var totalWidth:Number = 0;
			for each (dialog in parallelDialogs) {
				totalWidth += dialog.width;
			}
			var screenWidth:Number = StageManager.getInstance().screenWidth;
			var screenHeight:Number = StageManager.getInstance().screenHeight;
			var xx:Number = (screenWidth - totalWidth) / 2;
			for each (dialog in parallelDialogs) {
				dialog.moveTo(xx, (screenHeight - dialog.height) / 2);
				xx += dialog.width;
			}
		}
		
		public function popup(dialog:Dialog, modal:Boolean = false, closeOthers:Boolean = false, closeExcludedList:Array = null, x:Number = NaN, y:Number = NaN, showAnimation:Boolean = true):void {
			if (closeOthers) {
				var other:Dialog;
				for (var i:int = dialogs.length - 1; i >= 0; i--) {
					other = dialogs[i];
					if (other != dialog && (closeExcludedList == null || closeExcludedList.indexOf(other) == -1)) {
						other.close();
					}
				}
			}
			if (modal) {
				if (!contains(modalMask)) {
					if (showAnimation) {
						modalMask.alpha = 0;
						var maskTween:Tween = Tween.fromPool(modalMask, maskDelay);
						maskTween.fadeTo(1);
						maskTween.start();
					} else {
						modalMask.alpha = 1;
					}
				}
				addChild(modalMask);
				ArrayUtil.addElements(modals, dialog);
			}
			ArrayUtil.removeElements(dialogs, dialog);
			dialogs.push(dialog);
			if (!contains(dialog)) {
				if (showAnimation) {
					dialog.alpha = 0;
					var dialogTween:Tween = Tween.fromPool(dialog, maskDelay);
					dialogTween.fadeTo(1);
					dialogTween.start();
				} else {
					dialog.alpha = 1;
				}
				if (!isNaN(x) && !isNaN(y)) {
					dialog.moveTo(x, y);
				} else if (dialog.popupCenter) {
					dialog.center();
				}
			}
			addChild(dialog);
			if (!dialog.isPopup && dialog.isParallelDisplay) {
				ArrayUtil.addElements(parallelDialogs, dialog);
				resizeParallel();
			}
			dialog.isPopup = true;
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
			if (dialog.isParallelDisplay) {
				ArrayUtil.removeElements(parallelDialogs, dialog);
				resizeParallel();
			}
		}
		
		public function hasPopup(clazz:Class):Boolean {
			for each (var dialog:Dialog in dialogs) {
				if (dialog is clazz) {
					return true;
				}
			}
			return false;
		}
		
		public function bringToFront(dialog:Dialog):void {
			if (contains(dialog) && getChildIndex(dialog) == numChildren - 1) {
				return;
			}
			popup(dialog, false, false, null, dialog.x, dialog.y);
		}
		
		public function closeAll():void {
			var dialog:Dialog;
			for (var i:int = dialogs.length - 1; i >= 0; i--) {
				dialog = dialogs[i];
				dialog.close();
			}
			DisplayUtil.removeAllChildren(this);
			dialogs.length = 0;
			parallelDialogs.length = 0;
			modals.length = 0;
		}
		
		public function getAllDialogs():Vector.<Dialog> {
			return dialogs;
		}
	}
}