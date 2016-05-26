package com.canaan.lib.utils
{
	import com.canaan.lib.interfaces.IDispose;
	import com.canaan.lib.managers.StageManager;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class DisplayUtil
	{
		public static const GRAY_FILTER:ColorMatrixFilter = new ColorMatrixFilter([	
			0.3086,	0.6094, 0.0820, 0,	0,
			0.3086, 0.6094, 0.0820, 0,	0,
			0.3086, 0.6094, 0.0820, 0,	0,
			0,		0,		0,		1,	0
		]);
		
		public static var gMatrixArray:Array = [];
		public static var gMatrix:Matrix = new Matrix();
		public static var gRect:Rectangle = new Rectangle();
		public static var gPoint:Point = new Point();
		public static var gBitmapData:BitmapData = new BitmapData(1, 1, true, 0xFFFFFFFF);
		
		public static function gray(target:DisplayObject, isGray:Boolean = true):void {
			if (isGray) {
				addFilter(target, GRAY_FILTER);
			} else {
				removeFilter(target, ColorMatrixFilter);
			}
		}

		public static function getColorMatrixFilter(r:Number, g:Number, b:Number, alpha:Number):ColorMatrixFilter {
			gMatrixArray = 	[alpha,	0,		0,		0,		r,
							0,		alpha,	0,		0, 		g,
							0,		0,		alpha,	0,		b,
							0,		0,		0,		1,		0];
			return new ColorMatrixFilter(gMatrixArray);
		}
		
		public static function removeChild(parent:DisplayObjectContainer, child:DisplayObject, dispose:Boolean = false):void {
			if (parent != null && child != null) {
				if (parent.contains(child)) {
					parent.removeChild(child);
					if (dispose) {
						if (child is IDispose) {
							IDispose(child).dispose();
						}
					}
				}
			}
		}
		
		public static function removeAllChildren(container:DisplayObjectContainer, dispose:Boolean = false):void {
			if (container != null) {
				for (var i:int = container.numChildren - 1; i > -1; i--) {
					removeChild(container, container.getChildAt(i), dispose);
				}
			}
		}
		
		public static function center(target:DisplayObject, offsetX:Number = 0, offsetY:Number = 0):void {
			var x:Number = (StageManager.getInstance().screenWidth - target.width) * 0.5;
			var y:Number = (StageManager.getInstance().screenHeight - target.height) * 0.5;
			x += offsetX;
			y += offsetY;
			target.x = x;
			target.y = y;
		}
		
		public static function centerToParent(target:DisplayObject, offsetX:Number = 0, offsetY:Number = 0):void {
			var parent:DisplayObjectContainer = target.parent;
			if (parent != null) {
				var x:Number = (parent.width - target.width) * 0.5;
				var y:Number = (parent.height - target.height) * 0.5;
				x += offsetX;
				y += offsetY;
				target.x = x;
				target.y = y;
			}
		}
		
		public static function fullScreen(value:Boolean):void {
			if (value) {
				if (StageManager.getInstance().stage.displayState == StageDisplayState.NORMAL) {
					StageManager.getInstance().stage.displayState = StageDisplayState.FULL_SCREEN;
				}
			} else {
				if (StageManager.getInstance().stage.displayState == StageDisplayState.FULL_SCREEN) {
					StageManager.getInstance().stage.displayState = StageDisplayState.NORMAL;
				}
			}
        }

        public static function stopAllMovieClip(container:DisplayObjectContainer):void {
        	if (container != null) {
        		if (container is MovieClip) {
        			MovieClip(container).stop();
        		}
        		var child:DisplayObject;
				for (var i:int = 0; i < container.numChildren; i++) {
        			child = container.getChildAt(i);
        			if (child is DisplayObjectContainer) {
        				stopAllMovieClip(child as DisplayObjectContainer);
        			}
        			i++;
        		}
        	}
        }
        
        public static function startAllMovieClip(container:DisplayObjectContainer):void {
        	if (container != null) {
        		if (container is MovieClip) {
        			MovieClip(container).play();
        		}
				var child:DisplayObject;
				for (var i:int = 0; i < container.numChildren; i++) {
        			child = container.getChildAt(i);
        			if (child is DisplayObjectContainer) {
        				startAllMovieClip(child as DisplayObjectContainer);
        			}
        			i++;
        		}
        	}
        }
        
		public static function horizontalFlip(source:BitmapData, target:BitmapData):BitmapData {
			if (target == null) {
				target = new BitmapData(source.width, source.height, true, 0x00FFFFFF);
			}
			gMatrix.identity();
			gMatrix.a = -1;
			gMatrix.tx = source.width;
			target.draw(source, gMatrix);
			return target;
		}
		
		public static function verticalFlip(source:BitmapData, target:BitmapData):BitmapData {
			if (target == null) {
				target = new BitmapData(source.width, source.height, true, 0x00FFFFFF);
			}
			gMatrix.identity();
			gMatrix.d = -1;
			gMatrix.ty = source.width;
			target.draw(source, gMatrix);
			return target;
		}
		
		public static function addFilter(target:DisplayObject, filter:BitmapFilter):void {
			var filters:Array = target.filters;
			filters.push(filter);
			target.filters = filters;
		}
		
		public static function removeFilter(target:DisplayObject, filterType:Class):void {
			var filters:Array = target.filters;
			var l:int = filters.length;
			if (l > 0) {
				var filter:BitmapFilter;
				for (var i:int = l - 1; i >= 0; i--) {
					filter = filters[i];
					if (filter is filterType) {
						filters.splice(i, 1);
					}
				}
				target.filters = filters;
			}
		}
		
		/**
		 * yungzhu的创建切片方法
		 */
		public static function createTiles(source:BitmapData, x:int, y:int):Vector.<BitmapData> {
			var tiles:Vector.<BitmapData> = new Vector.<BitmapData>();
			var width:int = Math.max(source.width / x, 1);
			var height:int = Math.max(source.height / y, 1);
			var bmd:BitmapData;
			gPoint.x = 0;
			gPoint.y = 0;
			for (var i:int = 0; i < x; i++) {
				for (var j:int = 0; j < y; j++) {
					bmd = new BitmapData(width, height);
					gRect.setTo(i * width, j * height, width, height);
					bmd.copyPixels(source, gRect, gPoint);
					tiles.push(bmd);
				}
			}
			return tiles;
		}
		
		/**
		 * yungzhu的九宫格处理方法
		 * 
		 */
		public static function scale9Bmd(bmd:BitmapData, sizeGrid:Array, width:int, height:int):BitmapData {
			if (bmd.width == width && bmd.height == height) {
				return bmd;
			}
			if (width < 1 || height < 1) {
				return null;
			}
			
			var gw:int = int(sizeGrid[0]) + int(sizeGrid[2]);
			var gh:int = int(sizeGrid[1]) + int(sizeGrid[3]);
			var newBmd:BitmapData = new BitmapData(width, height, bmd.transparent, 0x00000000);
			
			if (width > gw && height > gh) {
				gRect.setTo(sizeGrid[0], sizeGrid[1], bmd.width - sizeGrid[0] - sizeGrid[2], bmd.height - sizeGrid[1] - sizeGrid[3]);
				var rows:Array = [0, gRect.top, gRect.bottom, bmd.height];
				var cols:Array = [0, gRect.left, gRect.right, bmd.width];
				var newRows:Array = [0, gRect.top, height - (bmd.height - gRect.bottom), height];
				var newCols:Array = [0, gRect.left, width - (bmd.width - gRect.right), width];
				var newRectWidth:Number;
				var newRectHeight:Number;
				var newRectX:Number;
				var newRectY:Number;
				for (var i:int = 0; i < 3; i++) {
					for (var j:int = 0; j < 3; j++) {
						gRect.setTo(cols[i], rows[j], cols[i + 1] - cols[i], rows[j + 1] - rows[j]);
						newRectWidth = gRect.width;
						newRectHeight = gRect.height;
						newRectX = gRect.x;
						newRectY = gRect.y;
						gRect.setTo(newCols[i], newRows[j], newCols[i + 1] - newCols[i], newRows[j + 1] - newRows[j]);
						gMatrix.identity();
						gMatrix.a = gRect.width / newRectWidth;
						gMatrix.d = gRect.height / newRectHeight;
						gMatrix.tx = gRect.x - newRectX * gMatrix.a;
						gMatrix.ty = gRect.y - newRectY * gMatrix.d;
						newBmd.draw(bmd, gMatrix, null, null, gRect, true);
					}
				}
			} else {
				gMatrix.identity();
				gMatrix.a = width / bmd.width;
				gMatrix.d = height / bmd.height;
				gRect.setTo(0, 0, width, height);
				newBmd.draw(bmd, gMatrix, null, null, gRect, true);
			}
			return newBmd;
		}
		
		public static function getColor(displayObject:DisplayObject, x:int, y:int):uint {
			gBitmapData.fillRect(gBitmapData.rect, 0xFFFFFF);
			gMatrix.identity();
			gMatrix.tx = -x;
			gMatrix.ty = -y;
			gBitmapData.draw(displayObject, gMatrix);
			return gBitmapData.getPixel(0, 0);
		}
		
		public static function getIntersect(displayObject:DisplayObject, x:int, y:int):Boolean {
			gBitmapData.fillRect(gBitmapData.rect, 0);
			gMatrix.identity();
			gMatrix.tx = -x;
			gMatrix.ty = -y;
			gBitmapData.draw(displayObject, gMatrix);
			var color:int = gBitmapData.getPixel32(0, 0) >> 24 & 0xFF;
			if (color > 0) {
				return true;
			}
			return false;
		}
		
		public static function getVisualRect(bitmapData:BitmapData):Rectangle {
			return bitmapData.getColorBoundsRect(0xFF000000, 0, false);
		}
		
		public static function drawAlphaBackground(graphics:Graphics, width:Number, height:Number):void {
			graphics.clear();
			graphics.beginFill(0xffffff, 0);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
		
		/**
		 * 设置亮度
		 * @param displayObject
		 * @param value
		 * 
		 */		
		public static function setBrightness(displayObject:DisplayObject, value:Number):void {
			var colorTransform:ColorTransform = displayObject.transform.colorTransform;
			if (value >= 0) {
				colorTransform.redMultiplier = 1 - value;
				colorTransform.greenMultiplier = 1 - value;
				colorTransform.blueMultiplier = 1 - value;
				colorTransform.redOffset = 255 * value;
				colorTransform.greenOffset = 255 * value;
				colorTransform.blueOffset = 255 * value;
			} else {
				value = Math.abs(value);
				colorTransform.redMultiplier = 1 - value;
				colorTransform.greenMultiplier = 1 - value;
				colorTransform.blueMultiplier = 1 - value;
				colorTransform.redOffset = 0;
				colorTransform.greenOffset = 0;
				colorTransform.blueOffset = 0;
			}
			displayObject.transform.colorTransform = colorTransform;
		}
	}
}