package com.canaan.gameEditor.view.sound
{
	import com.canaan.gameEditor.cfg.SoundResConfigVo;
	import com.canaan.gameEditor.contants.TypeSound;
	import com.canaan.gameEditor.ui.sound.SoundChooseItemUI;
	
	public class SoundChooseItem extends SoundChooseItemUI
	{
		private var mConfig:SoundResConfigVo;
		
		public function SoundChooseItem()
		{
			super();
		}
		
		override public function set dataSource(value:Object):void {
			super.dataSource = value;
			mConfig = value as SoundResConfigVo;
			lblSound.text = mConfig.id + (mConfig.desc ? "(" + mConfig.desc + ")" : "(未备注)");
			imgIcon.url = mConfig.type == TypeSound.MUSIC ? "png.comp.img_music" : "png.comp.img_effect";
		}
	}
}