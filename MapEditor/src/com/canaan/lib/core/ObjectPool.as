package com.canaan.lib.core
{
	import com.canaan.lib.interfaces.IPoolableObject;
	import com.canaan.lib.utils.ClassUtil;
	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	public class ObjectPool
	{
		public static var DEFAULT_MAX_POOL_SIZE:int = 5;
		public static var DEFAULT_GROWTH_VALUE:int = 5;
		
		private static var pools:Dictionary = new Dictionary();
		
		public function ObjectPool()
		{
		}

		/**
		 * 初始化对象池
		 */
		public static function initialize(maxPoolSize:uint, growthValue:uint, clazz:Class):void {
			var newPool:PoolItem = new PoolItem(maxPoolSize, growthValue, clazz);
			var i:uint = maxPoolSize;
			while (--i > -1) {
				newPool.pool[i] = ClassUtil.createNewInstance(clazz) as IPoolableObject;
			}
			
			var className:String = getQualifiedClassName(clazz);
			pools[className] = newPool;
		}
		
		/**
		 * 根据类名获取对象
		 */
		public static function get(clazz:Class, data:Object = null):IPoolableObject {
			var className:String = getQualifiedClassName(clazz);
			if (!pools[className]) {
				initialize(DEFAULT_MAX_POOL_SIZE, DEFAULT_GROWTH_VALUE, clazz);
			}
			
			var poolItem:PoolItem = pools[className];
			if (poolItem.counter > 0) {
				var poolableObject:IPoolableObject = poolItem.pool[--poolItem.counter];
				poolableObject.poolInitialize.apply(null, data);
				return poolableObject;
			}
			
			var i:uint = poolItem.growthValue;
			while (--i > -1) {
				poolItem.pool.unshift(ClassUtil.createNewInstance(clazz));
			}
			poolItem.counter = poolItem.growthValue;
			return get(clazz, data);
		}
		
		/**
		 * 回收对象
		 */
		public static function put(poolableObject:IPoolableObject):void {
			poolableObject.poolDestory();
			var className:String = getQualifiedClassName(poolableObject);
			var poolItem:PoolItem = pools[className];
			if (poolItem) {
				poolItem.pool[poolItem.counter++] = poolableObject;
			}
		}
	}
}

import com.canaan.lib.interfaces.IPoolableObject;

class PoolItem
{
	public var counter:uint;
	public var growthValue:uint;
	public var clazz:Class;
	public var pool:Vector.<IPoolableObject>;
	
	public function PoolItem(maxPoolSize:uint, growthValue:uint, clazz:Class)
	{
		this.counter = maxPoolSize;
		this.growthValue = growthValue;
		this.clazz = clazz;
		pool = new Vector.<IPoolableObject>(counter);
	}
}