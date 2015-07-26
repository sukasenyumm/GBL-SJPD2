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
	import framework.events.NavigationEvent;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.utils.rad2deg;


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
		/** Lives Count. */		
		private var lives:int;
		private var scoreLife:TextField;
		
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
		private var questionTemporary:Number;
		/** GameOver Container. */
		private var gameOverScreen:GameOverScreen;
		/** Tween object for game over container. */
		private var tween_gameOverContainer:Tween;
		
		public function GamePlay() {
			// constructor code
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			drawGame();
			drawGameOverScreen();
			
			
		}

		private function drawGame():void
		{
			bg = new GameBackground();
			bg.speed = 50;
			this.addChild(bg);
			
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
			
			hero = new Hero();
			hero.x = stage.stageWidth/2;
			hero.y = stage.stageHeight/2;
			this.addChild(hero);
			
			obstacleToAnimate = new Vector.<Obstacle>();
			itemsToAnimate = new Vector.<Item>();
			
			// Define lives. 5 nyawa broh,..
			lives = 5;
			scoreLife = new TextField(300,100, "Score Life: initialize","chiller", 14, 0xffffff);
			scoreLife.hAlign = HAlign.LEFT;
			scoreLife.vAlign = VAlign.TOP;
			scoreLife.x = stage.stageWidth*0.5;
			scoreLife.y = 20;
			scoreLife.border = true;
			this.addChild(scoreLife);
			
			startButton = new Button(GameAssets.getAtlas().getTexture("startButton"));
			startButton.x = stage.stageWidth/2-startButton.width/2;
			startButton.y = stage.stageHeight/2-startButton.height/2;
			startButton.addEventListener(Event.TRIGGERED, onStartButtonClick);
			this.addChild(startButton);
		}
		
		private function disposeTemporarily():void
		{
			gameOverScreen.visible = false;
			
			if (this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME, calculateElapsed);
			
			if (this.hasEventListener(TouchEvent.TOUCH)) this.removeEventListener(TouchEvent.TOUCH, onTouch);
			
			if (this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME, onGameTick);
			 
		}
		
		public function initialize():void
		{
			// Dispose screen temporarily.
			disposeTemporarily();
			
			this.visible = true;
			
			// Calculate elapsed time.
			this.addEventListener(Event.ENTER_FRAME, calculateElapsed);
			gameArea = new Rectangle(0,100,stage.stageWidth,stage.stage.stageHeight - 250);
			
			gameState = "idle";
			
			playerSpeed = 0;
			hitObstacle = 0;
			bg.speed = 0;
			scoreDistance = 0;
			obstacleGapCount = 0;
			// Reset background's state to idle.
			bg.state = 1;//"idle";
			// Reset hero's state to idle.
			hero.state = 1;//"idle";
			hero.x = -stage.stageWidth;
			hero.y = stage.stageHeight * 0.5;
			
			lives = 5;
			scoreLife.text = "Score Life: "+String(lives);
			
			//bg.visible = false;
			startButton.visible = true;
			//force startButton always in top of layers.
			this.setChildIndex(startButton, numChildren-1);
			
		}
		
		private function onStartButtonClick(event:Event):void
		{
			trace("hiks")
			// Hide start button.
			startButton.visible = false;
			
			// Launch hero.
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
							hero.state = 2;
						}
						
						trace(hero.rotation)
						// Limit the hero's rotation to < 30.
						hero.rotation = deg2rad(0);
						
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
						
						if(lives <= 0)
							gameState = "over";
						break;
					case "over":
						
						for(var i:uint = 0; i < itemsToAnimate.length; i++)
						{
							if (itemsToAnimate[i] != null)
							{
								// Dispose the item temporarily.
								disposeItemTemporarily(i, itemsToAnimate[i]);
							}
						}
						
						for(var j:uint = 0; j < obstacleToAnimate.length; j++)
						{
							if (obstacleToAnimate[j] != null)
							{
								// Dispose the obstacle temporarily.
								disposeObstacleTemporarily(j, obstacleToAnimate[j]);
							}
						}
						
						// Spin the hero.
						hero.rotation -= deg2rad(30);
						
						// Make the hero fall.
						
						// If hero is still on screen, push him down and outside the screen. Also decrease his speed.
						// Checked for +width below because width is > height. Just a safe value.
						if (hero.y < stage.stageHeight + hero.width)
						{
							playerSpeed -= playerSpeed * elapsed;
							hero.y += stage.stageHeight * elapsed; 
						}
						else
						{
							// Once he moves out, reset speed to 0.
							playerSpeed = 0;
							
							// Stop game tick.
							this.removeEventListener(Event.ENTER_FRAME, onGameTick);
							
							// Game over.
							gameOver();
						}
						
						// Set the background's speed based on hero's speed.
						bg.speed = Math.floor(playerSpeed * elapsed);
					break;
				}
			}
		}
		
		private function disposeItemTemporarily(animateId:uint, item:Item):void
		{
			itemsToAnimate.splice(animateId, 1);
			//itemsToAnimate.length--;
			
			item.x = stage.stageWidth + item.width * 2;
			this.removeChild(item);
		}
		
		private function disposeObstacleTemporarily(animateId:uint, obstacle:Obstacle):void
		{
			obstacleToAnimate.splice(animateId, 1);
			this.removeChild(obstacle);
			//obstacleToAnimate.length--;
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
				
				if(itemToTrack.x < -50 || gameState == "over")
				{
					//itemsToAnimate.splice(i,1);
					//this.removeChild(itemToTrack);
					disposeItemTemporarily(i, itemToTrack);
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
					
					// Update lives.
					lives--;
					
					if (lives <= 0)
					{
						lives = 0;
						endGame();
					}
					
					scoreLife.text = "Score Life: "+String(lives);
					
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
					disposeObstacleTemporarily(i,obstacleToTrack);
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
			//statusT = new TextField(480, 600, "", fontRegular.fontName, fontRegular.fontSize, 0xffffff);
			//disi chiller dulu
			statusT = new TextField(480, 600, "", "chiller", 18, 0xffffff);
			statusT.x = 0;
			statusT.y = 100;
			statusT.hAlign = HAlign.CENTER;
			statusT.vAlign = VAlign.TOP;
			this.addChild(statusT);
			
			/* quiz button */
			 var yPosition:Number = 300;

            finishButton = new Button(GameAssets.getAtlas().getTexture("welcome_playButton"));
            finishButton.x = 30;
            finishButton.y = yPosition;
            finishButton.addEventListener(Event.TRIGGERED, finishHandler);
            this.addChild(finishButton);
			
			nextButton = new Button(GameAssets.getAtlas().getTexture("welcome_playButton"));
            nextButton.x = 30;
            nextButton.y = yPosition;
            nextButton.addEventListener(Event.TRIGGERED, nextHandler);
            this.addChild(nextButton);
			nextButton.visible = false;
			
			quizQuestions = new Array();
            createQuestions();
			
			var questionTemp:Number = Math.ceil(Math.random() * ((quizQuestions.length - 1) - 0)+0);
			addQuestions(questionTemp);
			questionTemporary = questionTemp;
        
			
		}
		
		private function createQuestions() {
            quizQuestions.push(new QuizQuestion("Dummy",
                                                            0,
                                                            "Dummy",
                                                            "Dummy",
                                                            "Dummy",
                                                            "Dummy"));
            quizQuestions.push(new QuizQuestion("Didaerah mana pertama kali tentara jepang menduduki Indonesia?",
                                                            2,
                                                            "Semarang",
                                                            "Solo",
                                                            "Tarakan",
                                                            "Makasar"));
            quizQuestions.push(new QuizQuestion("Pemerintah Hindia Belanda menyerah tanpa syarat kepada Jepang?",
                                                            1,
                                                            "8 Januari 1942",
                                                            "8 Maret 1942",
                                                            "17 Agustus 1945",
                                                            "8 Januari 1945",
                                                            "8 Maret 1945"));
            quizQuestions.push(new QuizQuestion("Untuk memikat hari rakyat, Jepang membuat propaganda Tiga A, yang berisi?",
                                                            3,
                                                            "Jepang pemimpin Asia",
                                                            "Jepang pelindung Asia",
                                                            "epang cahaya Asia",
                                                            "Semua jawaban benar"));
        }
		
		 private function showMessage(theMessage:String) {
            statusT.text = theMessage;
            statusT.x = 200;
        }
        private function addQuestions(numQuestion:Number) {
            /*
			for(var i:int = 0; i < quizQuestions.length; i++) {
                this.addChild(quizQuestions[i]);
            }*/
			trace("error num: "+numQuestion)
			this.addChild(quizQuestions[numQuestion]);
        }
        private function removeQuestions(numQuestion:Number) {
           	quizQuestions[numQuestion].visible = false;
        }
   
        private function finishHandler(event:Event) {
            showMessage("");
			var questionTemp:Number = Math.ceil(Math.random() * ((quizQuestions.length - 1) - 0)+0);
                
            if(quizQuestions[questionTemporary].userAnswer == quizQuestions[questionTemporary].correctAnswer) {
                    lives+=3;
					removeQuestions(questionTemporary);	
					hideQuestion(questionTemporary);
					showMessage("Jawaban benar "+quizQuestions[questionTemporary].correctAnswer);
					scoreLife.text = "Score Life: "+String(lives);
            } else {
				lives-=1;
				removeQuestions(questionTemporary);	
				hideQuestion(questionTemporary);
				showMessage("Jawaban Salah "+quizQuestions[questionTemporary].userAnswer);
				scoreLife.text = "Score Life: "+String(lives);
            }
			
			nextButton.visible = true;
        }
		
		private function nextHandler(event:Event) {
			gamePaused = false;
			nextButton.visible = false;
			showMessage("");
		}
		
		private function hideQuestion(numQuestion:Number):void
		{
			showMessage("");
			this.removeQuestions(numQuestion);
			finishButton.visible = false;
		}
		
		//end quiz
		
		/**
		 * End game. 
		 * 
		 */
		private function endGame():void
		{
			this.x = 0;
			this.y = 0;
			
			// Set Game Over state so all obstacles and items can remove themselves.
			gameState = "over";
		}
		
		/**
		 * Draw game over screen. 
		 * 
		 */
		private function drawGameOverScreen():void
		{
			gameOverScreen = new GameOverScreen();
			gameOverScreen.addEventListener(NavigationEvent.SWITCH_STATE, playAgain);
			this.addChild(gameOverScreen);
		}
		
		/**
		 * Play again, when clicked on play again button in Game Over screen. 
		 * 
		 */
		private function playAgain(event:NavigationEvent):void
		{
			if (event.params.id == "playAgain") 
			{
				trace("playagain");
				tween_gameOverContainer = new Tween(gameOverScreen, 1);
				tween_gameOverContainer.fadeTo(0);
				tween_gameOverContainer.onComplete = gameOverFadedOut;
				Starling.juggler.add(tween_gameOverContainer);
			}
		}
		
		/**
		 * On game over screen faded out. 
		 * 
		 */
		private function gameOverFadedOut():void
		{
			trace("alalay");
			gameOverScreen.visible = false;
			initialize();
		}
		
		/**
		 * Game Over - called when hero falls out of screen and when Game Over data should be displayed. 
		 * 
		 */
		private function gameOver():void
		{
			this.setChildIndex(gameOverScreen, this.numChildren-1);
			gameOverScreen.initialize(score, Math.round(scoreDistance));
			
			tween_gameOverContainer = new Tween(gameOverScreen, 1);
			tween_gameOverContainer.fadeTo(1);
			Starling.juggler.add(tween_gameOverContainer);
		}
	}
	
}
