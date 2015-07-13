package framework.events
{
	import starling.events.Event;
	
	/**
	 * This class defines custom events for navigation in the game. 
	 * @author hsharma
	 * 
	 */
	public class NavigationEvent extends Event
	{
		/** Change of a screen. */		
		public static const SWITCH_STATE:String = "changeScreen";
		
		/** Custom object to pass parameters to the screens. */
		public var params:Object;
		
		public function NavigationEvent(type:String, _params:Object, bubbles:Boolean=false)
		{
			super(type, bubbles);
			params = _params;
		}
	}
}