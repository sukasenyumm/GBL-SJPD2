package  {
	import flash.system.Capabilities;
	public class GameSettings {
			//do not set true for both of this!!
			public static const RESET_SAVE:Boolean = false;
			public static const CHEAT_MODE:Boolean = false;
			//
			public static const isIOS:Boolean = (Capabilities.manufacturer.indexOf("iOS") != -1);
			public static const isAndroid:Boolean = (Capabilities.manufacturer.indexOf("Android") != -1) ;
			public static const isDummy:Boolean = (Capabilities.manufacturer.indexOf("dummy") != -1) 
	}
}
