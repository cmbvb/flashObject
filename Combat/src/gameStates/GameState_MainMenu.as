package gameStates
{
	import flash.display.Stage;
	
	import base.IState;

	public class GameState_MainMenu implements IState
	{
		private var _stateParent:IState;
		private var mStage:Stage;
		
		public function GameState_MainMenu(stage:Stage)
		{
			mStage = stage;
		}
		
		public function cycle():void {
			
		}
		
		public function draw():void {
			
		}
		
		public function get stateParent():IState {
			return _stateParent;
		}
		
		public function set stateParent(state:IState):void {
			_stateParent = state;
		}
		
	}
}