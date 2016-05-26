package manager
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mapTool.module.enum.TypeEvent;

	public class FileManager
	{
		private static var _ins:FileManager;
		private var mF:File = new File();
		private var mFs:FileStream = new FileStream();
		private var mIsOpen:Boolean;
		private var mIsSave:Boolean;
		
		public function FileManager()
		{
			mF.addEventListener(Event.SELECT, onSelect);
			mF.addEventListener(Event.COMPLETE, onLoadComplete);
		}
		
		private function onLoadComplete(event:Event):void {
			(mF.data as ByteArray).position = 0;
			LoaderManager.ins.loadBytes(mF.data);
		}
		
		private function onSelect(event:Event):void {
			if (mIsOpen) {
				mF.load();
				mIsOpen = false;
				EventManager.ins.dispatchEvent(new TypeEvent(TypeEvent.FILE_SELECT, mF));
			}
			if (mIsSave) {
				var by:ByteArray = mF.data;
				mF.cancel();
				mFs.close();
				mFs.open(mF, FileMode.WRITE);
				mFs.writeBytes(by);
				mFs.close();
//				mFs.open(new File(mF.nativePath), FileMode.WRITE);
//				mFs.writeObject(mF.data);
//				mFs.close();
				mIsSave = false;
			}
		}
		
		public static function get ins():FileManager {
			if (_ins == null) {
				_ins = new FileManager();
			}
			return _ins;
		}
		
		public function open():void {
			mIsOpen = true;
			mF.browse();
		}
		
		public function save(data:*, defaultFileName:String = null):void {
			mIsSave = true;
			mF.save(data, defaultFileName);
		}
		
	}
}