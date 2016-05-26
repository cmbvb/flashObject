package manager
{
	import flash.events.EventDispatcher;

	public class EventManager extends EventDispatcher
	{
		private static var _ins:EventManager;
		
		public function EventManager()
		{
		}
		
		public static function get ins():EventManager {
			if (_ins == null) {
				_ins = new EventManager();
			}
			return _ins;
		}
		
	}
}