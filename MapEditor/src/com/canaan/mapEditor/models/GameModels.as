package com.canaan.mapEditor.models
{
	import com.canaan.mapEditor.models.entities.ModelUnit;

	public class GameModels
	{
		public static var modelUnit:ModelUnit;
		
		public function GameModels()
		{
			super();
		}
		
		public static function initialize():void {
			modelUnit = new ModelUnit();
		}
	}
}