package framework.screenstates{
	import framework.gameobject.Hero;
	import starling.events.Event;
	import starling.display.Sprite;
	import framework.gameobject.GameBackground;
	import flash.utils.getTimer;
	import starling.display.Button;
	import framework.utils.GameAssets;
	import framework.gameobject.Obstacle;
	import flash.geom.Rectangle;
	import starling.events.TouchEvent;
	import starling.events.Touch;
	import starling.utils.deg2rad;
	import framework.gameobject.Item;
	import framework.quiz.QuizQuestion;
	import starling.text.TextField;
	import framework.customobjects.Font;
	import framework.utils.Fonts;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	
	
	public class GamePlay extends Sprite{

		private var startButton:Button;
		private var bg:GameBackground;
		private var hero:Hero;
		
		/** Time calculation for animation. */
		private var timePrevious:Number;
		private var timeCurrent:Number;
		private var elapsed:Number;
		
		private var gameState:String;
		private var playerSpeed:Number;
		private var hitObstacle:Number = 0;
		
		private const MIN_SPEED:Number = 650;
		private var scoreDistance:int;
		private var obstacleGapCount:int;
		
		private var gameArea:Rectangle;
		
		private var obstacleToAnimate:Vector.<Obstacle>;
		
		private var touch:Touch;
		private var touchX:Number;
		private var touchY:Number;
		
		private var itemsToAnimate:Vector.<Item>;
		private var scoreText:TextField;
		
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
		/** Font - Regular text. */
		private var fontRegular:Font;
		/** Is game currently in paused state? */
		private var gamePaused:Boolean = false;
		
		public function GamePlay() {
			// constructor code
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			drawGame();
			
			fontRegular = Fonts.getFont("Regular");
			
			//sementara pakai chiller, karena font regulernya masih ada karakter yang ilang
			//sementara juga masih pakai box
			scoreText = new TextField(300,100, "Score: 0","chiller", 14, 0xffffff);
			scoreText.hAlign = HAlign.LEFT;
			scoreText.vAlign = VAlign.TOP;
			scoreText.x = 20;
			scoreText.y = 20;
			scoreText.border = true;
			this.addChild(scoreText);
		}

		private function drawGame():void
		{
			bg = new GameBackground();
			bg.speed = 50;
			this.addChild(bg);
			
			hero = new Hero();
			hero.x = stage.stageWidth/2;
			hero.y = stage.stageHeight/2;
			this.addChild(hero);
			
			startButton = new Button(GameAssets.getAtlas().getTexture("startButton"));
			startButton.x = stage.stageWidth/2-startButton.width/2;
			startButton.y = stage.stageHeight/2-startButton.height/2;
			this.addChild(startButton);
			
			gameArea = new Rectangle(0,100,stage.stageWidth,stage.stage.stageHeight - 250);
			
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
		}
		
		public function initialize():void
		{
			this.visible = true;
			// Calculate elapsed time.
			this.addEventListener(Event.ENTER_FRAME, calculateElapsed);
			hero.x = -stage.stageWidth;
			hero.y = -stage.stageHeight * 0.5;
			
			
			gameState = "idle";
			
			playerSpeed = 0;
			hitObstacle = 0;
			bg.speed = 0;
			scoreDistance = 0;
			obstacleGapCount = 0;
			
			obstacleToAnimate = new Vector.<Obstacle>();
			itemsToAnimate = new Vector.<Item>();
			
			startButton.addEventListener(Event.TRIGGERED, onStartButtonClick);
			
		}
		
		private function onStartButtonClick(event:Event):void
		{
			startButton.visible = false;
			startButton.removeEventListener(Event.TRIGGERED, onStartButtonClick);
			
			launchHero();
		}
		
		private function launchHero():void
		{
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(Event.ENTER_FRAME, onGameTick);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			touch = event.getTouch(stage);
			
			touchX = touch.globalX;
			touchY = touch.globalY;
		}
		
		private function onGameTick(event:Event):void
		{
			if (!gamePaused)
			{
				switch(gameState)
				{
					case "idle":
						//take off
						if(hero.x < stage.stageWidth * 0.5 * 0.5)
						{
							hero.x += ((stage.stageWidth * 0.5 * 0.5 + 10)-hero.x)*0.05;
							hero.y = stage.stageHeight * 0.5;
							
							playerSpeed += (MIN_SPEED - playerSpeed)* 0.05;
							bg.speed = playerSpeed * elapsed;
						}
						else
						{
							gameState = "flying";
						}
						break;
					case "flying":
					
						if(hitObstacle <= 0)
						{
							hero.y -= (hero.y - touchY) * 0.1;
							
							if(-(hero.y - touchY)<150 && -(hero.y - touchY)>-150)
							{
								hero.rotation = deg2rad(-(hero.y -touchY) * 0.2);
							}
							if(hero.y > gameArea.bottom - hero.height * 0.5)
							{
								hero.y = gameArea.bottom - hero.height * 0.5;
								hero.rotation = deg2rad(0);
							}
							if(hero.y < gameArea.top + hero.height * 0.5)
							{
								hero.y = gameArea.top + hero.height * 0.5;
								hero.rotation = deg2rad(0);
							}
	
						}
						else
						{
							hitObstacle--;
							cameraShake();
						}
						 
						playerSpeed -= (playerSpeed - MIN_SPEED) * 0.01;
						bg.speed = playerSpeed * elapsed;
						scoreDistance += (playerSpeed * elapsed)*0.1;
						
						scoreText.text = "Score: "+scoreDistance;
						
						initObstacle();
						animateObstacles();
						
						createFoodItems();
						animateItems();
						break;
					case "over":
					break;
				}
			}
		}
		
		private function animateItems():void
		{
			var itemToTrack:Item;
			
			for(var i:uint = 0;i<itemsToAnimate.length;i++)
			{
				itemToTrack = itemsToAnimate[i];
				
				itemToTrack.x -= playerSpeed * elapsed;
				if(itemToTrack.bounds.intersects(hero.bounds))
				{
					itemsToAnimate.splice(i,1);
					this.removeChild(itemToTrack);
					if(itemToTrack.foodItemType == 1)
					{
						gameState = "idle";
						initQuiz();
						gamePaused = true;
					}
				}
				
				/*if(itemToTrack.bounds.intersects(hero.bounds)&& itemToTrack.foodItemType == 1)
				{
					itemsToAnimate.splice(i,1);
					this.removeChild(itemToTrack);
				} */
				
				
				if(itemToTrack.x < -50)
				{
					itemsToAnimate.splice(i,1);
					this.removeChild(itemToTrack);
				}
			}
		}
		
		private function createFoodItems():void
		{
			if(Math.random() > 0.95)
			{
				var itemToTrack:Item = new Item(Math.ceil(Math.random() * 5));
				itemToTrack.x = stage.stageWidth + 50;
				itemToTrack.y = int(Math.random() * (gameArea.bottom - gameArea.top)) + gameArea.top;
				this.addChild(itemToTrack);
				
				itemsToAnimate.push(itemToTrack);
			}
		}
		
		private function cameraShake():void
		{
			if(hitObstacle > 0)
			{
				this.x = Math.random() * hitObstacle;
				this.y = Math.random() * hitObstacle;
			}
			else if(x != 0)
			{
				this.x = 0;
				this.y = 0;
			}
		}
		private function animateObstacles():void
		{
			var obstacleToTrack:Obstacle;
			for(var i:uint = 0;i<obstacleToAnimate.length;i++)
			{
				obstacleToTrack = obstacleToAnimate[i];
				
				if(obstacleToTrack.alreadyHit == false &&
				   obstacleToTrack.bounds.intersects(hero.bounds))
				{
					obstacleToTrack.alreadyHit = true;
					obstacleToTrack.rotation = deg2rad(70);
					hitObstacle = 30;
					playerSpeed *= 0.5;
				}
				if(obstacleToTrack.distance > 0)
				{
					obstacleToTrack.distance -= playerSpeed * elapsed;
				}
				else
				{
					if(obstacleToTrack.watchOut)
					{
						obstacleToTrack.watchOut = false;
					} 
					obstacleToTrack.x -= (playerSpeed + obstacleToTrack.speed) * elapsed;
				}
				
				if(obstacleToTrack.x < -obstacleToTrack.width || gameState == "over")
				{
					obstacleToAnimate.splice(i,1);
					this.removeChild(obstacleToTrack);
				}
			}
		}
		private function initObstacle():void
		{
			if(obstacleGapCount < 1200)
			{
				obstacleGapCount += playerSpeed * elapsed;
			}
			else if(obstacleGapCount != 0)
			{
				obstacleGapCount = 0;
				createObstacle(Math.ceil(Math.random() * 4),Math.random()*1000 + 1000);
			}
		}
		
		private function createObstacle(type:Number, distance:Number):void
		{
			var obstacle:Obstacle = new Obstacle(type,distance,true,300);
			obstacle.x = stage.stageWidth;
			this.addChild(obstacle);
			
			if(type <= 3)
			{
				if(Math.random() > 0.5)
				{
					obstacle.y = gameArea.top;
					obstacle.position = "top";
				}
				else
				{
					obstacle.y = gameArea.bottom - obstacle.height;
					obstacle.position = "bottom";
				}
			}
			else
			{
				obstacle.y = int(Math.random()*(gameArea.bottom - obstacle.height - gameArea.top))+gameArea.top;
				obstacle.position = "middle";
			}
			obstacleToAnimate.push(obstacle);
			
		}
		/**
		 * Calculate elapsed time. 
		 * @param event
		 * 
		 */
		private function calculateElapsed(event:Event):void
		{
			// Set the current time as the previous time.
			timePrevious = timeCurrent;
			
			// Get teh new current time.
			timeCurrent = getTimer(); 
			
			// Calcualte the time it takes for a frame to pass, in milliseconds.
			elapsed = (timeCurrent - timePrevious) * 0.001; 
		}
		
		private function initQuiz():void
		{
			statusT = new TextField(480, 600, "", fontRegular.fontName, fontRegular.fontSize, 0xffffff);
			statusT.x = 0;
			statusT.y = 100;
			statusT.hAlign = HAlign.CENTER;
			statusT.vAlign = VAlign.TOP;
			this.addChild(statusT);
			
			/* quiz button */
			 var yPosition:Number = 300;
	
			prevButton = new Button(GameAssets.getAtlas().getTexture("welcome_playButton"));
			prevButton.x = 30;
			prevButton.y = yPosition;
			//prevButton.addEventListener(Event.TRIGGERED, prevHandler);
			this.addChild(prevButton);
			

            nextButton = new Button(GameAssets.getAtlas().getTexture("welcome_playButton"));
            nextButton.x = prevButton.x + prevButton.width + 40;
            nextButton.y = yPosition;
            //nextButton.addEventListener(Event.TRIGGERED, nextHandler);
            this.addChild(nextButton);

            finishButton = new Button(GameAssets.getAtlas().getTexture("welcome_playButton"));
            finishButton.x = nextButton.x + nextButton.width + 40;
            finishButton.y = yPosition;
            finishButton.addEventListener(Event.TRIGGERED, finishHandler);
            this.addChild(finishButton);
			
			quizQuestions = new Array();
            createQuestions();
			
			addAllQuestions();
            hideAllQuestions();
            firstQuestion();
			
			
		}
		
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
			
			gamePaused = false;
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
		
	}
	
}
