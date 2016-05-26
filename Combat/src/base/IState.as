package base
{
	public interface IState
	{
		function cycle():void;
		function draw():void;
		function set stateParent(state:IState):void;
		function get stateParent():IState;
	}
}