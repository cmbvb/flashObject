package com.canaan.lib.interfaces
{
	public interface IPoolableObject
	{
		function poolInitialize(data:Object = null):void;
		function poolDestory():void;
	}
}