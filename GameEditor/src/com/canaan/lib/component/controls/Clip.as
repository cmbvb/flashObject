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
	import com.canaan.lib.managers.TimerManager;
	import com.canaan.lib.utils.ArrayUtil;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	
	/**图片加载后触发*/
	[Event(name="imageLoaded",type="morn.core.events.UIEvent")]
	/**当前帧发生变化后触发*/
	[Event(name="frameChanged",type="morn.core.events.UIEvent")]
	
	/**位图剪辑*/
	public class Clip extends UIComponent {
		
		private static var clipsCache:Vector.<Clip> = new Vector.<Clip>();
		protected var _autoStopAtRemoved:Boolean = true;
		protected var _bitmap:AutoBitmap;
		protected var _clipX:int = 1;
		protected var _clipY:int = 1;
		protected var _clipWidth:Number;
		protected var _clipHeight:Number;
		protected var _url:String;
		protected var _autoPlay:Boolean;
		protected var _interval:int = Styles.clipInterval;
		protected var _from:int = -1;
		protected var _to:int = -1;
		protected var _complete:Method;
		protected var _isPlaying:Boolean;
		
		/**位图切片
		 * @param url 资源类库名或者地址
		 * @param clipX x方向个数
		 * @param clipY y方向个数*/
		public function Clip(url:String = null, clipX:int = 1, clipY:int = 1) {
			_clipX = clipX;
			_clipY = clipY;
			this.url = url;
		}
		
		override protected function createChildren():void {
			addChild(_bitmap = new AutoBitmap());
		}
		
		override protected function initialize():void {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		protected function onAddedToStage(e:Event):void {
			if (_autoPlay) {
				play();
			}
		}
		
		protected function onRemovedFromStage(e:Event):void {
			if (_autoStopAtRemoved) {
				stop();
			}
		}
		
		/**位图剪辑地址*/
		public function get url():String {
			return _url;
		}
		
		public function set url(value:String):void {
			if (_url != value && Boolean(value)) {
				_url = value;
				callLater(changeClip);
			}
		}
		
		/**切片X轴数量*/
		public function get clipX():int {
			return _clipX;
		}
		
		public function set clipX(value:int):void {
			if (_clipX != value) {
				_clipX = value;
				callLater(changeClip);
			}
		}
		
		/**切片Y轴数量*/
		public function get clipY():int {
			return _clipY;
		}
		
		public function set clipY(value:int):void {
			if (_clipY != value) {
				_clipY = value;
				callLater(changeClip);
			}
		}
		
		/**单切片宽度，同时设置优先级高于clipX*/
		public function get clipWidth():Number {
			return _clipWidth;
		}
		
		public function set clipWidth(value:Number):void {
			_clipWidth = value;
			callLater(changeClip);
		}
		
		/**单切片高度，同时设置优先级高于clipY*/
		public function get clipHeight():Number {
			return _clipHeight;
		}
		
		public function set clipHeight(value:Number):void {
			_clipHeight = value;
			callLater(changeClip);
		}
		
		protected function changeClip():void {
			if (ResManager.getInstance().hasClass(_url)) {
				loadComplete(_url, ResManager.getInstance().getBitmapData(_url));
			} else {
				ResManager.getInstance().loadAsync(_url, _url, _url, new Method(loadComplete, [_url]));
			}
		}
		
		protected function loadComplete(url:String, bmd:BitmapData):void {
			if (url == _url && bmd) {
				if (!isNaN(_clipWidth)) {
					_clipX = Math.ceil(bmd.width / _clipWidth);
				}
				if (!isNaN(_clipHeight)) {
					_clipY = Math.ceil(bmd.height / _clipHeight);
				}
				ResManager.getInstance().cacheBmd(url, bmd);
				clips = ResManager.getInstance().getTiles(url, _clipX, _clipY);
			}
		}
		
		/**源位图数据*/
		public function get clips():Vector.<BitmapData> {
			return _bitmap.clips;
		}
		
		public function set clips(value:Vector.<BitmapData>):void {
			if (value) {
				_bitmap.clips = value;
				_contentWidth = _bitmap.width;
				_contentHeight = _bitmap.height;
			}
			sendEvent(UIEvent.IMAGE_LOADED);
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			_bitmap.width = value;
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			_bitmap.height = value;
		}
		
		override public function commitMeasure():void {
			exeCallLater(changeClip);
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
		
		/**当前帧*/
		public function get frame():int {
			return _bitmap.index;
		}
		
		public function set frame(value:int):void {
			_bitmap.index = value;
			sendEvent(UIEvent.FRAME_CHANGED);
			if (_bitmap.index == _to) {
				stop();
				_to = -1;
				if (_complete != null) {
					var handler:Method = _complete;
					_complete = null;
					handler.apply();
				}
			}
		}
		
		/**切片帧的总数*/
		public function get totalFrame():int {
			return _bitmap.clips ? _bitmap.clips.length : 0;
		}
		
		/**从显示列表删除后是否自动停止播放*/
		public function get autoStopAtRemoved():Boolean {
			return _autoStopAtRemoved;
		}
		
		public function set autoStopAtRemoved(value:Boolean):void {
			_autoStopAtRemoved = value;
		}
		
		/**自动播放*/
		public function get autoPlay():Boolean {
			return _autoPlay;
		}
		
		public function set autoPlay(value:Boolean):void {
			if (_autoPlay != value) {
				_autoPlay = value;
				_autoPlay ? play() : stop();
			}
		}
		
		/**动画播放间隔(单位毫秒)*/
		public function get interval():int {
			return _interval;
		}
		
		public function set interval(value:int):void {
			if (_interval != value) {
				_interval = value;
				if (_isPlaying) {
					play();
				}
			}
		}
		
		/**是否正在播放*/
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		
		public function set isPlaying(value:Boolean):void {
			_isPlaying = value;
		}
		
		/**开始播放*/
		public function play():void {
			_isPlaying = true;
			frame = _bitmap.index;
			TimerManager.getInstance().doLoop(_interval, loop);
		}
		
		protected function loop():void {
			frame++;
		}
		
		/**停止播放*/
		public function stop():void {
			TimerManager.getInstance().clear(loop);
			_isPlaying = false;
		}
		
		/**从指定的位置播放*/
		public function gotoAndPlay(frame:int):void {
			this.frame = frame;
			play();
		}
		
		/**跳到指定位置并停止*/
		public function gotoAndStop(frame:int):void {
			stop();
			this.frame = frame;
		}
		
		/**从某帧播放到某帧，播放结束发送事件
		 * @param from 开始帧(为-1时默认为第一帧)
		 * @param to 结束帧(为-1时默认为最后一帧) */
		public function playFromTo(from:int = -1, to:int = -1, complete:Method = null):void {
			_from = from == -1 ? 0 : from;
			_to = to == -1 ? _clipX * _clipY - 1 : to;
			_complete = complete;
			gotoAndPlay(_from);
		}
		
		override public function set dataSource(value:Object):void {
			_dataSource = value;
			if (value is int || value is String) {
				frame = int(value);
			} else {
				super.dataSource = value;
			}
		}
		
		/**是否对位图进行平滑处理*/
		public function get smoothing():Boolean {
			return _bitmap.smoothing;
		}
		
		public function set smoothing(value:Boolean):void {
			_bitmap.smoothing = value;
		}
		
		/**位图实体*/
		public function get bitmap():AutoBitmap {
			return _bitmap;
		}
		
		/**销毁资源
		 * @param	clearFromLoader 是否同时删除加载缓存*/
		override public function dispose():void {
			_bitmap.bitmapData = null;
			super.dispose();
		}
		
		public static function fromPool():Clip {
			return clipsCache.length != 0 ? clipsCache.pop() : new Clip();
		}
		
		public static function toPool(clip:Clip):void {
			clip.data = null;
			clip.url = null;
			clip.frame = 0;
			clip.x = 0;
			clip.y = 0;
			clip.scale = 1;
			clip.setSize(0, 0);
			clip.rotation = 0;
			clip._clipX = 1;
			clip._clipY = 1;
			clip.autoPlay = true;
			clip.stop();
			clip.remove();
			clipsCache.push(clip);
		}
		
		public static function clearPool():void {
			clipsCache.length = 0;
		}
	}
}