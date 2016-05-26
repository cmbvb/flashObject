/**
 * Morn UI Version 2.5.1215 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package com.canaan.lib.component.controls {
	import com.canaan.lib.component.Styles;
	import com.canaan.lib.component.UIComponent;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.events.UIEvent;
	import com.canaan.lib.managers.ResManager;
	import com.canaan.lib.utils.ArrayUtil;
	
	import flash.display.BitmapData;
	
	/**图片被加载后触发*/
	[Event(name="imageLoaded",type="morn.core.events.UIEvent")]
	
	/**图像类*/
	public class Image extends UIComponent {
		
		private static var imagePool:Vector.<Image> = new Vector.<Image>();
		
		protected var _bitmap:AutoBitmap;
		protected var _url:String;
		protected var _imageLoadedHandler:Method;
		protected var _external:Boolean;
		
		public function Image(url:String = null) {
			this.url = url;
		}
		
		override protected function createChildren():void {
			super.createChildren();
			addChild(_bitmap = new AutoBitmap());
		}
		
		/**图片地址*/
		public function get url():String {
			return _url;
		}
		
		public function set url(value:String):void {
			if (_url != value) {
				_url = value;
				callLater(changeUrl);
			}
		}
		
		public function changeUrl():void {
			bitmapData = null;
			if (_url) {
//				if (ResManager.getInstance().hasClass(_url)) {
				if (_external == false && _url.indexOf("externalImage") == -1) {
					bitmapData = ResManager.getInstance().getBitmapData(_url);
				} else {
					var fullUrl:String = ResManager.formatExternalImageUrl(_url);
					ResManager.getInstance().load(fullUrl, fullUrl, fullUrl, new Method(setBitmapData, [_url]));
				}
			}
		}
		
		public function get imageLoadedHandler():Method {
			return _imageLoadedHandler;
		}
		
		public function set imageLoadedHandler(value:Method):void {
			_imageLoadedHandler = value;
		}
		
		public function get external():Boolean {
			return _external;
		}
		
		public function set external(value:Boolean):void {
			_external = value;
		}
		
		/**源位图数据*/
		public function get bitmapData():BitmapData {
			return _bitmap.bitmapData;
		}
		
		public function set bitmapData(value:BitmapData):void {
			if (value) {
				_contentWidth = value.width;
				_contentHeight = value.height;
			}
			_bitmap.bitmapData = value;
			if (_imageLoadedHandler != null) {
				_imageLoadedHandler.apply();
			}
			sendEvent(UIEvent.IMAGE_LOADED);
		}
		
		protected function setBitmapData(url:String, bmd:BitmapData):void {
			if (url == _url) {
				bitmapData = bmd;
			}
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			_bitmap.width = width;
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			_bitmap.height = height;
		}
		
		/**九宫格信息(格式:左边距,上边距,右边距,下边距)*/
		public function get sizeGrid():String {
			if (_bitmap.sizeGrid) {
				return _bitmap.sizeGrid.join(",");
			}
			return null;
		}
		
		public function set sizeGrid(value:String):void {
			_bitmap.sizeGrid = ArrayUtil.copyAndFill(Styles.defaultSizeGrid, value);
		}
		
		/**位图控件实例*/
		public function get bitmap():AutoBitmap {
			return _bitmap;
		}
		
		/**是否对位图进行平滑处理*/
		public function get smoothing():Boolean {
			return _bitmap.smoothing;
		}
		
		public function set smoothing(value:Boolean):void {
			_bitmap.smoothing = value;
		}
		
		override public function commitMeasure():void {
			exeCallLater(changeUrl);
		}
		
		override public function set dataSource(value:Object):void {
			_dataSource = value;
			if (value is String) {
				url = String(value);
			} else {
				super.dataSource = value;
			}
		}
		
		/**销毁资源
		 * @param	clearFromLoader 是否同时删除加载缓存*/
		override public function dispose():void {
			_bitmap.bitmapData = null;
			_imageLoadedHandler = null;
			super.dispose();
		}
		
		public static function fromPool():Image {
			return imagePool.length != 0 ? imagePool.pop() : new Image();
		}
		
		public static function toPool(image:Image):void {
			image.data = null;
			image.url = null;
			image.x = 0;
			image.y = 0;
			image.scale = 1;
			image.setSize(NaN, NaN);
			image.rotation = 0;
			image.smoothing = false;
			image.imageLoadedHandler = null;
			image.bitmap.sizeGrid = null;
			imagePool.push(image);
		}
		
		public static function clearPool():void {
			imagePool.length = 0;
		}
	}
}