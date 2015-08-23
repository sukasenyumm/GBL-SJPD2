package framework.utils
{
    import flash.display.MovieClip;
    import flash.events.Event;
    import framework.events.TimelineEvent;

    public class CustomMovieClip extends MovieClip
    {
        private var _isLastFrame:Boolean;

        public function get isLastFrame():Boolean { return _isLastFrame }

        public function CustomMovieClip()
        {
            init();

        }// end function

        private function init():void
        {
            addEventListener(Event.ENTER_FRAME, onEnterFrame);

        }// end function

        private function onEnterFrame(e:Event):void
        {
            if (!_isLastFrame)
            {
                if (currentFrame == totalFrames) 
                {
                    dispatchEvent(new TimelineEvent(TimelineEvent.LAST_FRAME));
                    _isLastFrame = true;

                }// end if

            }
            else 
            {
                if (currentFrame != totalFrames) _isLastFrame = false;

            }// end else

        }// end function

    }// end class

}// end package