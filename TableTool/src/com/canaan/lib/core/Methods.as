package com.canaan.lib.core
{
	public class Methods
	{
		private var _methods:Vector.<Function>;
		private var _args:Vector.<Array>;
		
		public function Methods()
		{
			_methods = new Vector.<Function>();
			_args = new Vector.<Array>();
		}
		
		public function register(func:Function, args:Array = null):void {
			var index:int = _methods.indexOf(func);
			if (index == -1) {
				_methods.unshift(func);
				_args.unshift(args);
			} else {
				_args.splice(index, 1, args);
			}
		}
		
		public function registerMethod(method:Method):void {
			register(method.func, method.args);
		}
		
		public function del(func:Function):void {
			var index:int = _methods.indexOf(func);
			if (index != -1) {
				_methods.splice(index, 1);
				_args.splice(index, 1);
			}
		}
		
		public function apply():void {
			var func:Function;
			var args:Array;
			var l:int = _methods.length;
			for (var i:int = l - 1; i >= 0; i--) {
				func = _methods[i];
				args = _args[i];
				func.apply(null, args);
			}
		}
		
		public function applyWith(data:Array):void {
			if (data == null) {
				apply();
				return;
			}
			var func:Function;
			var args:Array;
			for (var i:int = 0; i < _methods.length; i++) {
				func = _methods[i];
				args = _args[i];
				func.apply(null, args ? args.concat(data) : data);
			}
		}
		
		public function clear():void {
			_methods.length = 0;
			_args.length = 0;
		}
		
		public function clone():Methods {
			var methods:Methods = new Methods();
			methods._methods = _methods.concat();
			methods._args = _args.concat();
			return methods;
		}
		
		public function get length():int {
			return _methods.length;
		}
	}
}