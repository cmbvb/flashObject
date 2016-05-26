package com.canaan.gameEditor.cfg
{
	import com.canaan.gameEditor.core.GameRes;
	import com.canaan.lib.abstract.AbstractVo;
	import com.canaan.lib.core.SysConfig;
	import com.canaan.lib.role.constants.TypeRoleDirection;
	
	public class ActionResConfigVo extends AbstractVo
	{
		public static const TITLES:Array = ["id", "actionId", "roleResId", "directions", "maxFrame", "maxAnimFrame", "animFrames", "soundEffects"];
		public static const OUTPUT_DESC:Array = ["编号", "动作", "最大帧数", "帧数配置", "音频配置"];
		public static const OUTPUT_TITLES:Array = ["id", "actionId", "maxAnimFrame", "animFrames", "soundEffects"];
		public static const OUTPUT_TYPE:Array = ["string", "int", "int", "int[]", "int[]"];
		
		private var _id:String;											// ID
		private var _actionId:int;										// 动作ID
		private var _desc:String;										// 备注
		private var _roleResId:int;										// 角色ID
		private var _directions:String;									// 方向
		private var _maxFrame:int;										// 资源总帧数
		private var _maxAnimFrame:int;									// 动画总帧数
		private var _animFrames:String;									// 动作帧顺序
		private var _soundEffects:String;								// 音效配置
		
		private var _animFramesArray:Array;								// 动作帧顺序数组
		private var _directionsArray:Array;								// 方向数组
		private var _soundEffectConfigs:Object;
		
		public function ActionResConfigVo()
		{
			super();
		}
		
		public function get cfgData():Object {
			var data:Object = {};
			data["id"] = _id;
			data["actionId"] = _actionId;
			data["roleResId"] = _roleResId;
			data["directions"] = _directionsArray.join(",");
			data["maxFrame"] = _maxFrame;
			data["maxAnimFrame"] = _maxAnimFrame;
			data["animFrames"] = _animFramesArray.join(",");
			var soundEffectArray:Array = [];
			for (var frame:int in soundEffectConfigs) {
				soundEffectArray.push(frame + "|" + soundEffectConfigs[frame]);
			}
			data["soundEffects"] = soundEffectArray.join(",");
			return data;
		}
		
		public function getCheckedDirection(direction:int):int {
			if (_directionsArray.indexOf(direction.toString()) != -1) {
				return direction;
			}
			return TypeRoleDirection.DOWN;
		}
		
		public function get actionTypeConfig():ActionTypeConfigVo {
			return SysConfig.getConfigVo(GameRes.TBL_ACTION_TYPE, _actionId) as ActionTypeConfigVo;
		}
		
		public function get animFramesArray():Array {
			return _animFramesArray;
		}
		
		public function set animFramesArray(value:Array):void {
			_animFramesArray = value;
		}
		
		public function get directionArray():Array {
			return _directionsArray;
		}
		
		/**
		 * 根据帧获取音频
		 * @param frame
		 * @return 
		 * 
		 */		
		public function getSoundEffectByFrame(frame:int):int {
			return soundEffectConfigs[frame];
		}
		
		/**
		 * 根据帧设置音频
		 * @param frame
		 * @param soundResId
		 * 
		 */		
		public function setSoundEffectByFrame(frame:int, soundResId:int):void {
			soundEffectConfigs[frame] = soundResId;
		}
		
		/**
		 * 音频配置
		 * @return 
		 * 
		 */		
		public function get soundEffectConfigs():Object {
			if (_soundEffectConfigs == null) {
				_soundEffectConfigs = new Object();
				if (_soundEffects) {
					var soundInfos:Array = _soundEffects.split(",");
					var soundDetails:Array;
					var frame:int;
					var soundResId:int;
					for each (var soundInfo:String in soundInfos) {
						soundDetails = soundInfo.split("|");
						frame = int(soundDetails[0]);
						soundResId = int(soundDetails[1]);
						_soundEffectConfigs[frame] = soundResId;//SysConfig.getConfigVo(GameRes.TBL_SOUND_RES, soundResId) as SoundResConfigVo;
					}
				}
			}
			return _soundEffectConfigs;
		}
		
		public function set soundEffectConfigs(value:Object):void {
			_soundEffectConfigs = value;
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}
		
		public function get actionId():int
		{
			return _actionId;
		}

		public function set actionId(value:int):void
		{
			_actionId = value;
		}
		
		public function get roleResId():int
		{
			return _roleResId;
		}
		
		public function set roleResId(value:int):void
		{
			_roleResId = value;
		}
		
		public function get directions():String
		{
			return _directions;
		}
		
		public function set directions(value:String):void
		{
			_directions = value;
			_directionsArray = _directions.split(",");
		}
		
		public function get maxFrame():int
		{
			return _maxFrame;
		}
		
		public function set maxFrame(value:int):void
		{
			_maxFrame = value;
		}

		public function get maxAnimFrame():int
		{
			return _maxAnimFrame;
		}

		public function set maxAnimFrame(value:int):void
		{
			_maxAnimFrame = value;
		}
		
		public function get animFrames():String
		{
			return _animFrames;
		}
		
		public function set animFrames(value:String):void
		{
			_animFrames = value;
			_animFramesArray = _animFrames.split(",");
		}

		public function get soundEffects():String
		{
			return _soundEffects;
		}

		public function set soundEffects(value:String):void
		{
			_soundEffects = value;
		}
	}
}