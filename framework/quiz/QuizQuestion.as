package framework.quiz{
    import starling.display.Sprite;
	import feathers.controls.*;
	import feathers.core.ToggleGroup;
	import starling.text.TextField;
	import starling.events.Event;
	import flash.text.TextFormat;
   
    public class QuizQuestion extends Sprite {
        private var question:String;
        private var questionField:TextField;
        private var choices:Array;
        private var theCorrectAnswer:int;
        private var theUserAnswer:int = -1;
       
        //variables for positioning:
        private var questionX:int = 20;
        private var questionY:int = 20;
        private var answerX:int = 60;
        private var answerY:int = 85;
        private var spacing:int = 35;
		private var smallLightTextFormat:TextFormat;
		
		        
        public function QuizQuestion(rbX:int,theQuestion:String, theAnswer:int, ...answers) {
            //store the supplied arguments in the private variables:
            question = theQuestion;
            theCorrectAnswer = theAnswer;
            choices = answers;
            //create and position the textfield (question):
            //fontRegular = Fonts.getFont("Regular");
			
			//questionField = new TextField(400, 50, "", fontRegular.fontName, fontRegular.fontSize, 0xffffff);
			questionField = new TextField(400, 70, "", "nulshock", 14, 0x000000);
			
            questionField.text = question;
            questionField.x = rbX-questionField.width/2;
            questionField.y = questionY;
            this.addChild(questionField);
            //create and position the radio buttons (answers):
            var myGroup:ToggleGroup  = new ToggleGroup();
            myGroup.addEventListener(Event.CHANGE, changeHandler);
            for(var i:int = 0; i < choices.length; i++) {
                var rb:Radio  = new Radio();
                rb.label = choices[i];
                rb.toggleGroup  = myGroup;
               	rb.x = questionField.x;
				rb.y = answerY + (i * spacing);
                this.addChild(rb);
            }
			
        }
       
        private function changeHandler(event:Event) {
			var group:ToggleGroup = ToggleGroup( event.currentTarget );
			//trace("error sini: "+group.selectedIndex)
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