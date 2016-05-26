package com.canaan.lib.display
{
	import com.canaan.lib.interfaces.IPoolableObject;
	
	import flash.display.BitmapData;

	public class BitmapDataEx implements IPoolableObject
	{
		private static var mPool:Vector.<BitmapDataEx> = new Vector.<BitmapDataEx>();
		
		public var x:int;
		public var y:int;
		public var frameIndex:int;
		public var delay:int = 1;
		public var bitmapData:BitmapData;
		
		public function BitmapDataEx(bitmapData:BitmapData = null, x:int = 0, y:int = 0)
		{
			this.bitmapData = bitmapData;
			this.x = x;
			this.y = y;
		}
		
		public function poolInitialize(data:Object = null):void {
			
		}
		
		public function poolDestory():void {
			if (bitmapData) {
				bitmapData.dispose();
				bitmapData = null;
			}
			x = 0;
			y = 0;
			frameIndex = 0;
			delay = 1;
		}
		
		public static function fromPool():BitmapDataEx {
			return mPool.length != 0 ? mPool.pop() : new BitmapDataEx();
		}
		
		public static function toPool(bitmapDataEx:BitmapDataEx):void {
			bitmapDataEx.poolDestory();
			mPool.push(bitmapDataEx);
		}
	}
}