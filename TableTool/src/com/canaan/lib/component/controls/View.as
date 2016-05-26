package com.canaan.lib.component.controls
{
	import com.canaan.lib.component.IItem;
	import com.canaan.lib.component.UIComponent;
	import com.canaan.lib.core.Config;
	import com.canaan.lib.core.Method;
	import com.canaan.lib.core.ResItem;
	import com.canaan.lib.events.UIEvent;
	import com.canaan.lib.managers.ResManager;
	
	import flash.utils.Dictionary;
	
	[Event(name="viewCreated", type="com.canaan.lib.events.UIEvent")]
	
	public class View extends Container
	{
		protected static var uiClassMap:Object = {
			"UIComponent": UIComponent,
			"Container": Container,
			"Box": Box,
			"Button": Button,
			"CheckBox": CheckBox,
			"Clip": Clip, 
			"ComboBox":ComboBox, 
			"FrameClip": FrameClip,
			"HScrollBar": HScrollBar,
			"HSlider": HSlider,
			"Image": Image,
			"Label": Label,
			"LinkButton": LinkButton,
			"List": List,
			"Panel": Panel,
			"ProgressBar": ProgressBar,
			"RadioButton": RadioButton,
			"RadioGroup": RadioGroup,
			"ScrollBar": ScrollBar,
			"Slider": Slider,
			"Tab": Tab,
			"TextArea": TextArea,
			"TextInput": TextInput,
			"View": View,
			"ViewStack": ViewStack,
			"VScrollBar": VScrollBar,
			"VSlider": VSlider,
			"HBox": HBox,
			"VBox": VBox,
			"Paging": Paging,
			"BitmapNumber": BitmapNumber,
			"Tree": Tree
		};
		
		protected static var viewClassMap:Object = {};
		public static var xmlMap:Object = {};
		
		protected var preLoadFinished:Boolean;
		protected var viewCreated:Boolean;
		protected var viewXml:XML;
		
		public function View()
		{
			loadProloadFiles();
			super();
		}
		
		
		protected function listPreloadFiles():Vector.<ResItem> {
			return null;
		}
		
		protected function loadProloadFiles():void {
			var preloadFiles:Vector.<ResItem> = listPreloadFiles();
			if (preloadFiles != null && preloadFiles.length != 0 && !preLoadFinished) {
				for each (var file:ResItem in preloadFiles) {
					ResManager.getInstance().add(file.url, file.id, file.name);
				}
				ResManager.getInstance().load(new Method(preloadFilesComplete));
			} else {
				preloadFilesComplete();
			}
		}
		
		protected function preloadFilesComplete():void {
			preLoadFinished = true;
			onInitialized();
			if (viewXml != null) {
				createView(viewXml);
			}
		}
		
		protected function onInitialized():void {
			
		}
		
		protected function onViewCreated():void {
			
		}
		
		protected function loadUI(path:String):void {
			var xml:XML = xmlMap[path];
			if (xml != null) {
				createView(xml);
			} else {
				var url:String = Config.getConfig("dirUIXml") + path;
				ResManager.getInstance().add(url, path, "", new Method(loadUIComplete, [path]));
				ResManager.getInstance().load();
			}
		}
		
		protected function loadUIComplete(path:String, content:*):void {
			var xml:XML = new XML(content);
			xmlMap[path] = xml;
			createView(xml);
		}
		
		protected function createView(xml:XML):void {
			viewXml = xml;
			if (preLoadFinished) {
				createComp(xml, this, this);
				viewCreated = true;
				onViewCreated();
				sendEvent(UIEvent.VIEW_CREATED);
			}
		}
		
		/** 根据xml实例组件
		 * @param	xml 视图xml
		 * @param	comp 组件本体，如果为空，会新创建一个
		 * @param	view 组件所在的视图实例，用来注册var全局变量，为空则不注册*/
		public static function createComp(xml:XML, comp:UIComponent = null, view:View = null):UIComponent {
			comp = comp || getCompInstance(xml);
			comp.comXml = xml;
			for (var i:int = 0, m:int = xml.children().length(); i < m; i++) {
				var node:XML = xml.children()[i];
				if (comp is List && node.@name == "render") {
					List(comp).itemRender = node;
				} else if (comp is Tree && node.@name == "render") {
					Tree(comp).itemRender = node;
				} else {
					comp.addChild(createComp(node, null, view));
				}
			}
			for each (var attrs:XML in xml.attributes()) {
				var prop:String = attrs.name().toString();
				var value:String = attrs;
				if (comp.hasOwnProperty(prop)) {
					comp[prop] = (value == "true" ? true : (value == "false" ? false : value))
				} else if (prop == "var" && view && view.hasOwnProperty(value)) {
					view[value] = comp;
				}
			}
			if (comp is IItem) {
				IItem(comp).initItems();
			}
			return comp;
		}
		
		/**获得组件实例*/
		protected static function getCompInstance(xml:XML):UIComponent {
			var runtime:String = xml.@runtime;
			var compClass:Class = Boolean(runtime) ? viewClassMap[runtime] : uiClassMap[xml.name()];
			return compClass ? new compClass() : null;
		}
		
		/**重新创建组件(通过修改组件的xml，实现动态更改UI视图)
		 * @param comp 需要重新生成的组件 comp为null时，重新创建整个视图*/
		public function reCreate(comp:UIComponent = null):void {
			comp = comp || this;
			var dataSource:Object = comp.dataSource;
			if (comp is Box) {
				Box(comp).removeAllChild();
			}
			createComp(comp.comXml, comp, this);
			comp.dataSource = dataSource;
		}
		
		/**注册组件(用于扩展组件及修改组件对应关系)*/
		public static function registerComponent(key:String, compClass:Class):void {
			uiClassMap[key] = compClass;
		}
	}
}