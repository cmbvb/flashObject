package com.canaan.programEditor.core
{
	import com.canaan.lib.core.Config;

	public class DefaultConfig
	{
		public function DefaultConfig()
		{
		}
		
		public static function initialize():void {
			Config.setConfig("fps", 30);										// fps
			Config.setConfig("locale", "zh_CN");								// 语言环境
			Config.setConfig("resHost", "");									// 资源目录
		}
	}
}