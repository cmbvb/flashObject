package com.canaan.mapEditor.view.map
{
	import com.canaan.lib.core.Method;
	import com.canaan.lib.managers.EventManager;
	import com.canaan.lib.utils.StringUtil;
	import com.canaan.mapEditor.events.GlobalEvent;
	import com.canaan.mapEditor.models.contants.TypeMapFunction;
	import com.canaan.mapEditor.models.vo.data.MapAreaVo;
	import com.canaan.mapEditor.models.vo.data.MapUnitVo;
	import com.canaan.mapEditor.ui.map.MapAttrViewUI;
	import com.canaan.mapEditor.view.MainView;
	
	public class MapAttrView extends MapAttrViewUI
	{
		public static var instance:MapAttrView;
		
		private var mMapAreaVo:MapAreaVo;
		private var mMapUnitVo:MapUnitVo;
		
		public function MapAttrView()
		{
			super();
			instance = this;
		}
		
		override protected function onViewCreated():void {
			btnSave.clickHandler = new Method(onSave);
			btnClose.clickHandler = new Method(onClose);
			
			EventManager.getInstance().addEventListener(GlobalEvent.UPDATE_UNIT_POS, onUpdateUnitPos);
		}
		
		private function onUpdateUnitPos(event:GlobalEvent):void {
			var mapUnitVo:MapUnitVo = event.data as MapUnitVo;
			if (mMapUnitVo == mapUnitVo) {
				refresh();
			}
		}
		
		public function showArea(mapAreaVo:MapAreaVo):void {
			viewStack.selectedIndex = 0;
			mMapAreaVo = mapAreaVo;
			mMapUnitVo = null;
			
			txtAreaName.text = mMapAreaVo.name;
			txtAreaExtraData.text = mMapAreaVo.extraData;
			
			chkNonAttack.selected = false;
			chkNonCrossPlayer.selected = false;
			chkNonCrossMonster.selected = false;
			chkNonRide.selected = false;
			chkCanStall.selected = false;
			chkProhibitSkill.selected = false;
			chkCantMove.selected = false;
			txtShieldSkills.text = "";
			txtShieldItems.text = "";
			txtTransfer.text = "";
			txtPlayMusic.text = "";
			txtPlayEffect.text = "";
			txtShowMessage.text = "";
			
			var functionId:int;
			var functionParam:String;
			for (var i:int = 0; i < mMapAreaVo.functionIds.length; i++) {
				functionId = mMapAreaVo.functionIds[i];
				functionParam = mMapAreaVo.functionParams[i];
				switch (functionId) {
					case TypeMapFunction.CANT_ATTACK:
						chkNonAttack.selected = true;
						break;
					case TypeMapFunction.CANT_CROSS_PLAYER:
						chkNonCrossPlayer.selected = true;
						break;
					case TypeMapFunction.CANT_CROSS_MONSTER:
						chkNonCrossMonster.selected = true;
						break;
					case TypeMapFunction.CANT_RIDING:
						chkNonRide.selected = true;
						break;
					case TypeMapFunction.CAN_STALL:
						chkCanStall.selected = true;
						break;
					case TypeMapFunction.CANT_USE_SKILL:
						txtShieldSkills.text = functionParam;
						break;
					case TypeMapFunction.CANT_USE_ITEM:
						txtShieldItems.text = functionParam;
						break;
					case TypeMapFunction.TRANSFER:
						txtTransfer.text = functionParam;
						break;
					case TypeMapFunction.PLAY_AUDIO_MUSIC:
						txtPlayMusic.text = functionParam;
						break;
					case TypeMapFunction.PLAY_AUDIO_EFFECT:
						txtPlayEffect.text = functionParam;
						break;
					case TypeMapFunction.SHOW_MESSAGE:
						txtShowMessage.text = functionParam;
						break;
					case TypeMapFunction.PROHIBIT_SKILL:
						chkProhibitSkill.selected = true;
						break;
					case TypeMapFunction.CANT_MOVE:
						chkCantMove.selected = true;
						break;
					case TypeMapFunction.CANT_DROP:
						chkCantDrop.selected = true;
						break;
					case TypeMapFunction.CANT_RELIVE:
						chkCantRelive.selected = true;
						break;
					case TypeMapFunction.CANT_DEAD_DROP:
						chkCantDeadDrop.selected = true;
						break;
					case TypeMapFunction.PK_AREA:
						chkPKArea.selected = true;
						break;
					case TypeMapFunction.RED_AREA:
						chkRedArea.selected = true;
						break;
					case TypeMapFunction.CANT_AUTO_FIGHT:
						chkCantAutoFight.selected = true;
						break;
					case TypeMapFunction.CANT_TEAM_TRANSFER:
						chkCantTeamTransfer.selected = true;
						break;
				}
			}
		}
		
		public function showUnit(mapUnitVo:MapUnitVo):void {
			viewStack.selectedIndex = 1;
			mMapUnitVo = mapUnitVo;
			mMapAreaVo = null;
			
			txtObjectName.text = mMapUnitVo.name;
			txtObjectUnitId.text = mMapUnitVo.unitId.toString();
			txtObjectMapPos.text = mMapUnitVo.mapX + "*" + mMapUnitVo.mapY;
			txtObjectRealPos.text = mMapUnitVo.realX + "*" + mMapUnitVo.realY;
			txtObjectShowText.text = mMapUnitVo.showText;
			txtObjectShowDelay.text = mMapUnitVo.showDelay.toString();
			txtObjectExtraData.text = mMapUnitVo.extraData;
			chkObjectFixedDir.selected = mMapUnitVo.fixedDir == 1;
			chkObjectCantMove.selected = mMapUnitVo.cantMove == 1;
		}
		
		public function showAttrView():void {
			visible = true;
		}
		
		public function hideAttrView():void {
			visible = false;
		}
		
		public function refresh():void {
			if (mMapAreaVo != null) {
				showArea(mMapAreaVo);
			} else if (mMapUnitVo != null) {
				showUnit(mMapUnitVo);
			}
		}
		
		private function onSave():void {
			if (mMapAreaVo != null) {
				var areaName:String = StringUtil.trim(txtAreaName.text);
				var functionIds:Array = [];
				var functionParams:Array = [];
				// 不可攻击
				if (chkNonAttack.selected) {
					functionIds.push(TypeMapFunction.CANT_ATTACK);
					functionParams.push(1);
				}
				// 不可穿人
				if (chkNonCrossPlayer.selected) {
					functionIds.push(TypeMapFunction.CANT_CROSS_PLAYER);
					functionParams.push(1);
				}
				// 不可穿怪
				if (chkNonCrossMonster.selected) {
					functionIds.push(TypeMapFunction.CANT_CROSS_MONSTER);
					functionParams.push(1);
				}
				// 不可骑乘
				if (chkNonRide.selected) {
					functionIds.push(TypeMapFunction.CANT_RIDING);
					functionParams.push(1);
				}
				// 允许摆摊
				if (chkCanStall.selected) {
					functionIds.push(TypeMapFunction.CAN_STALL);
					functionParams.push(1);
				}
				// 屏蔽技能
				var shieldSkills:String = StringUtil.trim(txtShieldSkills.text);
				if (shieldSkills != "") {
					functionIds.push(TypeMapFunction.CANT_USE_SKILL);
					functionParams.push(shieldSkills);
				}
				// 屏蔽道具
				var shieldItems:String = StringUtil.trim(txtShieldItems.text);
				if (shieldItems != "") {
					functionIds.push(TypeMapFunction.CANT_USE_ITEM);
					functionParams.push(shieldItems);
				}
				// 传送到
				var teleportId:int = int(StringUtil.trim(txtTransfer.text));
				if (teleportId != 0) {
					functionIds.push(TypeMapFunction.TRANSFER);
					functionParams.push(teleportId);
				}
				// 进入音乐
				var musicId:int = int(StringUtil.trim(txtPlayMusic.text));
				if (musicId != 0) {
					functionIds.push(TypeMapFunction.PLAY_AUDIO_MUSIC);
					functionParams.push(musicId);
				}
				// 进入音效
				var effectId:int = int(StringUtil.trim(txtPlayEffect.text));
				if (effectId != 0) {
					functionIds.push(TypeMapFunction.PLAY_AUDIO_EFFECT);
					functionParams.push(effectId);
				}
				// 文字提示
				var showMessage:String = StringUtil.trim(txtShowMessage.text);
				if (showMessage != "") {
					functionIds.push(TypeMapFunction.SHOW_MESSAGE);
					functionParams.push(showMessage);
				}
				// 禁止使用技能
				if (chkProhibitSkill.selected) {
					functionIds.push(TypeMapFunction.PROHIBIT_SKILL);
					functionParams.push(1);
				}
				// 禁止移动
				if (chkCantMove.selected) {
					functionIds.push(TypeMapFunction.CANT_MOVE);
					functionParams.push(1);
				}
				// 禁止丢弃
				if (chkCantDrop.selected) {
					functionIds.push(TypeMapFunction.CANT_DROP);
					functionParams.push(1);
				}
				// 禁止原地复活
				if (chkCantRelive.selected) {
					functionIds.push(TypeMapFunction.CANT_RELIVE);
					functionParams.push(1);
				}
				// 死亡不掉落物品
				if (chkCantDeadDrop.selected) {
					functionIds.push(TypeMapFunction.CANT_DEAD_DROP);
					functionParams.push(1);
				}
				// PK区域
				if (chkPKArea.selected) {
					functionIds.push(TypeMapFunction.PK_AREA);
					functionParams.push(1);
				}
				// 红名区
				if (chkRedArea.selected) {
					functionIds.push(TypeMapFunction.RED_AREA);
					functionParams.push(1);
				}
				// 禁止自动挂机
				if (chkCantAutoFight.selected) {
					functionIds.push(TypeMapFunction.CANT_AUTO_FIGHT);
					functionParams.push(1);
				}
				// 禁止天人合一技能
				if (chkCantTeamTransfer.selected) {
					functionIds.push(TypeMapFunction.CANT_TEAM_TRANSFER);
					functionParams.push(1);
				}
				mMapAreaVo.name = areaName;
				mMapAreaVo.functionIds = functionIds;
				mMapAreaVo.functionParams = functionParams;
				
				var areaExtraData:String = StringUtil.trim(txtAreaExtraData.text);
				mMapAreaVo.extraData = areaExtraData;
			} else if (mMapUnitVo != null) {
				var unitName:String = StringUtil.trim(txtObjectName.text);
				mMapUnitVo.name = unitName;
				var objectShowText:String = StringUtil.trim(txtObjectShowText.text);
				mMapUnitVo.showText = objectShowText;
				var objectShowDelay:int = int(StringUtil.trim(txtObjectShowDelay.text));
				mMapUnitVo.showDelay = objectShowDelay;
				var objectExtraData:String = StringUtil.trim(txtObjectExtraData.text);
				mMapUnitVo.extraData = objectExtraData;
				var objectFixedDir:int = chkObjectFixedDir.selected ? 1 : 0;
				mMapUnitVo.fixedDir = objectFixedDir;
				var objectCantMove:int = chkObjectCantMove.selected ? 1 : 0;
				mMapUnitVo.cantMove = objectCantMove;
			}
			EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.UPDATE_MAP_OBJECT, mMapUnitVo));
			EventManager.getInstance().dispatchEvent(new GlobalEvent(GlobalEvent.UPDATE_MAP_OBJECTS));
		}
		
		private function onClose():void {
			MainView.instance.chkShowObjectInfo.selected = false;
			MapView.instance.hideObjectInfo();
		}
	}
}