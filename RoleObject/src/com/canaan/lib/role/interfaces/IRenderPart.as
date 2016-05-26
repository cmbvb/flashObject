package com.canaan.lib.role.interfaces
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.display.BitmapDataEx;
	import com.canaan.lib.interfaces.ISortable;
	import com.canaan.lib.role.data.ActionVo;

	public interface IRenderPart extends ISortable
	{
		function get type():int;
		function reset():void;
		function initRenderPart(type:int = 0, actionVo:ActionVo = null):void;
		function setOffset(offsetX:Number = 0, offsetY:Number = 0):void;
		function playAction(action:int, direction:int, replay:Boolean = false, callback:Method = null):void;
		function setFrameIndex(value:int):void;
		function getFrameIndex():int;
		function setMaxFrameIndex(value:int):void;
		function getMaxFrameIndex():int;
		function nextFrame():void;
		function loadAsync(url:String, priority:int):void;
		function stopLoad():void;
		function get action():int;
		function set action(value:int):void;
		function get direction():int;
		function set direction(value:int):void;
		function get bitmapDatas():Vector.<BitmapDataEx>;
		function set bitmapDatas(value:Vector.<BitmapDataEx>):void;
	}
}