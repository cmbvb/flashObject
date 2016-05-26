package com.canaan.lib.core
{
	import com.canaan.lib.interfaces.IFactory;
	import com.canaan.lib.utils.ClassUtil;
	
	public class ClassFactory implements IFactory
	{
		public var generator:Class;
		public var properties:Object;
		public var args:Array = null;
		
		public function ClassFactory(generator:Class = null)
	    {
			super();
	    	this.generator = generator;
	    }

		public function newInstance():* {
			var instance:Object = ClassUtil.createNewInstance(generator, args);
	
	        if (properties != null) {
	        	for (var p:String in properties) {
	        		instance[p] = properties[p];
				}
	       	}
	       	return instance;
		}
	}
}