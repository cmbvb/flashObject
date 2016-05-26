package role.objectPart
{
	import com.canaan.lib.managers.ResManager;
	import com.canaan.lib.role.interfaces.IRenderPart;
	import com.canaan.lib.role.view.AbstractView;
	import com.canaan.lib.role.view.BaseRenderPart;
	
	import flash.display.DisplayObject;
	
	public class AbstractObjectPart extends AbstractView
	{
		public function AbstractObjectPart()
		{
			super();
		}
		
		/**
		 * 动态添加渲染部件
		 * @param type
		 * @param url
		 * @param defaultUrl
		 * @param partClass
		 * @return
		 * 
		 */			
		public function addRenderPartAsync(type:int, url:String, defaultUrl:String = null, partClass:Class = null):IRenderPart {
			var renderPart:IRenderPart = new BaseRenderPart();
			if (renderPart == null) {
				renderPart = addRenderPart(type, null, _direction, partClass);
			}
			
			if (!ResManager.getInstance().hasContent(url)) {
//				if (_showDeafultSkin) {
//					if (defaultUrl != null && ResManager.getInstance().hasContent(defaultUrl)) {
//						renderPart.loadAsync(defaultUrl, 2);
//					} else {
//						renderPart.initRenderPart(type);
//					}
//				}
			}
			renderPart.loadAsync(url, 2);
			_containerParts.addChild(renderPart as DisplayObject);
			return renderPart;
		}
		
	}
}