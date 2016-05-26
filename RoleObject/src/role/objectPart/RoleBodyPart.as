package role.objectPart
{
	import com.canaan.lib.core.TableConfig;
	import com.canaan.lib.managers.TimerManager;
	import com.canaan.lib.role.interfaces.IRenderPart;
	
	import role.constants.TypeRenderPart;
	
	import table.ActionResTempleConfigVo;

	public class RoleBodyPart extends AbstractObjectPart
	{
		private var mClothesPart:IRenderPart;
		private var mWeapon:IRenderPart;
		
		
		public function RoleBodyPart()
		{
			super();
			playActionInner();
		}
		
		override protected function playActionInner():void {
			var action:ActionResTempleConfigVo = TableConfig.getConfigVo(GameRes.TBL_ACTION_RES, "10000_3") as ActionResTempleConfigVo;
			mClothesPart = addRenderPartAsync(TypeRenderPart.CLOTHES, action.resUrl, action.resUrl);
			mClothesPart.playAction(3, 1, false);
			mWeapon = addRenderPartAsync(TypeRenderPart.WEAPON, GameRes.action + "4/40000_3_1.action");
			mWeapon.playAction(3, 1, false);
			TimerManager.getInstance().doFrameLoop(1, update);
		}
		
		public function update():void {
			if (mClothesPart.bitmapDatas) {
				mClothesPart.setFrameIndex(mClothesPart.getFrameIndex() % mClothesPart.bitmapDatas.length + 1);
				mWeapon.setFrameIndex(mWeapon.getFrameIndex() % mWeapon.bitmapDatas.length + 1);
			}
		}
		
	}
}