package com.canaan.lib.interfaces
{
	import flash.events.IEventDispatcher;

	public interface IScene extends IEventDispatcher
	{
		function enterScene():void;
		function exitScene():void;
		function get sceneName():String;
	}
}