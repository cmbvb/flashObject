package com.canaan.lib.utils
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.TimerManager;
	
	import flash.utils.getTimer;

	public class AcceleratorChecker
	{
		public static var maxCheckCount:int = 3;
//		public static var maxWaringCount:int = 3;
		public static var deviation:int = 20;
		
		private var timerTime:int;
		private var dateTime:int;
		private var checkCount:int;
//		private var waringCount:int;
		private var mCallback:Method;
		
		public function AcceleratorChecker(callback:Method)
		{
			mCallback = callback;
		}
		
		public function start():void {
			timerTime = getTimer();
			dateTime = new Date().time;
			TimerManager.getInstance().doFrameLoop(30, check);
		}
		
		public function stop():void {
			TimerManager.getInstance().clear(check);
		}
		
		private function check():void {
			var currTime:int = getTimer();
			var timerDelay:int = currTime - timerTime;
			var currDate:int = new Date().time;
			var dateDelay:int = currDate - dateTime;
			
			if (timerDelay - dateDelay > deviation) {
				checkCount++;
				if (checkCount >= maxCheckCount) {
					mCallback.apply();
				}
			} else {
//				if (checkCount >= maxCheckCount) {
//					waringCount++;
//					if (waringCount >= maxWaringCount) {
//						mCallback.apply();
//					}
//				}
				checkCount = 0;
			}
			
			timerTime = currTime;
			dateTime = currDate;
		}
	}
}