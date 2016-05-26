package com.canaan.lib.component
{
	import flash.display.DisplayObjectContainer;

	public interface IUIComponent
	{
		function get name():String;
		function set name(value:String):void;
		
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
		
		function get width():Number;
		function set width(value:Number):void;
		
		function get height():Number;
		function set height(value:Number):void;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function get alpha():Number;
		function set alpha(value:Number):void;
		
		function get disabled():Boolean;
		function set disabled(value:Boolean):void;

		function get parent():DisplayObjectContainer;
		
		function setFocus():void;
		function sendEvent(type:String, data:Object = null):void;
	}
}