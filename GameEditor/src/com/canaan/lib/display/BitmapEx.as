package com.canaan.lib.display
{
	import com.canaan.lib.interfaces.IPoolableObject;
	import com.canaan.lib.utils.DisplayUtil;
	import com.canaan.lib.utils.MathUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * 基于矩阵转换的Bitmap
	 * 
	 */
	public class BitmapEx extends Bitmap implements IPoolableObject
	{
		protected var _pivotX:Number = 0;					// 中心点x坐标
		protected var _pivotY:Number = 0;					// 中心点y坐标
		protected var _offsetX:Number = 0;					// x偏移
		protected var _offsetY:Number = 0;					// y偏移
		protected var _scaleX:Number = 1;					// x缩放
		protected var _scaleY:Number = 1;					// y缩放
		protected var _rotation:Number = 0;					// 旋转角度
		protected var _radRotation:Number = 0;				// 旋转弧度
		protected var _bitmapDataEx:BitmapDataEx;
		protected var matrix:Matrix = new Matrix();
		
		public function BitmapEx()
		{
			super();
		}
		
		public function poolInitialize(data:Object = null):void {
			
		}
		
		public function poolDestory():void {
			_pivotX = 0;
			_pivotY = 0;
			_offsetX = 0;
			_offsetY = 0;
			_scaleX = 1;
			_scaleY = 1;
			_rotation = 0;
			_radRotation = 0;
			_bitmapDataEx = null;
			matrix.identity();
		}
		
		public function get bitmapDataEx():BitmapDataEx {
			return _bitmapDataEx;
		}
		
		public function set bitmapDataEx(value:BitmapDataEx):void {
			_bitmapDataEx = value;
			_offsetX = value.x;
			_offsetY = value.y;
			bitmapData = value.bitmapData;
			updateMatrix();
		}
		
		public function get pivotX():Number {
			return _pivotX;
		}
		
		public function get pivotY():Number {
			return _pivotY;
		}
		
		public function get offsetX():Number {
			return _offsetX;
		}
		
		public function get offsetY():Number {
			return _offsetY;
		}
		
		override public function get scaleX():Number {
			return _scaleX;
		}
		
		override public function set scaleX(value:Number):void {
			if (_scaleX != value) {
				_scaleX = value;
				updateMatrix();
			}
		}
		
		override public function get scaleY():Number {
			return _scaleY;
		}
		
		override public function set scaleY(value:Number):void {
			if (scaleY != value) {
				scaleY = value;
				updateMatrix();
			}
		}
		
		override public function get rotation():Number {
			return _radRotation;
		}
		
		override public function set rotation(value:Number):void {
			if (_rotation != value) {
				_rotation = value;
				_radRotation = MathUtil.angleToRadian(_rotation);
			}
			updateMatrix();
		}
		
		override public function set x(value:Number):void {
			throw new Error("Please use pivotX");
		}
		
		override public function set y(value:Number):void {
			throw new Error("Please use pivotY");
		}
		
		override public function set rotationX(value:Number):void {
			throw new Error("Please use rotation");
		}
		
		override public function set rotationY(value:Number):void {
			throw new Error("Please use rotation");
		}
		
		override public function set rotationZ(value:Number):void {
			throw new Error("Please use rotation");
		}
		
		public function setPivotXY(pivotX:Number, pivotY:Number):void {
			_pivotX = pivotX;
			_pivotY = pivotY;
			updateMatrix();
		}
		
		public function setScale(scaleX:Number, scaleY:Number):void {
			_scaleX = scaleX;
			_scaleY = scaleY;
			updateMatrix();
		}
		
		protected function updateMatrix():void {
			matrix.identity();
			matrix.translate(_offsetX, _offsetY);
			matrix.scale(_scaleX, _scaleY);
			matrix.rotate(_radRotation);
			matrix.translate(_pivotX, _pivotY);
			transform.matrix = matrix;
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