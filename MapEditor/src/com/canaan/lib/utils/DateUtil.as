package com.canaan.lib.utils
{
	public class DateUtil
	{
		public static var date_year:String = "年";
		public static var date_month:String = "月";
		public static var date_day:String = "日";
		
		public static var time_day:String = "天";
		public static var time_hour:String = "小时";
		public static var time_minute:String = "分钟";
		public static var time_second:String = "秒";
		
		private static var tempDate:Date;
		private static var week1:Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		private static var week2:Array = ["Sun.", "Mon.", "Tues.", "Wed.", "Thurs.", "Fri.", "Sat."];
		private static var week3:Array = ["日", "一", "二", "三", "四", "五", "六"];
		private static var month1:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		private static var month2:Array = ["Jan.", "Feb.", "Mar.", "Apr.", "Ma.", "Jun.", "Jul.", "Aug.", "Sept.", "Oct.", "Nov.", "Dec."];
		
		/**
		 * 加0
		 * @param value
		 * @return 
		 * 
		 */		
		public static function addZero(value:int):String {
			return (value < 10 ? "0" : "") + value;
		}
		
		/**
		 * 格式化输出日期
		 * @param date
		 * @param short	是否显示时分秒
		 * @param dateSeparator	日期分割符
		 * @param timeSeparator	时间分隔符
		 * @return 
		 * 
		 */		
		public static function formatDate(date:Date, short:Boolean = false, dateSeparator:String = "-", timeSeparator:String = ":"):String {
			var yy:String = addZero(date.getFullYear());
			var mm:String = addZero(date.getMonth() + 1);
			var dd:String = addZero(date.getDate());
			var h:String = addZero(date.getHours());
			var m:String = addZero(date.getMinutes());
			var s:String = addZero(date.getSeconds());
			
			var result:String = "";
			result += yy + dateSeparator + mm + dateSeparator + dd;
			
			if (!short) {
				result += " " + h + timeSeparator + m + timeSeparator + s;
			}
			
			return result;
		}
		
		/**
		 * 根据时间戳格式化输出日期
		 * @param value 时间（秒）
		 * @param short	是否显示时分秒
		 * @param dateSeparator	日期分割符
		 * @param timeSeparator	时间分隔符
		 * @return 
		 * 
		 */		
		public static function formateDateFromSeconds(value:Number, short:Boolean = false, dateSeparator:String = "-", timeSeparator:String = ":"):String {
			return formatDate(new Date(value * 1000), short, dateSeparator, timeSeparator);
		}
		
		/**
		 * /**
		 * 格式化输出日期(中文)
		 * @param date
		 * @param short	是否显示时分秒
		 * @param dateSeparator	日期分割符
		 * @param timeSeparator	时间分隔符
		 * @return 
		 * 
		 */		
		public static function formatDateInChinese(date:Date, short:Boolean = false):String {
			var yy:int = date.getFullYear();
			var mm:int = date.getMonth() + 1;
			var dd:int = date.getDate();
			var h:int = date.getHours();
			var m:int = date.getMinutes();
			var s:int = date.getSeconds();
			
			var result:String = yy + date_year + mm + date_month + dd + date_day;
			
			return result;
		}
		
		
		/**
		 * 根据时间戳格式化输出日期(中文)
		 * @param value 时间（秒）
		 * @param short	是否显示时分秒
		 * @return 
		 * 
		 */		
		public static function formateDateFromSecondsInChinese(value:Number, short:Boolean = false):String {
			return formatDateInChinese(new Date(value * 1000), short);
		}
		
		/**
		 * 格式化输出剩余时间
		 * @param time	时间（秒）
		 * @param separator	分隔符
		 * @return 
		 * 
		 */		
		public static function formatTimeLeft(time:Number, separator:String = ":"):String {
			var h:String = addZero(int(time / 3600));
            time %= 3600;
            var m:String = addZero(int(time / 60));
            time %= 60;
            var s:String = addZero(time);
			return h + separator + m + separator + s;
		}
		
		/**
		 * 格式化输出剩余时间
		 * @param time
		 * @return 
		 * 
		 */		
		public static function formatTimeLeftInChinese(time:Number):String {
			var d:int = int(time / 86400);
			time %= 86400;
			var h:int = int(time / 3600);
			time %= 3600;
			var m:int = int(time / 60);
			time %= 60;
			var s:int = int(time);
			var str:String = "";
			if (d > 0) {
				str += d + time_day;
			}
			if (h > 0) {
				str += h + time_hour;
			}
			if (m > 0) {
				str += m + time_minute;
			}
			if (s > 0) {
				str += s + time_second;
			}
			return str;
		}
		
		/**
		 * 获取0点时间
		 * @param value	时间（秒）
		 * @return 
		 * 
		 */		
		public static function getZeroTime(value:Number):Number {
        	var date:Date = new Date(value * 1000);
			var targetTime:Number = (new Date(date.fullYear, date.month, date.date).time) / 1000;
			return targetTime;
        }
		
		public static function formatTime(seconds:uint, format:String = "YYYY-MM-DD hh:mm:ss"):String {
			format = format || "YYYY-MM-DD hh:mm:ss";
			tempDate = new Date(seconds * 1000);
			return format.replace(/YYYY|EMM|EM|MM|DD|hh|mm|ss|EWW|EW|CW/g, matchTime);
		}
		
		public static function uintToFixed(value:uint, len:uint):String {
			len = len || 1;
			var zeros:Array = [];
			for (var i:uint = 0; i < len; i++) {
				zeros[i] = 0;
			}
			return (zeros.join("") + value.toString()).slice(-len);
		}
		
		private static function matchTime(...args:Array):String {
			var value:String = "";
			switch(args[0]) {
				case "YYYY":
					value = String(tempDate.fullYear);
					break;
				case "EMM":
					value = month1[tempDate.month];
					break;
				case "EM":
					value = month2[tempDate.month];
					break;
				case "MM":
					value = uintToFixed(tempDate.month + 1, 2);
					break;
				case "DD":
					value = uintToFixed(tempDate.date, 2);
					break;
				case "hh":
					value = uintToFixed(tempDate.hours, 2);
					break;
				case "mm":
					value = uintToFixed(tempDate.minutes, 2);
					break;
				case "ss":
					value = uintToFixed(tempDate.seconds, 2);
					break;
				case "EWW":
					value = week1[tempDate.day];
					break;
				case "EW":
					value = week2[tempDate.day];
					break;
				case "CW":
					value = week3[tempDate.day];
					break;
			}
			return value;
		}
	}
}