/**
 * Morn UI Version 2.4.1020 http://www.mornui.com/
 * Feedback yungzhu@gmail.com http://weibo.com/newyung
 */
package com.canaan.lib.component.controls {
	import com.canaan.lib.component.Styles;
	import com.canaan.lib.component.UIComponent;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.events.UIEvent;
	import com.canaan.lib.managers.ResManager;
	import com.canaan.lib.managers.TimerManager;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**当前帧发生变化后触发*/
	[Event(name="frameChanged",type="morn.core.events.UIEvent")]
	
	/**矢量动画类(为了统一，frame从0开始与movieclip不同)*/
	public class FrameClip extends UIComponent {
		protected var _autoStopAtRemoved:Boolean = true;
		protected var _mc:MovieClip;
		protected var _skin:String;
		protected var _frame:int;
		protected var _autoPlay:Boolean;
		protected var _autoRemove:Boolean;
		protected var _autoStop:Boolean;
		protected var _autoDispose:Boolean;
		protected var _interval:int = Styles.clipInterval;
		protected var _from:Object;
		protected var _to:Object;
		protected var _needPlay:Boolean;
		protected var _complete:Method;
		protected var _isPlaying:Boolean;
		
		public function FrameClip(skin:String = null) {
			this.skin = skin;
		}
		
		override protected function initialize():void {
			super.initialize();
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
		
		/**资源*/
		public function get skin():String {
			return _skin;
		}
		
		public function set skin(value:String):void {
			if (_skin != value) {
				_skin = value;
				callLater(changeSkin);
			}
		}
		
		protected function changeSkin():void {
			if (_skin) {
				if (ResManager.getInstance().hasClass(_skin)) {
					mc = ResManager.getInstance().getNewInstance(_skin);
				} else {
					mc = null;
					var fullUrl:String = ResManager.formatExternalSwfUrl(_skin);
					ResManager.getInstance().load(fullUrl, fullUrl, fullUrl, new Method(loadComplete));
				}
			}
		}
		
		protected function loadComplete():void {
			mc = ResManager.getInstance().getNewInstance(_skin);
			if (_needPlay) {
				playFromTo(_from, _to, _complete);
			}
		}
		
		/**矢量动画*/
		public function get mc():MovieClip {
			return _mc;
		}
		
		public function set mc(value:MovieClip):void {
			if (_mc != value) {
				if (_mc && _mc.parent) {
					_mc.stop();
					removeChild(_mc);
				}
				_mc = value;
				if (_needPlay) {
					if (_to == null) {
						_to = _mc.totalFrames - 1;
					}
				}
				if (_mc) {
					_mc.stop();
					addChild(_mc);
					_contentWidth = mc.width;
					_contentHeight = mc.height;
					mc.width = width;
					mc.height = height;
				}
			}
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			if (_mc) {
				_mc.width = _width;
			}
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			if (_mc) {
				_mc.height = _height;
			}
		}
		
		/**当前帧(为了统一，frame从0开始，原始的movieclip从1开始)*/
		public function get frame():int {
			return _frame;
		}
		
		public function set frame(value:int):void {
			_frame = value;
			if (_mc) {
				_frame = (_frame < _mc.totalFrames && _frame > -1) ? _frame : 0;
				if (_frame + 1 != _mc.currentFrame) {
					_mc.gotoAndStop(_frame + 1);
				}
				sendEvent(UIEvent.FRAME_CHANGED);
				if (_to && (_mc.currentFrame - 1 == _to || _mc.currentLabel == _to)) {
					stop();
					_to = null;
					_needPlay = false;
					if (_complete != null) {
						var handler:Method = _complete;
						_complete = null;
						handler.apply();
					}
				}
				if (_mc.currentFrame == _mc.totalFrames) {
					if (_autoStop || _autoRemove) {
						stop();
					}
					if (_autoRemove) {
						remove();
					}
					if (_autoDispose) {
						dispose();
					}
				}
			}
		}
		
		/**切片帧的总数*/
		public function get totalFrame():int {
			return _mc ? _mc.totalFrames : 0;
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
		
		public function get autoStop():Boolean {
			return _autoStop;
		}
		
		public function set autoStop(value:Boolean):void {
			if (_autoStop != value) {
				_autoStop = value;
			}
		}
		
		public function get autoRemove():Boolean {
			return _autoRemove;
		}
		
		public function set autoRemove(value:Boolean):void {
			if (_autoRemove != value) {
				_autoRemove = value;
			}
		}
		
		public function get autoDispose():Boolean {
			return _autoDispose;
		}
		
		public function set autoDispose(value:Boolean):void {
			if (_autoDispose != value) {
				_autoDispose = value;
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
			frame = _frame;
//			TimerManager.getInstance().doFrameLoop(StageUtil.baseFramesToRealFrames(1), loop);
//			TimerManager.getInstance().doLoop(StageUtil.baseFramesToRealFrames(StageManager.getInstance().interval), loop);
			TimerManager.getInstance().doLoop(_interval, loop);
		}
		
		protected function loop():void {
			if (_isPlaying) {
				frame++;
			}
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
		
		/**从某帧播放到某帧，播放结束发送事件(为了统一，frame从0开始，原始的movieclip从1开始)
		 * @param from 开始帧或标签(为null时默认为第一帧)
		 * @param to 结束帧或标签(为null时默认为最后一帧)
		 */
		public function playFromTo(from:Object = null, to:Object = null, complete:Method = null):void {
			_needPlay = true;
			_from = from ||= 0;
			_to = to == null ? (_mc ? _mc.totalFrames - 1 : to) : to;
			_complete = complete;
			if (from is int) {
				gotoAndPlay(_from as int);
			} else {
				if (_mc) {
					_mc.gotoAndStop(_from);
					gotoAndPlay(_mc.currentFrame - 1);
				}
			}
		}
		
		override public function commitMeasure():void {
			exeCallLater(changeSkin);
		}
		
		override public function set dataSource(value:Object):void {
			_dataSource = value;
			if (value is int || value is String) {
				frame = int(value);
			} else {
				super.dataSource = value;
			}
		}
		
		override public function dispose():void {
			if (_mc != null) {
				_mc.stop();
			}
			stop();
			super.dispose();
		}
	}
}