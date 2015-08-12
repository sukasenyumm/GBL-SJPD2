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
	import framework.utils.SaveManager;
	import flash.desktop.NativeApplication;
	import starling.display.Quad;
	
	
	/**
	 * This is the welcome or main menu class for the game.
	 *  
	 * @author hsharma
	 * 
	 */
	public class MainMenu extends Sprite
	{
		/** Background image. */
		private var bg:Quad;
		/** Game title. */
		private var title:Image;
		/** hero */
		private var hero:Image;
		/** About button. */
		private var aboutBtn:Button;
		/** Items button. */
		private var itemsBtn:Button;
		/** Info button. */
		private var helpBtn:Button;
		/** Quiz button. */
		private var quizBtn:Button;
		/** Sound button. */
		private var soundBtn:Button;
		/** Exit button. */
		private var exitBtn:Button;
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
			var bottomColor:uint = 0xFFFFFF; // blue
			var topColor:uint    = 0xea0b0b; // red	
			
			bg = new Quad(stage.stageWidth, stage.stageHeight, 0x000000);
			bg.blendMode = BlendMode.NONE;
			this.addChild(bg);
			
			bg.setVertexColor(0, topColor);
			bg.setVertexColor(1, topColor);
			bg.setVertexColor(2, bottomColor);
			bg.setVertexColor(3, bottomColor);
			
			hero = new Image(GameAssets.getAtlas().getTexture("welcome_hero"));
			hero.width = hero.width*.5;
			hero.width = hero.height*.5;
			this.addChild(hero);
			
			title = new Image(GameAssets.getAtlasFix().getTexture("lbl_title"));
			title.x = stage.stageWidth/14;
			title.y = stage.stageHeight/14;
			this.addChild(title);
			
			// ABOUT ELEMENTS
			fontRegular = Fonts.getFont("Regular");
			
			aboutText = new TextField(stage.stageWidth - stage.stageWidth/14, stage.stageHeight -  stage.stageHeight/14, "", "Consolas", 14, 0x000000);
			aboutText.text = "PESAWAT INSULINDE adalah sebuah game untuk mempelajari Sejarah Indonesia.\n\n" +
				" Pesawat Insulinde bertugas untuk mengejar pesawat X yang telah mencuri lembaran-lembaran sejarah yang ada di Indonesia." +
				" Dalam perjalanannya, pesawat X tadi menjatuhkan lembaran-lembaran sejarah disepanjang jalan." +
				" Jangan lupa kumpulkan juga batu pengetahuan untuk membuka sesi quiz pada menu game.\n\n"+
				" Game ini diciptakan oleh:\n"+
				" Abas Setiawan (Produser dan Programmer)\n"+
				" Yusuf Priambodo (Desainer dan Ilustrator)\n"+
				" Copyright @2015";
			aboutText.x = stage.stageWidth/2 - aboutText.textBounds.width/2;
			aboutText.y = title.y+title.height;
			aboutText.hAlign = HAlign.CENTER;
			aboutText.vAlign = VAlign.TOP;
			//aboutText.border = true;
			this.addChild(aboutText);
			
			/* play button*/
			playBtn = new Button(GameAssets.getAtlasFix().getTexture("btn_play"));
			playBtn.x = stage.stageWidth/2 + playBtn.width;
			playBtn.y = stage.stageHeight/2 - playBtn.height/2;
			playBtn.addEventListener(Event.TRIGGERED, onPlayClick);
			this.addChild(playBtn);
			
			/* exit button */
			exitBtn = new Button(GameAssets.getAtlasFix().getTexture("btn_quit"));
			exitBtn.x = stage.stageWidth - exitBtn.width - (stage.stageWidth/14);
			exitBtn.y = (stage.stageHeight/14);
			exitBtn.addEventListener(Event.TRIGGERED, onExitClick);
			this.addChild(exitBtn);
			
			/* sound button */
			soundBtn = new Button(GameAssets.getAtlasFix().getTexture("btn_sound"));
			soundBtn.x = exitBtn.x - exitBtn.width - (stage.stageHeight/20);
			soundBtn.y = exitBtn.y;
			soundBtn.addEventListener(Event.TRIGGERED, onSoundClick);
			this.addChild(soundBtn);
			
			/* back button */
			backBtn = new Button(GameAssets.getAtlasFix().getTexture("btn_home"));
			backBtn.x = (stage.stageWidth/14);
			backBtn.y = stage.stageHeight - (stage.stageHeight/14) - backBtn.height;
			backBtn.addEventListener(Event.TRIGGERED, onAboutBackClick);
			this.addChild(backBtn);
			
			/* help button */
			helpBtn = new Button(GameAssets.getAtlasFix().getTexture("btn_info"));
			helpBtn.x = exitBtn.x - exitBtn.width;
			helpBtn.y = stage.stageHeight - (stage.stageHeight/14) - helpBtn.height;
			helpBtn.addEventListener(Event.TRIGGERED, onHelpClick);
			this.addChild(helpBtn);
			
			
			/* about button */
			aboutBtn = new Button(GameAssets.getAtlasFix().getTexture("btn_credits"));
			aboutBtn.x = helpBtn.x-(stage.stageHeight/20)-aboutBtn.height;
			aboutBtn.y = helpBtn.y;
			aboutBtn.addEventListener(Event.TRIGGERED, onAboutClick);
			this.addChild(aboutBtn);
			
			/* items button */
			itemsBtn = new Button(GameAssets.getAtlasFix().getTexture("btn_item"));
			itemsBtn.x = aboutBtn.x-(stage.stageHeight/20)-itemsBtn.height;
			itemsBtn.y = helpBtn.y;
			itemsBtn.addEventListener(Event.TRIGGERED, onItemsClick);
			this.addChild(itemsBtn);
			
			/* quiz button */
			quizBtn = new Button(GameAssets.getAtlasFix().getTexture("btn_quiz"));
			quizBtn.x = itemsBtn.x-(stage.stageHeight/20)-quizBtn.height;
			quizBtn.y = helpBtn.y;
			quizBtn.addEventListener(Event.TRIGGERED, onQuizClick);
			this.addChild(quizBtn);
			
			/* quiz button */
			var yPosition:Number = backBtn.y - stage.stageHeight/14;
	
			nextButton = new Button(GameAssets.getAtlasFix().getTexture("btn_selanjutnya"));
            nextButton.x = stage.stageWidth/2 - nextButton.width/2;
            nextButton.y = yPosition - nextButton.height;
            nextButton.addEventListener(Event.TRIGGERED, nextHandler);
            this.addChild(nextButton);
			
			
			prevButton = new Button(GameAssets.getAtlasFix().getTexture("btn_sebelumnya"));
			prevButton.x = nextButton.x - nextButton.width - 50;
			prevButton.y = yPosition- prevButton.height;
			prevButton.addEventListener(Event.TRIGGERED, prevHandler);
			this.addChild(prevButton);

            finishButton = new Button(GameAssets.getAtlasFix().getTexture("btn_selesai"));
			finishButton.x = nextButton.x + nextButton.width + 50;
            finishButton.y = yPosition- finishButton.height;
            finishButton.addEventListener(Event.TRIGGERED, finishHandler);
            this.addChild(finishButton);
			
			//statusT = new TextField(480, 600, "", fontRegular.fontName, fontRegular.fontSize, 0xffffff);
			statusT = new TextField(480, 50, "", "Consolas", 14, 0xffffff);
			statusT.x = stage.stageWidth/2 - statusT.width/2;
			statusT.y = finishButton.y - statusT.height*2;
			statusT.hAlign = HAlign.CENTER;
			statusT.vAlign = VAlign.TOP;
			//statusT.border = true;
			this.addChild(statusT);
			
			quizQuestions = new Array();
            createQuestions();
			/* end quiz button */
			
		}
		
		private function onPlayClick(event:Event):void
		{
			this.dispatchEvent(new NavigationEvent(NavigationEvent.SWITCH_STATE, {id: "level"},true));
		}
		
		private function onItemsClick(event:Event):void
		{
			this.dispatchEvent(new NavigationEvent(NavigationEvent.SWITCH_STATE, {id: "items"},true));
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
		
		private function onHelpClick(event:Event):void
		{
			showMessage("");
			//showInfo();
		}
		
		private function onSoundClick(event:Event):void
		{
			showMessage("");
		}
		
		private function onExitClick(event:Event):void
		{
			showMessage("");
			NativeApplication.nativeApplication.exit(); 
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
			helpBtn.visible = false;
			aboutText.visible = true;
			backBtn.visible = true;
			quizBtn.visible = false;
			itemsBtn.visible = false;
		}
		
		public function showQuiz():void
		{
			screenMode = "quiz";
			hero.visible = false;
			title.visible = false;
			playBtn.visible = false;
			helpBtn.visible = false;
			backBtn.visible = true;
			aboutBtn.visible = false;
            prevButton.visible = true;
			nextButton.visible =true;
			finishButton.visible = true;
			quizBtn.visible = false;
			itemsBtn.visible = false;
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
			helpBtn.visible = true;
			prevButton.visible = false;
			nextButton.visible =false;
			finishButton.visible = false;
			itemsBtn.visible = true;
			
			hideAllQuestions();
			
			//animation
			hero.x = -hero.width;
			hero.y = 100;
			
			tweenHero = new Tween(hero, 2, Transitions.EASE_OUT);
			tweenHero.animate("x", 80);
			Starling.juggler.add(tweenHero);
			Starling.juggler.removeTweens(tweenHero);
			
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
			playBtn.y = (stage.stageHeight/2 - playBtn.height/2) + (Math.cos(_currentDate.getTime() * 0.002)) * 10;
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
			score = 0;
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
            statusT.x = stage.stageWidth/2 - statusT.width/2;
        }
		
        private function addAllQuestions() {
            for(var i:int = 0; i < quizQuestions.length; i++) {
				quizQuestions[i].x = stage.stageWidth/2 - quizQuestions[i].width/2;
				quizQuestions[i].y = stage.stageHeight/14+stage.stageHeight/20;
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