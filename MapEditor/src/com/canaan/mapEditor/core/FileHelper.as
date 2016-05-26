package com.canaan.mapEditor.core
{
	import com.canaan.mapEditor.view.common.Alert;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class FileHelper
	{
		public static const REG:RegExp = /[ ~%&\\;:"',<>?#|*]/g;
		
		private static var file:File = new File();
		private static var fs:FileStream = new FileStream();
		
		public static function read(path:String):ByteArray {
			if (!isExist(path)) {
				return null;
			}
			var bytes:ByteArray = new ByteArray();
			file.cancel();
			file.nativePath = path;
			fs.close();
			fs.open(file, FileMode.READ);
			fs.position = 0;
			fs.readBytes(bytes);
			fs.close();
			return bytes;
		}
		
		public static function readText(path:String):String {
			if (!isExist(path)) {
				return null;
			}
			var bytes:ByteArray = read(path);
			return bytes.readMultiByte(bytes.bytesAvailable, "utf-8");
		}
		
		public static function readXML(path:String):XML {
			var text:String = readText(path);
			if (text == null) {
				return null;
			}
			return new XML(text);
		}
		
		public static function save(path:String, bytes:ByteArray):void {
			try {
				file.cancel();
				file.nativePath = path;
				fs.close();
				fs.open(file, FileMode.WRITE);
				fs.position = 0;
				fs.writeBytes(bytes);
				fs.close();
			} catch (error:Error) {
				Alert.show("copy:" + error.message);
			}
		}
		
		public static function saveText(path:String, text:String):void {
			var bytes:ByteArray = new ByteArray();
			bytes.writeMultiByte(text, "utf-8");
			save(path, bytes);
		}
		
		public static function saveXML(path:String, xml:XML):void {
			var bytes:ByteArray = new ByteArray();
			bytes.writeMultiByte(xml, "utf-8");
			save(path, bytes);
		}
		
		public static function copy(path:String, newPath:String):void {
			try {
				if (path == newPath) {
					return;
				}
				file.cancel();
				file.nativePath = path;
				var targetFile:File = new File(newPath);
				if (file.exists) {
					file.copyTo(targetFile, true);
				}
			} catch (error:Error) {
				Alert.show("copy:" + error.message);
			}
		}
		
		public static function copyChildren(path:String, newPath:String):void {
			if (path == newPath) {
				return;
			}
			var file:File = new File(path);
			var children:Array = file.getDirectoryListing();
			for each (var child:File in children) {
				copy(child.nativePath, newPath + "\\" + child.name);
			}
		}
		
		public static function moveTo(path:String, newPath:String):void {
			try {
				if (path == newPath) {
					return;
				}
				file.cancel();
				file.nativePath = path;
				var targetFile:File = new File(newPath);
				if (file.exists && targetFile.exists) {
					file.moveTo(new File(newPath), true);
				}
			} catch (error:Error) {
				Alert.show("copy:" + error.message);
			}
		}
		
		public static function createDirectory(path:String):void {
			file.cancel();
			file.nativePath = path;
			file.createDirectory();
		}
		
		public static function deleteFile(path:String):void {
			file.cancel();
			file.nativePath = path;
			if (file.exists) {
				if (file.isDirectory) {
					file.deleteDirectory(true);
				} else {
					file.deleteFile();
				}
			}
		}
		
		public static function isExist(path:String):Boolean {
			file.cancel();
			file.nativePath = path;
			return file.exists;
		}
		
		public static function isFolder(path:String):Boolean {
			file.cancel();
			file.nativePath = path;
			return file.isDirectory;
		}
	}
}