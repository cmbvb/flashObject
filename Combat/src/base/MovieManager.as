package base
{
	import flash.display.MovieClip;
	
	public class MovieManager
	{
		public static const PLAYER_IDLE:MovieClip = new player_idle();									// 人物角色待机动作
		public static const PLAYER_RUN:MovieClip = new player_run();									// 人物角色跑步动作
		public static const PLAYER_HURT:MovieClip = new player_hurt();									// 人物角色受击动作
		public static const PLAYER_BLOCK:MovieClip = new player_block();								// 人物角色防御动作
		public static const PLAYER_JUMP:MovieClip = new player_jump();									// 人物角色跳跃动作
		public static const PLAYER_FALL:MovieClip = new player_fall();									// 人物角色下落动作
//		public static const PLAYER_LAND:MovieClip = new player_land();									// 人物角色下落攻击动作
		public static const PLAYER_RUSHHIT:MovieClip = new player_rushHit();							// 人物角色冲刺动作
		public static const PLAYER_COMMONATK1:MovieClip = new player_CommonAttack1();					// 人物角色普攻1动作
		public static const PLAYER_COMMONATK2:MovieClip = new player_CommonAttack2();					// 人物角色普攻2动作
		public static const PLAYER_COMMONATK3:MovieClip = new player_CommonAttack3();					// 人物角色普攻3动作
		public static const PLAYER_SKILL1:MovieClip = new player_skill1();								// 人物角色技能1动作
		public static const PLAYER_SKILL2:MovieClip = new player_skill2();								// 人物角色技能2动作
		public static const PLAYER_SKILL3:MovieClip = new player_skill3();								// 人物角色技能3动作
	}
}