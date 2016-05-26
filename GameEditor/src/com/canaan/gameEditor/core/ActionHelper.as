package com.canaan.gameEditor.core
{
	import com.canaan.gameEditor.cfg.ActionResConfigVo;
	import com.canaan.gameEditor.cfg.RoleResConfigVo;
	import com.canaan.gameEditor.data.ActionAnimData;
	import com.canaan.gameEditor.data.ActionAnimSequence;
	import com.canaan.gameEditor.data.ActionRoleData;
	import com.canaan.gameEditor.event.GlobalEvent;
	import com.canaan.gameEditor.utils.PNGEncoder;
	import com.canaan.gameEditor.view.common.Alert;
	import com.canaan.lib.core.SysConfig;
	import com.canaan.lib.display.BitmapDataEx;
	import com.canaan.lib.managers.EventManager;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.NativeProcessExitEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class ActionHelper
	{
		private static var encoder:PNGEncoder = new PNGEncoder();
		
		public function ActionHelper()
		{
		}
		
		/**
		 * 保存动作图片
		 * @param roleData
		 * @param id
		 * @param quality
		 * 
		 */		
		public static function saveActionImages(roleData:ActionRoleData, id:String, quality:int):void {
			var actionTotal:int;
			var actionComplete:int;
			for each (var animData:ActionAnimData in roleData.actions) {
				for each (var sequence:ActionAnimSequence in animData.sequences) {
					actionTotal++;
					var rootXML:XML = <lib/>;
					var images:Vector.<BitmapDataEx> = sequence.bitmapDatas;
					for (var i:int = 0; i < images.length; i++) {
						var bitmapDataEx:BitmapDataEx = images[i];
						var className:String = id + "_" + animData.actionId + "_" + sequence.direction + "_" + getIndexString(bitmapDataEx.frameIndex);
						var imagePath:String = GameResPath.file_cfg_actionImages + id + "\\" + animData.actionId + "\\" + sequence.direction + "\\" + getIndexString(bitmapDataEx.frameIndex) + ".png";
						var childXML:XML = <bitmapdata class={className} index={bitmapDataEx.frameIndex} x={bitmapDataEx.x} y={bitmapDataEx.y} file={imagePath} compression={quality == 100 ? false : true} quality={quality}/>
						rootXML.appendChild(childXML);
						var imageBytes:ByteArray = encoder.encode(bitmapDataEx.bitmapData);
						FileHelper.save(imagePath, imageBytes);
					}
					
					var xmlPath:String = GameResPath.file_cfg_actionXML + id + "\\" + animData.actionId + "\\" + sequence.direction + ".xml";
					FileHelper.saveXML(xmlPath, rootXML);
					
					var swfDirectoryPath:String = GameResPath.file_cfg_actionSwf + id + "\\" + animData.actionId;
					var swfPath:String = swfDirectoryPath + "\\" + sequence.direction + ".swf";
					FileHelper.createDirectory(swfDirectoryPath);
					
					var fileOutput:File = new File();
					fileOutput = fileOutput.resolvePath("C:/WINDOWS/system32/cmd.exe");
					var args:Vector.<String> = new <String>["/c", "java", "-jar", GameResPath.file_cfg_lib + "Swift.jar", "xml2lib", 
						xmlPath, swfPath];
					var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
					nativeProcessStartupInfo.arguments = args;
					nativeProcessStartupInfo.executable = fileOutput;
					var process:NativeProcess = new NativeProcess();
					process.start(nativeProcessStartupInfo);
					process.addEventListener(NativeProcessExitEvent.EXIT, function(event:NativeProcessExitEvent):void {
						if (event.exitCode != 0) {
							Alert.show("保存动作发生错误，exitCode:" + event.exitCode);
							return;
						}
						actionComplete++;
						if (actionComplete == actionTotal) {
							EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.ACTION_IMAGES_SAVE_COMPLETE));
						}
					});
				}
			}
		}
		
		/**
		 * 保存动作
		 * @param roleResId
		 * 
		 */		
		public static function saveActions(roleResId:int):void {
			var roleResConfig:RoleResConfigVo = SysConfig.getConfigVo(GameRes.TBL_ROLE_RES, roleResId) as RoleResConfigVo;
			for each (var actionResConfig:ActionResConfigVo in roleResConfig.actionConfigs) {
				for each (var direction:int in actionResConfig.directionArray) {
					var actionId:int = actionResConfig.actionId;
					var swfPath:String = GameResPath.file_cfg_actionSwf + roleResConfig.id + "\\" + actionId + "\\" + direction + ".swf";
					var headData:Object = {};
					var actions:Object = {};
					actions[actionId] = {};
					actions[actionId][direction] = [];
					var xmlPath:String = GameResPath.file_cfg_actionXML + roleResConfig.id + "\\" + actionId + "\\" + direction + ".xml";
					var xml:XML = FileHelper.readXML(xmlPath);
					for (var i:int = 0; i < actionResConfig.animFramesArray.length; i++) {
						var frameIndex:int = actionResConfig.animFramesArray[i];
						var childXML:XML = xml.children()[frameIndex];
						var action:Object = {
							x:int(childXML.@x),
							y:int(childXML.@y),
							frameIndex:frameIndex
						};
						actions[actionId][direction][i] = action;
					}
					headData.id = roleResConfig.id;
					headData.actions = actions;
					
					var swfBytes:ByteArray = FileHelper.read(swfPath);
					var actionBytes:ByteArray = new ByteArray();
					actionBytes.writeObject(headData);
					var lengthHeadData:int = actionBytes.length;
					var lengthSWF:int = swfBytes.length;
					actionBytes.clear();
					actionBytes.writeInt(lengthHeadData);
					actionBytes.writeInt(lengthSWF);
					actionBytes.writeObject(headData);
					actionBytes.writeBytes(swfBytes);
					actionBytes.position = 0;
					actionBytes.compress();
					
					var actionPath:String = GameResPath.file_action + roleResConfig.type + "\\" + roleResId + "\\" + roleResId + "_" + actionId + "_" + direction + ".action";
					FileHelper.save(actionPath, actionBytes);
					var outputPath:String = GameResPath.file_output_action + roleResConfig.type + "\\" + roleResId + "\\" + roleResId + "_" + actionId + "_" + direction + ".action";
					FileHelper.save(outputPath, actionBytes);
				}
			}
		}
		
		public static function getIndexString(frameIndex:int):String {
			var indexString:String = frameIndex.toString();
			while (indexString.length < 4) {
				indexString = "0" + indexString;
			}
			return indexString;
		}
	}
}