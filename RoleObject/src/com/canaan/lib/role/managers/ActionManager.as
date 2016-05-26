package com.canaan.lib.role.managers
{
	import com.canaan.lib.managers.ResManager;
	import com.canaan.lib.managers.TimerManager;
	import com.canaan.lib.role.data.ActionVo;
	import com.canaan.lib.role.interfaces.IActionProxy;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public class ActionManager
	{
		private static var canInstantiate:Boolean;
		private static var instance:ActionManager;
		
		private var mActionCache:Dictionary = new Dictionary();
		private var mActionUseDict:Dictionary = new Dictionary();
		private var mActionUseTimeDict:Dictionary = new Dictionary();
		
		private var _cacheClearTime:int = 240000;
		private var _actionProxy:IActionProxy;
		
		public function ActionManager()
		{
			if (!canInstantiate) {
				throw new Error("Can not instantiate, use getInstance() instead.");
			}
			
			TimerManager.getInstance().doLoop(10000, autoClearCache);
		}
		
		public static function getInstance():ActionManager {
			if (instance == null) {
				canInstantiate = true;
				instance = new ActionManager();
				canInstantiate = false;
			}
			return instance;
		}
		
		public function get cacheClearTime():int {
			return _cacheClearTime;
		}
		
		public function set cacheClearTime(value:int):void {
			_cacheClearTime = value;
		}
		
		public function get actionProxy():IActionProxy {
			return _actionProxy;
		}
		
		public function set actionProxy(value:IActionProxy):void {
			_actionProxy = value;
		}
		
		public function get actionCache():Dictionary {
			return mActionCache;
		}
		
		public function getAction(resId:String):ActionVo {
			var actionVo:ActionVo = mActionCache[resId];
			if (actionVo == null) {
				var headData:Object = ResManager.getInstance().getContent(resId);
				if (headData != null) {
					mActionCache[resId] = actionVo = new ActionVo();
					actionVo.resId = resId;
					actionVo.setHeadData(headData);
					ResManager.getInstance().removeActionLoader(resId);
				}
			}
			return actionVo;
		}
		
		public function removeAction(resId:String):void {
			var actionVo:ActionVo = mActionCache[resId];
			if (actionVo != null) {
				delete mActionCache[resId];
				actionVo.dispose();
			}
		}
		
		public function useAction(actionVo:ActionVo):void {
			var useCount:int = int(mActionUseDict[actionVo.resId]);
			mActionUseDict[actionVo.resId] = useCount + 1;
		}
		
		public function unUseAction(actionVo:ActionVo):void {
			var useCount:int = int(mActionUseDict[actionVo.resId]);
			if (useCount > 0) {
				mActionUseDict[actionVo.resId] = useCount - 1;
				mActionUseTimeDict[actionVo.resId] = getTimer();
			}
		}
		
		private function autoClearCache():void {
			var currentTime:int = getTimer();
			var useCount:int;
			var useTime:int;
			var ignoreList:Array = _actionProxy != null ? _actionProxy.getAutoClearIgnoreList() : null;
			var actionVo:ActionVo;
			for (var resId:String in mActionUseDict) {
				if (ignoreList != null) {
					actionVo = mActionCache[resId];
					if (ignoreList.indexOf(int(actionVo.id)) != -1) {
						continue;
					}
				}
				useCount = mActionUseDict[resId];
				if (useCount == 0) {
					useTime = mActionUseTimeDict[resId];
					if (currentTime - useTime >= _cacheClearTime) {
						delete mActionUseDict[resId];
						delete mActionUseTimeDict[resId];
						removeAction(resId);
					}
				}
			}
		}
	}
}