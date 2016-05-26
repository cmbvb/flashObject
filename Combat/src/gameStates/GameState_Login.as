package gameStates
{
	import flash.display.Stage;
	import flash.text.TextField;
	
	import base.IState;

	public class GameState_Login implements IState
	{
		private var _stateParent:IState;
		private var mStage:Stage;
		
		public function GameState_Login(stage:Stage)
		{
			mStage = stage;
		}
		
		public function cycle():void {
			var label:TextField = new TextField();
			label.text = "TOUCH BEGIN";
			mStage.addChild(label);
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