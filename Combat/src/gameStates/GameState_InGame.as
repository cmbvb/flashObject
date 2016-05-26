package gameStates
{
	import flash.display.Stage;
	
	import base.IState;
	
	import roleObject.Role;

	public class GameState_InGame implements IState
	{
		private var _stateParent:IState;
		private var mStage:Stage;
		private var mRole:Role;
		
		public function GameState_InGame(stage:Stage)
		{
			mStage = stage;
		}
		
		public function cycle():void {
			mRole = new Role();
			mRole.init();
			mStage.addChild(mRole);
			mRole.x = mStage.fullScreenWidth / 2;
			mRole.y = mStage.fullScreenHeight / 2;
		}
		
		public function draw():void {
			mRole.update();
		}
		
		public function get stateParent():IState {
			return _stateParent;
		}
		
		public function set stateParent(state:IState):void {
			_stateParent = state;
		}
		
	}
}