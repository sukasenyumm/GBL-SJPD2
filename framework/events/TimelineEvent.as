package framework.events
{   
    import flash.events.Event;

    public class TimelineEvent extends Event 
    {
        public static var LAST_FRAME:String = "lastFrame";

        public function TimelineEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
        { 
            super(type, bubbles, cancelable);

        }// end function

        public override function clone():Event 
        { 
            return new TimelineEvent(type, bubbles, cancelable);

        }// end function

    }// end class

}// end package

