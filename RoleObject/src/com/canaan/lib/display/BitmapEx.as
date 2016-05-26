package com.canaan.lib.display
{
	import com.canaan.lib.interfaces.IPoolableObject;
	import com.canaan.lib.utils.DisplayUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class BitmapEx extends Bitmap implements IPoolableObject
	{
		protected var _bitmapDataEx:BitmapDataEx;
		
		public function BitmapEx()
		{
			super();
		}
		
		public function poolInitialize(data:Object = null):void {
			
		}
		
		public function poolDestory():void {
			bitmapData = null;
			_bitmapDataEx = null;
		}
		
		public function get bitmapDataEx():BitmapDataEx {
			return _bitmapDataEx;
		}
		
		public function set bitmapDataEx(value:BitmapDataEx):void {
			if (_bitmapDataEx != value) {
				_bitmapDataEx = value;
				if (_bitmapDataEx) {
					x = value.x;
					y = value.y;
					bitmapData = value.bitmapData;
				} else {
					bitmapData = null;
				}
			}
		}
		
		public function getIntersect(point:Point, parent:DisplayObjectContainer = null):Boolean {
			if (parent == null) {
				parent = stage;
			}
			var matrix:Matrix = DisplayUtil.gMatrix;
			matrix.identity();
			var child:DisplayObject = this;
			while (child != parent) {
				matrix.concat(child.transform.matrix);
				child = child.parent;
			}
			matrix.invert();
			var p:Point = matrix.transformPoint(point);
			return DisplayUtil.getIntersect(this, p.x, p.y);
		}
	}
}