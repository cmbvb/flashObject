package com.canaan.lib.interfaces
{
	import flash.events.IEventDispatcher;

	public interface IModule extends IEventDispatcher
	{
		function addedToScene(sceneName:String):void;
		function removeFromScene():void;
		function get sceneName():String;
	}
}