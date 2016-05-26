package com.canaan.lib.component
{
	public interface IToolTip extends IUIComponent
	{
		function get toolTipData():Object;
		function set toolTipData(value:Object):void;
		function onToolTipShow():void;
		function onToolTipHide():void;
	}
}