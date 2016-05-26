package com.canaan.lib.utils
{
	import flash.media.Sound;
	import flash.net.URLRequest;

	public class KeepAwake
	{
		private static var sound:Sound;
		
		public function KeepAwake()
		{
		}
		
		public static function keep():void {
			sound = new Sound(new URLRequest(""));
			sound.play();
			sound.close();
//			sound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleDataHandler);
//			sound.play();
		}
		
//		public static function stop():void {
//			sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleDataHandler);
//			sound.close();
//			sound = null;
//		}
//		
//		private static function onSampleDataHandler(event:SampleDataEvent):void {
//			event.data.position = event.data.length = 4096 * 4;
//		}
	}
}