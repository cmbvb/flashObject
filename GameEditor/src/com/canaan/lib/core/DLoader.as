package com.canaan.lib.core
{
	import com.canaan.lib.interfaces.IPoolableObject;
	
	import flash.display.Loader;
	
	public class DLoader extends Loader implements IPoolableObject
	{
		protected var _data:Object;
		
		public function DLoader()
		{
			super();
		}
		
		public function poolInitialize(data:Object = null):void {
			
		}
		
		public function poolDestory():void {
			unload();
			_data = null;
		}
		
		public function set data(value:Object):void {
			_data = value;
		}
		
		public function get data():Object {
			return _data;
		}
		
		public static function fromPool():DLoader {
			return ObjectPool.get(DLoader) as DLoader;
		}
		
		public static function toPool(loader:DLoader):void {
			ObjectPool.put(loader);
		}
	}
}