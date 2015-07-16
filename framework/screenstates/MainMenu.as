package framework.screenstates
{
	import starling.display.Sprite;
	import starling.display.Image;
	import framework.utils.GameAssets;
	import starling.display.BlendMode;
	import starling.events.Event;
	import starling.display.Button;
	import starling.text.TextField;
	import framework.customobjects.Font;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import framework.utils.Fonts;
	import framework.quiz.QuizQuestion;
	import flash.text.TextFieldAutoSize;
	import feathers.themes.MetalWorksDesktopTheme;
	import starling.animation.Tween;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import framework.events.NavigationEvent;
	
	
	/**
	 * This is the welcome or main menu class for the game.
	 *  
	 * @author hsharma
	 * 
	 */
	public class MainMenu extends Sprite
	{
		/** Background image. */
		private var bg:Image;
		/** Game title. */
		private var title:Image;
		/** hero */
		private var hero:Image;
		/** About button. */
		private var aboutBtn:Button;
		/** Help button. */
		private var helpBtn:Button;
		/** Achievement button. */
		private var achievementBtn:Button;
		/** Quiz button. */
		private var quizBtn:Button;
		/** Play button. */
		private var playBtn:Button;
		/** Back button. */
		private var backBtn:Button;
		/** Screen mode - "welcome" or "about". */
		private var screenMode:String;
		/** About text field. */
		private var aboutText:TextField;
		/** Font - Regular text. */
		private var fontRegular:Font;
		
		/* for quiz declaration */
		//for managing questions:
        private var quizQuestions:Array;
        private var currentQuestion:QuizQuestion;
        private var currentIndex:int = 0;
        //the buttons:
        private var prevButton:Button;
        private var nextButton:Button;
        private var finishButton:Button;
        //scoring and messages:
        private var score:int = 0;
        private var statusT:TextField;
		/*end quiz declaration */
		
		/*animation*/
		private var tweenHero:Tween;
		/** Current date. */
		private var _currentDate:Date;
		/*end animation*/
		
		public function MainMenu()
		{
			super();
			new MetalWorksDesktopTheme();
			this.visible = false;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/**
		 * On added to stage. 
		 * @param event
		 * 
		 */
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			drawScreen();
		}
		
		/**
		 * Draw all the screen elements. 
		 * 
		 */
		private function drawScreen():void
		{
			// GENERAL ELEMENTS
			
			bg = new Image(GameAssets.getTexture("BgWelcome"));
			bg.blendMode = BlendMode.NONE;
			bg.width = 960;
			bg.height = 640;
			this.addChild(bg);
			
			title = new Image(GameAssets.getAtlas().getTexture(("welcome_title")));
			title.x = 10;
			title.y = 15;
			this.addChild(title);
			
			hero = new Image(GameAssets.getAtlas().getTexture("welcome_hero"));
			this.addChild(hero);
			
			// ABOUT ELEMENTS
			fontRegular = Fonts.getFont("Regular");
			
			aboutText = new TextField(480, 600, "", fontRegular.fontName, fontRegular.fontSize, 0xffffff);
			aboutText.text = "Hungry Hero is a free and open source game built on Adobe Flash using Starling Framework.\n\nhttp://www.hungryherogame.com\n\n" +
				" The concept is very simple. The hero is pretty much always hungry and you need to feed him with food." +
				" You score when your Hero eats food.\n\nThere are different obstacles that fly in with a \"Look out!\"" +
				" caution before they appear. Avoid them at all costs. You only have 5 lives. Try to score as much as possible and also" +
				" try to travel the longest distance.";
			aboutText.x = 60;
			aboutText.y = 230;
			aboutText.hAlign = HAlign.CENTER;
			aboutText.vAlign = VAlign.TOP;
			aboutText.height = aboutText.textBounds.height + 30;
			this.addChild(aboutText);
			
			statusT = new TextField(480, 600, "", fontRegular.fontName, fontRegular.fontSize, 0xffffff);
			statusT.x = 0;
			statusT.y = 100;
			statusT.hAlign = HAlign.CENTER;
			statusT.vAlign = VAlign.TOP;
			this.addChild(statusT);
			
			/* play button  NOO it's quiz*/
			playBtn = new Button(GameAssets.getAtlas().getTexture("welcome_playButton"));
			playBtn.x = 640;
			playBtn.y = 340;
			playBtn.addEventListener(Event.TRIGGERED, onPlayClick);
			this.addChild(playBtn);
			
			/* about button */
			aboutBtn = new Button(GameAssets.getAtlas().getTexture("welcome_aboutButton"));
			aboutBtn.x = 460;
			aboutBtn.y = 20;
			aboutBtn.addEventListener(Event.TRIGGERED, onAboutClick);
			this.addChild(aboutBtn);
			
			/* back button */
			backBtn = new Button(GameAssets.getAtlas().getTexture("about_backButton"));
			backBtn.x = 660;
			backBtn.y = 350;
			backBtn.addEventListener(Event.TRIGGERED, onAboutBackClick);
			this.addChild(backBtn);
			
			/* quiz button */
			quizBtn = new Button(GameAssets.getAtlas().getTexture("fly_0004"));
			quizBtn.x = 660;
			quizBtn.y = 250;
			quizBtn.addEventListener(Event.TRIGGERED, onQuizClick);
			this.addChild(quizBtn);
			
			/* quiz button */
			 var yPosition:Number = 300;
	
			prevButton = new Button(GameAssets.getAtlas().getTexture("welcome_playButton"));
			prevButton.x = 30;
			prevButton.y = yPosition;
			prevButton.addEventListener(Event.TRIGGERED, prevHandler);
			this.addChild(prevButton);
			

            nextButton = new Button(GameAssets.getAtlas().getTexture("welcome_playButton"));
            nextButton.x = prevButton.x + prevButton.width + 40;
            nextButton.y = yPosition;
            nextButton.addEventListener(Event.TRIGGERED, nextHandler);
            this.addChild(nextButton);

            finishButton = new Button(GameAssets.getAtlas().getTexture("welcome_playButton"));
            finishButton.x = nextButton.x + nextButton.width + 40;
            finishButton.y = yPosition;
            finishButton.addEventListener(Event.TRIGGERED, finishHandler);
            this.addChild(finishButton);
			
			quizQuestions = new Array();
            createQuestions();
			/* end quiz button */
			

			this.addEventListener(Event.TRIGGERED, onMainMenuClick);
		}
		
		private function onMainMenuClick(event:Event):void
		{
			var buttonClick:Button = event.target as Button;
			if(buttonClick as Button == playBtn)
			{
				this.dispatchEvent(new NavigationEvent(NavigationEvent.SWITCH_STATE, {id: "play"},true));
			}
		}
		
		private function onPlayClick(event:Event):void
		{
			showQuiz();
		}
		
		private function onQuizClick(event:Event):void
		{
			showQuiz();
		}
		
		private function onAboutClick(event:Event):void
		{
			showMessage("");
			showAbout();
		}
		
		private function onAboutBackClick(event:Event):void
		{
			showMessage("");
			initialize();
		}
		
		public function showAbout():void
		{
			screenMode = "about";
			hero.visible = false;
			playBtn.visible = false;
			aboutBtn.visible = false;
			aboutText.visible = true;
			backBtn.visible = true;
			quizBtn.visible = false;
		}
		
		public function showQuiz():void
		{
			screenMode = "quiz";
			hero.visible = false;
			title.visible = false;
			playBtn.visible = false;
			backBtn.visible = true;
			aboutBtn.visible = false;
            prevButton.visible = true;
			nextButton.visible =true;
			finishButton.visible = true;
			quizBtn.visible = false;
			addAllQuestions();
            hideAllQuestions();
            firstQuestion();
		}
		

		public function initialize():void
		{
			disposeTemporarily();		
			this.visible = true;
			title.visible = true;
			hero.visible = true;
			aboutText.visible = false;
			backBtn.visible = false;
			aboutBtn.visible = true;
			playBtn.visible = true;
			quizBtn.visible = true;
			prevButton.visible = false;
			nextButton.visible =false;
			finishButton.visible = false;
			
			hideAllQuestions();
			
			//animation
			hero.x = -hero.width;
			hero.y = 100;
			
			
			tweenHero = new Tween(hero, 4, Transitions.EASE_OUT);
			tweenHero.animate("x", 80);
			Starling.juggler.add(tweenHero);
			
			this.addEventListener(Event.ENTER_FRAME, floatingAnimation);
		}
		
		/**
		 * Animate floating objects. 
		 * @param event
		 * 
		 */
		private function floatingAnimation(event:Event):void
		{
			_currentDate = new Date();
			hero.y = 130 + (Math.cos(_currentDate.getTime() * 0.002)) * 25;
			playBtn.y = 340 + (Math.cos(_currentDate.getTime() * 0.002)) * 10;
			aboutBtn.y = 460 + (Math.cos(_currentDate.getTime() * 0.002)) * 10;
			quizBtn.y = 260 + (Math.cos(_currentDate.getTime() * 0.002)) * 10;
		}
		
		/**
		 * Dispose objects temporarily. 
		 * 
		 */
		public function disposeTemporarily():void
		{
			this.visible = false;
			if(this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME,floatingAnimation);
		}
		
		/* quiz only here
		*
		*/
		 private function createQuestions() {
            quizQuestions.push(new QuizQuestion("What color is an orange?",
                                                            0,
                                                            "Orange",
                                                            "Blue",
                                                            "Purple",
                                                            "Brown"));
            quizQuestions.push(new QuizQuestion("What is the shape of planet earth?",
                                                            2,
                                                            "Flat",
                                                            "Cube",
                                                            "Round",
                                                            "Shabby"));
            quizQuestions.push(new QuizQuestion("Who created SpiderMan?",
                                                            1,
                                                            "Jack Kirby",
                                                            "Stan Lee and Steve Ditko",
                                                            "Stan Lee",
                                                            "Steve Ditko",
                                                            "none of the above"));
            quizQuestions.push(new QuizQuestion("Who created Mad?",
                                                            1,
                                                            "Al Feldstein",
                                                            "Harvey Kurtzman",
                                                            "William M. Gaines",
                                                            "Jack Davis",
                                                            "none of the above"));
        }
		
   
        private function showMessage(theMessage:String) {
            statusT.text = theMessage;
            statusT.x = 200;
        }
        private function addAllQuestions() {
            for(var i:int = 0; i < quizQuestions.length; i++) {
                this.addChild(quizQuestions[i]);
            }
        }
        private function hideAllQuestions() {
            for(var i:int = 0; i < quizQuestions.length; i++) {
                quizQuestions[i].visible = false;
            }
        }
        private function firstQuestion() {
            currentQuestion = quizQuestions[0];
            currentQuestion.visible = true;
        }
        private function prevHandler(event:Event) {
            showMessage("");
            if(currentIndex > 0) {
                currentQuestion.visible = false;
                currentIndex--;
                currentQuestion = quizQuestions[currentIndex];
                currentQuestion.visible = true;
            } else {
                showMessage("sebelumnya");
            }
        }
        private function nextHandler(event:Event) {
            showMessage("error");
			trace("user: "+currentQuestion.userAnswer)
            if(currentQuestion.userAnswer < 0) {
                showMessage("sesudahnya");
                return;
            }
            if(currentIndex < (quizQuestions.length - 1)) {
                currentQuestion.visible = false;
                currentIndex++;
                currentQuestion = quizQuestions[currentIndex];
                currentQuestion.visible = true;
            } else {
                showMessage("That's all the questions! Click Finish to Score, or Previous to go back");
            }
        }
        private function finishHandler(event:Event) {
            showMessage("");
            var finished:Boolean = true;
            for(var i:int = 0; i < quizQuestions.length; i++) {
                if(quizQuestions[i].userAnswer == 0) {
                    finished = false;
                    break;
                }
            }
			trace(quizQuestions.length)
            if(finished || currentIndex == quizQuestions.length -1) {
                prevButton.visible = false;
                nextButton.visible = false;
                finishButton.visible = false;
                hideAllQuestions();
                computeScore();
            } else {
                showMessage("belum selesai semua");
            }
        }
        private function computeScore() {
            for(var i:int = 0; i < quizQuestions.length; i++) {
                if(quizQuestions[i].userAnswer == quizQuestions[i].correctAnswer) {
                    score++;
                }
            }
            showMessage("You answered " + score + " correct out of " + quizQuestions.length + " questions.");
			//trace("You answered " + score + " correct out of " + quizQuestions.length + " questions.")
        }
		
		/*end quiz here*/
	
	}
}