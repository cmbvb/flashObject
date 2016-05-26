package com.canaan.lib.utils.check
{
	import flash.utils.ByteArray;

	public class CRC32
	{
		private static var crcTable:Vector.<int> = initCrcTable();
		
		private static function initCrcTable():Vector.<int> {
			var crcTable:Vector.<int> = new Vector.<int>(256);
			for (var i:int = 0; i < 256; i++) {
				var crc:uint = i;
				for (var j:int = 0; j < 8; j++) {
					crc = (crc & 1) ? ((crc >>> 1) ^ 0xEDB88320) : (crc >>> 1);
				}
				crcTable[i] = crc;
			}
			return crcTable;
		}
		
		public static function getCRC32(buffer:ByteArray):uint {
			var crc:uint = 0;
			var offset:uint = 0;
			var length:uint = buffer.length;
			var c:uint = ~crc;
			while (--length >= 0) {
				c = crcTable[(c ^ buffer[offset++]) & 0xFF] ^ (c >>> 8);
			}
			crc = ~c;
			return crc & 0xFFFFFFFF;
		}
	}
}