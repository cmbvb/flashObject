package mapTool.module.enum
{
	import flash.events.Event;
	
	public class TypeEvent extends Event
	{
		private var _data:Object;
		
		public static const FILE_SELECT:String = "typeEventFileSelect";
		
		public function TypeEvent(type:String, data:Object = null)
		{
			super(type);
			_data = data;
		}
		
		public function get data():Object {
			return _data;
		}
		
	}
}