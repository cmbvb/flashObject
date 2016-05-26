package com.canaan.lib.component
{
	import flash.geom.Point;

	public interface IToolTipManagerClient extends IUIComponent
	{
		function get toolTip():Object;
		function set toolTip(value:Object):void;
		
		function get toolTipClass():Class;
		function set toolTipClass(value:Class):void;
		
		function get toolTipPosition():String;
		function set toolTipPosition(value:String):void;
		
		function get toolTipOffset():Point;
		function set toolTipOffset(value:Point):void;
	}
}