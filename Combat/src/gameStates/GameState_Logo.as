package gameStates
{
	import flash.display.Stage;
	
	import base.AssetsManager;
	import base.IState;

	public class GameState_Logo implements IState
	{
		private var _stateParent:IState;
		private var mStage:Stage;
		
		public function GameState_Logo(stage:Stage)
		{
			mStage = stage;
		}
		
		public function cycle():void {
			AssetsManager.ins.addAssetsUrlReq("idle_1.swf");
			AssetsManager.ins.addAssetsUrlReq("move_1.swf");
			AssetsManager.ins.startLoad();
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