package com.canaan.lib.managers
{
	import com.canaan.lib.core.Methods;
	import com.canaan.lib.debug.Log;
	import com.canaan.lib.events.SocketEvent;
	import com.canaan.lib.net.ServerRequest;
	import com.canaan.lib.net.ServerResult;
	import com.canaan.lib.utils.ObjectUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class SocketManager extends EventDispatcher
	{
		public static var bufferMaxSize:int = 16440;
		
		private static var canInstantiate:Boolean;
		private static var instance:SocketManager;
		
		private var sockets:Dictionary = new Dictionary();
		private var methodsDict:Dictionary = new Dictionary();
		private var request:ServerRequest;
		private var result:ServerResult;
		
		public function SocketManager()
		{
			if (!canInstantiate) {
				throw new Error("Can not instantiate, use getInstance() instead.");
			}
			request = new ServerRequest();
			result = new ServerResult();
		}
		
		public static function getInstance():SocketManager {
			if (instance == null) {
				canInstantiate = true;
				instance = new SocketManager();
				canInstantiate = false;
			}
			return instance;
		}
		
		public function connect(host:String, port:int, socketName:String = "default"):void {
			var socketItem:SocketItem = sockets[socketName];
			if (!socketItem) {
				socketItem = new SocketItem(socketName);
				sockets[socketName] = socketItem;
				addEvents(socketItem);
			}
			socketItem.connect(host, port);
			dispatchEvent(new SocketEvent(SocketEvent.START_CONNECT, socketName));
		}
		
		public function dispose(socketName:String):void {
			var socketItem:SocketItem = sockets[socketName];
			if (socketItem) {
				delete sockets[socketName];
				removeEvents(socketItem);
				socketItem.dispose();
			}
		}
		
		public function getSocketDetail(socketName:String):Object {
			var socketItem:SocketItem = sockets[socketName];
			if (socketItem) {
				return {
					socketName:socketName,
					host:socketItem.host,
					port:socketItem.port
				};
			}
			return null;
		}
		
		public function send(protocol:*, data:Object = null, socketName:String = "default"):void {
			var socketItem:SocketItem = sockets[socketName];
			if (socketItem) {
				request.reset(protocol, data);
				var bytes:ByteArray = ObjectUtil.gBytes;
				bytes = ObjectUtil.objectToBytes(request.requestData, true, bytes);
				var length:int = bytes.length;
				socketItem.writeShort(length);
				socketItem.writeBytes(bytes);
				socketItem.flush();
				dispatchEvent(new SocketEvent(SocketEvent.SEND, socketName, null, request));
			} else {
				Log.getInstance().error("Socket is not exist. socketName:" + socketName);
			}
		}
		
		public function registerHandler(protocol:int, func:Function, args:Array = null):void {
			var methods:Methods = methodsDict[protocol];
			if (!methods) {
				methods = new Methods();
				methodsDict[protocol] = methods;
			}
			methods.register(func, args);
		}
		
		public function deleteHandler(protocol:int, func:Function):void {
			var methods:Methods = methodsDict[protocol];
			if (methods) {
				methods.del(func);
				if (methods.length == 0) {
					delete methodsDict[protocol];
				}
			}
		}
		
		public function handler(socketName:String, data:Object):void {
			result.setData(data);
			if (!result.success) {
				dispatchEvent(new SocketEvent(SocketEvent.SERVER_ERROR, socketName, result));
				return;
			}
			var methods:Methods = methodsDict[result.protocol];
			if (methods) {
				methods.applyWith([result]);
			}
			dispatchEvent(new SocketEvent(SocketEvent.COMPLETE, socketName, result));
		}
		
		private function addEvents(socketItem:SocketItem):void {
			socketItem.addEventListener(Event.CONNECT, onConnect);
			socketItem.addEventListener(Event.CLOSE, onClose);
			socketItem.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			socketItem.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			socketItem.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
		}
		
		private function removeEvents(socketItem:SocketItem):void {
			socketItem.removeEventListener(Event.CONNECT, onConnect);
			socketItem.removeEventListener(Event.CLOSE, onClose);
			socketItem.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			socketItem.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			socketItem.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
		}
		
		private function onConnect(event:Event):void {
			var socketItem:SocketItem = event.target as SocketItem;
			dispatchEvent(new SocketEvent(SocketEvent.CONNECT, socketItem.socketName));
			Log.getInstance().info("Socket connect. name:" + socketItem.socketName + 
				", host:" + socketItem.host + ", port:" + socketItem.port);
		}
		
		private function onClose(event:Event):void {
			var socketItem:SocketItem = event.target as SocketItem;
			dispatchEvent(new SocketEvent(SocketEvent.CLOSE, socketItem.socketName));
			Log.getInstance().info("Socket close. name:" + socketItem.socketName + 
				", host:" + socketItem.host + ", port:" + socketItem.port);
		}
		
		private function onIoError(event:IOErrorEvent):void {
			var socketItem:SocketItem = event.target as SocketItem;
			dispatchEvent(new SocketEvent(SocketEvent.IO_ERROR, socketItem.socketName));
			Log.getInstance().info("Socket IoError. name:" + socketItem.socketName + 
				", host:" + socketItem.host + ", port:" + socketItem.port);
		}
		
		private function onSecurityError(event:SecurityErrorEvent):void {
			var socketItem:SocketItem = event.target as SocketItem;
			dispatchEvent(new SocketEvent(SocketEvent.SECURITY_ERROR, socketItem.socketName));
			Log.getInstance().info("Socket SecurityError. name:" + socketItem.socketName + 
				", host:" + socketItem.host + ", port:" + socketItem.port);
		}
		
		private function onSocketData(event:ProgressEvent):void {
			var socketItem:SocketItem = event.target as SocketItem;
			dispatchEvent(new SocketEvent(SocketEvent.RECEIVED, socketItem.socketName));
			socketItem.readBuffer();
			socketItem.validateData();
		}
	}
}

import com.canaan.lib.managers.SocketManager;
import com.canaan.lib.utils.ObjectUtil;

import flash.net.Socket;
import flash.utils.ByteArray;

class SocketItem extends Socket
{
	private var _socketName:String;
	private var _host:String;
	private var _port:int;
	private var mBuffer:ByteArray;
	
	public function SocketItem(socketName:String)
	{
		super();
		_socketName = socketName;
		mBuffer = new ByteArray();
	}
	
	public function get socketName():String {
		return _socketName;
	}
	
	public function get host():String {
		return _host;
	}
	
	public function get port():int {
		return _port;
	}
	
	override public function connect(host:String, port:int):void {
		_host = host;
		_port = port;
		super.connect(host, port);
	}
	
	public function readBuffer():void {
		readBytes(mBuffer, mBuffer.length, bytesAvailable);
	}
	
	public function validateData():void {
		var short:int = mBuffer.readShort();
		if (mBuffer.bytesAvailable >= short) {
			var bytes:ByteArray = ObjectUtil.gBytes;
			bytes.clear();
			mBuffer.readBytes(bytes, 0, short);
			var data:Object = bytes.readObject();
			SocketManager.getInstance().handler(_socketName, data);
			validateData();
		}
		
		validateBuffer();
	}
	
	public function validateBuffer():void {
		if (mBuffer.position >= SocketManager.bufferMaxSize) {
			mBuffer.clear();
		}
	}
	
	public function dispose():void {
		close();
		mBuffer.clear();
		mBuffer = null;
	}
}