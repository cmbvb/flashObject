package com.canaan.lib.managers
{
	import com.canaan.lib.debug.Log;
	import com.canaan.lib.utils.ObjectUtil;
	import com.canaan.lib.utils.StringUtil;
	
	import flash.utils.Dictionary;
	
    public class LocalManager
    {
    	private static var canInstantiate:Boolean;
        private static var instance:LocalManager;

        private var messages:Dictionary = new Dictionary();
		private var objectMessages:Dictionary = new Dictionary();

        public function LocalManager()
        {
            if (!canInstantiate) {
				throw new Error("Can not instantiate, use getInstance() instead.");
			}
        }
        
        public static function getInstance():LocalManager {
            if (instance == null) {
            	canInstantiate = true;
                instance = new LocalManager();
                canInstantiate = false;
            }
            return instance;
        }
        
        public function loadResources(value:String, resourceName:String):void {
			var resource:Dictionary = messages[resourceName];
			if (resource == null) {
				resource = new Dictionary();
				messages[resourceName] = resource;
			}
        	var list:Array = [];
        	var substring:int;
        	var lineNum:int = -1;
			var l:int = value.length;
			for (var i:int = 0; i < l; i++) {
                var char:String = value.charAt(i);
                if (char == "\n" || char == "\r") {
                    if (lineNum != -1) {
                        list[substring] = value.substring(lineNum, i);
                        substring++;
                        lineNum = -1;
                    }
                } else {
                    if (lineNum == -1) {
                        lineNum = i;
                    }
                }
            }
            if (lineNum != -1) {
                list[substring] = value.substring(lineNum);
                substring++;
            }
            for each (var line:String in list) {
                var indexOf:int = line.indexOf("=");
                if (indexOf != -1) {
                	var mKey:String = StringUtil.trim(line.substring(0, indexOf));
                    var rtrim:String = StringUtil.trim(line.substring(indexOf + 1));
                    var flag:Boolean = true;
                    do {
                        var r:String = rtrim.replace("\\n", "\n");
                        if (r == rtrim)
                        {
                            flag = false;
                        }
                        rtrim = r;
                    } while (flag);
                    
                    while (rtrim.indexOf("\\") != -1) {
                    	rtrim = rtrim.replace("\\", "");
                    }
					resource[mKey] = rtrim;
                } 
            }
        }
        
        public function getString(name:String, resourceName:String, parameters:Array = null):String {
			var resource:Dictionary = messages[resourceName];
			if (resource == null) {
				throw new Error("LocaleManager.getString error : Has not installed the resource \"" + resourceName + "\"");
			}
			if (resource[name] == null) {
	            Log.getInstance().error("LocaleManager.getString error : Has Not installed the string. resourceName:" + resourceName + ", name:" + name);
	        }
	        
            var value:String = resource[name] || resourceName + "::" + name;
			if (parameters != null) {
				var i:int = 0;
				while (i < parameters.length) {
					value = value.replace(new RegExp("\\{" + i + "\\}", "g"), parameters[i]);
					i++;
				}
			}
			return value;
        }
		
		public function loadObjectResources(resourceName:String, value:Object):void {
			if (!objectMessages[resourceName]) {
				objectMessages[resourceName] = new Dictionary();
			}
			ObjectUtil.merge(objectMessages[resourceName], value);
		}
		
		public function loadObjectString(name:String, resourceName:String, value:Object):void {
			if (!objectMessages[resourceName]) {
				objectMessages[resourceName] = new Dictionary();
			}
			objectMessages[resourceName][name] = value;
		}
		
		/**
		 * 根据id, 列名获取翻译 
		 * @param name			唯一ID
		 * @param keyName		获取翻译的列名
		 * @param resourceName	csv翻译文件
		 * @param parameters	参数
		 * @return 
		 * 
		 */		
		public function getObjectString(name:String, keyName:String, resourceName:String, parameters:Array = null):String {
			if (!objectMessages[resourceName]) {
				throw new Error("LocalManager Not installed package:" + resourceName);
			}
			if (!objectMessages[resourceName][name]) {
				throw new Error("LocalManager Not installed package:" + resourceName + "_" + name);
			}
			var value:String = objectMessages[resourceName][name][keyName] || resourceName + "_" + name + "_" + keyName;
			while (value.indexOf("\\n") != -1) {
				value = value.replace("\\n", "\n");
			}
			if (parameters) {
				var i:int = 0;
				while (i < parameters.length) {
					value = value.replace(new RegExp("\\{" + i + "\\}", "g"), parameters[i]);
					i++;
				}
			}
			return value;
		}
		
		public function hasObjectString(name:String, resourceName:String):Boolean {
			if (!objectMessages[resourceName]) {
				throw new Error("LocalManager Not installed package:" + resourceName);
			}
			return objectMessages[resourceName].hasOwnProperty(name);
		}
    }
}
