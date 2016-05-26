package com.canaan.lib.utils
{
	public class StageUtil
	{
		public static var fpsMultiple:int = 1;
		public static var fps:int = 30;
		public static var baseFps:int = 30;
		public static var interval:Number = 33;
		public static var baseInterval:Number = 33;
		
		/**
		 * 基础帧转换为实际帧
		 * @param frame
		 * @return 
		 * 
		 */		
		public static function baseFramesToRealFrames(frame:int):int {
			return frame * fpsMultiple;
		}
		
		/**
		 * 基础时间换为实际时间
		 * @param interval
		 * @return 
		 * 
		 */		
		public static function baseIntervalToRealInterval(interval:int):int {
			return interval * fpsMultiple;
		}
		
		/**
		 * 时间转换为帧
		 * @param time
		 * @return 
		 * 
		 */		
		public static function timeToFrames(time:Number):int {
			return baseFramesToRealFrames(time / baseInterval);
		}
		
		/**
		 * 帧转换为时间（毫秒）
		 * @param frames
		 * @return 
		 * 
		 */		
		public static function framesToTime(frames:int):Number {
			return framesToTimeSecond(frames) * 1000;
		}
		
		/**
		 * 帧转换为时间（秒）
		 * @param frames
		 * @return 
		 * 
		 */		
		public static function framesToTimeSecond(frames:int):Number {
			return frames / baseFps;
		}
	}
}