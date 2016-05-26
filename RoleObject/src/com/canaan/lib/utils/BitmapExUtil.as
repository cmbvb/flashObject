package com.canaan.lib.utils
{
	import com.canaan.lib.display.BitmapDataEx;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class BitmapExUtil
	{
		/**
		 * 将displayObject转换为BitmapDataEx 
		 * @param source
		 * @param scale
		 * @return 
		 * 
		 */		
		public static function createBitmapDataEx(source:DisplayObject, scale:Number = 1):BitmapDataEx {
			var rect:Rectangle = source.getBounds(source);
			var x:int = rect.x * scale;
			var y:int = rect.y * scale;
			if (rect.isEmpty()) {
				rect.width = 1;
				rect.height = 1;
			}
			var width:Number = Math.ceil(rect.width * scale);
			var height:Number = Math.ceil(rect.height * scale);
			var bitmapData:BitmapData = new BitmapData(width, height, true, 0x00000000);
			var matrix:Matrix = DisplayUtil.gMatrix;
			matrix.identity();
			matrix.a = scale;
			matrix.d = scale;
			matrix.tx = -x;
			matrix.ty = -y;
			bitmapData.draw(source, matrix, null, null, null, true);
			
			// 获取draw出的bitmapData的真实可视矩形
			var realRect:Rectangle = DisplayUtil.getVisualRect(bitmapData);
			// 如果真是可视矩形不为空
			if (!realRect.isEmpty()) {
				// 如果真实可视矩形bitmapData尺寸不一致则说明bitmapData中存在透明像素
				if ((bitmapData.width != realRect.width || bitmapData.height != realRect.height)) {
					// 将bitmapData中非透明像素拷贝到一个新的bitmapData中
					var rectBitmapData:BitmapData = new BitmapData(realRect.width, realRect.height, true, 0x00000000);
					var point:Point = DisplayUtil.gPoint;
					point.x = 0;
					point.y = 0;
					rectBitmapData.copyPixels(bitmapData, realRect, point);
					bitmapData.dispose();
					bitmapData = rectBitmapData;
					x += realRect.x;
					y += realRect.y;
				}
			} else {
				var emptyBitmapData:BitmapData = new BitmapData(1, 1, true, 0x00000000);
				bitmapData.dispose();
				bitmapData = emptyBitmapData;
			}
			
			return new BitmapDataEx(bitmapData, x, y);
		}
		
		/**
		 * 将displayObject转换为BitmapDataEx序列 
		 * @param source
		 * @param scale
		 * @return 
		 * 
		 */		
		public static function createSequence(source:DisplayObject, scale:Number = 1):Vector.<BitmapDataEx> {
			var sequence:Vector.<BitmapDataEx> = new Vector.<BitmapDataEx>();
			var movieClip:MovieClip = source as MovieClip;
			if (movieClip != null) {
				var totalFrames:int = movieClip.totalFrames;
				var bitmapDataEx:BitmapDataEx;
				for (var i:int = 0; i < totalFrames; i++) {
					movieClip.gotoAndStop(i + 1);
					bitmapDataEx = createBitmapDataEx(movieClip, scale);
					bitmapDataEx.frameIndex = i;
					sequence.push(bitmapDataEx);
				}
			} else {
				sequence.push(createBitmapDataEx(source, scale));
			}
			return sequence;
		}
		
		/**
		 * 将序列帧图片转换为 BitmapDataEx序列 
		 * @param source
		 * @param x
		 * @param y
		 * @return 
		 * 
		 */		
		public static function createSequence2(source:BitmapData, x:int, y:int):Vector.<BitmapDataEx> {
			var point:Point = DisplayUtil.gPoint;
			point.x = 0;
			point.y = 0;
			var rect:Rectangle = DisplayUtil.gRect;
			var sequence:Vector.<BitmapDataEx> = new Vector.<BitmapDataEx>();
			var width:int = Math.max(source.width / x, 1);
			var height:int = Math.max(source.height / y, 1);
			var bmd:BitmapData;
			
			for (var i:int = 0; i < x; i++) {
				for (var j:int = 0; j < y; j++) {
					bmd = new BitmapData(width, height);
					rect.setTo(i * width, j * height, width, height);
					bmd.copyPixels(source, rect, point);
					sequence.push(new BitmapDataEx(bmd));
				}
			}
			return sequence;
		}
	}
}