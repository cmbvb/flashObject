package com.canaan.lib.interfaces
{
	import com.canaan.lib.core.Method;

	public interface IAnimation
	{
		function play():void;
		function stop():void;
		function gotoAndStop(value:int):void;
		function gotoAndPlay(value:int):void;
		function prevFrame():void;
		function nextFrame():void;
		function fromTo(from:Object = null, to:Object = null, loop:Boolean = false, onComplete:Method = null):void;
		function get autoRemoved():Boolean;
		function set autoRemoved(value:Boolean):void;
		function get interval():int;
		function set interval(value:int):void;
		function get index():int;
		function set index(value:int):void;
		function get maxIndex():int;
		function get isPlaying():Boolean;
	}
}