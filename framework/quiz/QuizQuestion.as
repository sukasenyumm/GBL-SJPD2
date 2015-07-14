package framework.quiz{
    import framework.customObjects.Font;
    import framework.utils.Fonts;
    import starling.display.Sprite;
	import feathers.controls.*;
	import feathers.core.ToggleGroup;
	import starling.text.TextField;
	import starling.events.Event;
	import feathers.themes.MetalWorksDesktopTheme;
    
	/*
	 var group:ToggleGroup = new ToggleGroup();
     group.addEventListener( Event.CHANGE, group_changeHandler );
     
     var radio1:Radio = new Radio();
     radio1.label = "One";
     radio1.toggleGroup = group;
     this.addChild( radio1 );
     
     var radio2:Radio = new Radio();
     radio2.label = "Two";
     radio2.toggleGroup = group;
     this.addChild( radio2 );
     
     var radio3:Radio = new Radio();
     radio3.label = "Three";
     radio3.toggleGroup = group;
     this.addChild( radio3 );
	*/
    public class QuizQuestion extends Sprite {
        private var question:String;
        private var questionField:TextField;
        private var choices:Array;
        private var theCorrectAnswer:int;
        private var theUserAnswer:int = -1;
       
        //variables for positioning:
        private var questionX:int = 5;
        private var questionY:int = 5;
        private var answerX:int = 60;
        private var answerY:int = 55;
        private var spacing:int = 25;
		
		/** Font - Regular text. */
		private var fontRegular:Font;
               
        public function QuizQuestion(theQuestion:String, theAnswer:int, ...answers) {
            //store the supplied arguments in the private variables:
            question = theQuestion;
            theCorrectAnswer = theAnswer;
            choices = answers;
            //create and position the textfield (question):
            fontRegular = Fonts.getFont("Regular");
			
			questionField = new TextField(400, 50, "", fontRegular.fontName, fontRegular.fontSize, 0xffffff);
			
            questionField.text = question;
            questionField.x = questionX;
            questionField.y = questionY;
            this.addChild(questionField);
            //create and position the radio buttons (answers):
            var myGroup:ToggleGroup  = new ToggleGroup();
            myGroup.addEventListener(Event.CHANGE, changeHandler);
            for(var i:int = 0; i < choices.length; i++) {
                var rb:Radio  = new Radio();
                rb.label = choices[i];
                rb.toggleGroup  = myGroup;
				//rb. = i + 1;
                rb.x = answerX;
                rb.y = answerY + (i * spacing);
                this.addChild(rb);
            }
        }
       
        private function changeHandler(event:Event) {
			var group:ToggleGroup = ToggleGroup( event.currentTarget );
			trace("error sini: "+group.selectedIndex)
			theUserAnswer = group.selectedIndex;
        }
        public function get correctAnswer():int {
            return theCorrectAnswer;
        }
        public function get userAnswer():int {
            return theUserAnswer;
        }
    }
}