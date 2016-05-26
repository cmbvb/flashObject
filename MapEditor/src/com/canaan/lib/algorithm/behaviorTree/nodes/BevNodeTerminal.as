package com.canaan.lib.algorithm.behaviorTree.nodes
{
	import com.canaan.lib.algorithm.behaviorTree.BevNodeInputParam;
	import com.canaan.lib.algorithm.behaviorTree.BevNodeOutputParam;
	import com.canaan.lib.algorithm.behaviorTree.BevNodePrecondition;
	import com.canaan.lib.algorithm.behaviorTree.constants.BevRunningStatus;
	import com.canaan.lib.algorithm.behaviorTree.constants.BevTerminalNodeStatus;
	
	/**
	 * 叶子节点
	 * @author Administrator
	 * 
	 */	
	public class BevNodeTerminal extends BevNode
	{
		protected var _status:int;									// 当前状态
		protected var _needExit:Boolean;							// 是否需要退出
		protected var _actionTime:Number;							// 动作时间
		protected var _actionDelay:Boolean;							// 动作延迟
		
		public function BevNodeTerminal(parentNode:BevNode=null, nodePrecondition:BevNodePrecondition=null, actionTime:Number=0, disableTime:int=0, actionDelay:Boolean=false)
		{
			super(parentNode, nodePrecondition, disableTime);
			_status = BevTerminalNodeStatus.READY;
			_needExit = false;
			_actionTime = actionTime;
			_actionDelay = actionDelay;
		}
		
		override protected function doTransition(inputParam:BevNodeInputParam):void {
			if (_needExit == true) {
				doExit(inputParam, BevRunningStatus.ERROR_TRANSITION);
			}
			setActiveNode(null);
			_status = BevTerminalNodeStatus.READY;
			_needExit = false;
		}
		
		override protected function doTick(inputParam:BevNodeInputParam, outputParam:BevNodeOutputParam):int {
			var runningState:int = BevRunningStatus.FINISH;
			if (_status == BevTerminalNodeStatus.READY) {
				doEnter(inputParam);
				_needExit = true;
				_status = BevTerminalNodeStatus.RUNNING;
				setActiveNode(this);
			}
			if (_status == BevTerminalNodeStatus.RUNNING) {
				runningState = doExecute(inputParam, outputParam);
				setActiveNode(this);
				if (runningState == BevRunningStatus.FINISH || runningState < 0) {
					_status = BevTerminalNodeStatus.FINISH;
				}
			}
			if (_status == BevTerminalNodeStatus.FINISH) {
				if (_needExit == true) {
					doExit(inputParam, runningState);
				}
				_status = BevTerminalNodeStatus.READY;
				_needExit = false;
				setActiveNode(null);
			}
			return runningState;
		}
		
		/**
		 * 进入节点
		 * @param inputParam
		 * 
		 */		
		protected function doEnter(inputParam:BevNodeInputParam):void {
			
		}
		
		/**
		 * 执行节点
		 * @param inputParam
		 * @param outputParam
		 * @return 
		 * 
		 */		
		protected function doExecute(inputParam:BevNodeInputParam, outputParam:BevNodeOutputParam):int {
			outputParam.anyData.actionTime = _actionTime;
			return BevRunningStatus.FINISH;
		}
		
		/**
		 * 退出节点
		 * @param inputParam
		 * @param runningStatus
		 * 
		 */		
		protected function doExit(inputParam:BevNodeInputParam, runningStatus:int):void {
			
		}

		public function get status():int {
			return _status;
		}

		public function set status(value:int):void {
			_status = value;
		}

		public function get needExit():Boolean {
			return _needExit;
		}

		public function set needExit(value:Boolean):void {
			_needExit = value;
		}

		public function get actionTime():Number {
			return _actionTime;
		}

		public function set actionTime(value:Number):void {
			_actionTime = value;
		}

		public function get actionDelay():Boolean {
			return _actionDelay;
		}

		public function set actionDelay(value:Boolean):void {
			_actionDelay = value;
		}
		
		override public function clone():BevNode {
			return new BevNodeTerminal(mParentNode, mNodePrecondition, _actionTime, mDisableTime, _actionDelay);
		}
	}
}