package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import base.EventManager;
	import base.GameConfig;
	import base.IState;
	import base.StateManager;
	
	import enumeration.EnumEvent;
	
	import gameStates.GameState_InGame;
	import gameStates.GameState_Login;
	import gameStates.GameState_Logo;
	import gameStates.GameState_MainMenu;
	
	import module.ModuleMainUI;
	
	import morn.core.handlers.Handler;
	
	public class Combat extends Sprite
	{
		private var logo:IState;
		private var login:IState;
		private var inGame:IState;
		private var mainMenu:IState;
		
		public function Combat()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			App.init(this);
			App.loader.loadAssets(["assets/comp.swf"], new Handler(loadComplete));
			
			GameConfig.GAMEWIDTH = stage.fullScreenWidth;
			GameConfig.GAMEHEIGHT = stage.fullScreenHeight;
			
			logo = new GameState_Logo(stage);
			login = new GameState_Login(stage);
			inGame = new GameState_InGame(stage);
			mainMenu = new GameState_MainMenu(stage);
			
			StateManager.ins.addState(logo);
			StateManager.ins.addState(login);
			StateManager.ins.addState(inGame);
			StateManager.ins.addState(mainMenu);
			StateManager.ins.mCurState = inGame;
			StateManager.ins.mCurState.cycle();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			EventManager.ins.addEventListener(EnumEvent.ASSETS_LOAD_COMPLETE, onAssetsLoadComplete);
		}
		
		private function loadComplete():void {
			addChild(new ModuleMainUI());
		}
		
		private function onEnterFrame(event:Event):void {
			StateManager.ins.mCurState.draw();
		}
		
		private function onAssetsLoadComplete(event:EnumEvent):void {
			StateManager.ins.changeState(inGame, StateManager.STATE_OP_PUSH);
		}
		
	}
}