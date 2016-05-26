package base
{
	import roleObject.Role;

	public interface IRoleState
	{
		function get stateID():int;
		function enterState(role:Role):void;
		function leaveState(role:Role):void;
		function updateState(role:Role):void;
	}
}