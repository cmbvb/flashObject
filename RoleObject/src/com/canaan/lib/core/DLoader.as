package com.canaan.lib.core
{
	import com.canaan.lib.interfaces.IDispose;
	import com.canaan.lib.interfaces.IPoolableObject;
	
	import flash.display.Loader;
	
	public class DLoader extends Loader implements IPoolableObject, IDispose
	{
		private static var mPool:Vector.<DLoader> = new Vector.<DLoader>();
		
		protected var _data:Object;
		
		public function DLoader()
		{
			super();
		}
		
		public function poolInitialize(data:Object = null):void {
			
		}
		
		public function poolDestory():void {
			dispose();
		}
		
		public function set data(value:Object):void {
			_data = value;
		}
		
		public function get data():Object {
			return _data;
		}
		
		public function dispose():void {
			unload();
			unloadAndStop();
			_data = null;
		}
		
		public static function fromPool():DLoader {
			return mPool.length != 0 ? mPool.pop() : new DLoader();
		}
		
		public static function toPool(loader:DLoader):void {
			loader.poolDestory();
			mPool.push(loader);
		}
	}
}