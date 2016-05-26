package com.canaan.lib.interfaces
{
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public interface IMouseClient
	{
		function get mouseClientDeep():int;
		function get mouseClientEnabled():Boolean;
		function mouseClientHitTest(point:Point):Boolean;
		function mouseClientMouseOver(event:MouseEvent):void;
		function mouseClientMouseOut(event:MouseEvent):void;
		function mouseClientMouseMove(event:MouseEvent):void;
		function mouseClientMouseDown(event:MouseEvent):void;
	}
}