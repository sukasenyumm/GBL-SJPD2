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
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import framework.events.NavigationEvent;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.utils.rad2deg;
	import starling.display.Quad;
	import framework.utils.SaveManager;
	import framework.gameobject.Enemy;
	import feathers.controls.Label;
	import feathers.controls.Callout;
	import starling.display.Image;
	import framework.utils.SaveManager;
	import framework.gameobject.Particle;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	import framework.utils.ParticleAssets;


	public class GamePlay extends Sprite{

		private var startButton:Button;
		private var bg:GameBackground;
		private var hero:Hero;
		private var enemy:Enemy;
		
		/** Time calculation for animation. */
		private var timePrevious:Number;
		private var timeCurrent:Number;
		private var elapsed:Number;
		
		private var gameState:String;
		private var playerSpeed:Number;
		private var enemySpeed:Number;
		private var hitObstacle:Number = 0;
		
		private const MIN_SPEED:Number = 650;
		private var obstacleGapCount:int;
		
		private var gameArea:Rectangle;
		
		private var obstacleToAnimate:Vector.<Obstacle>;
		
		private var touch:Touch;
		private var touchX:Number;
		private var touchY:Number;
		
		private var itemsToAnimate:Vector.<Item>;
		private var eatParticlesToAnimate:Vector.<Particle>;
		
		private var particle:PDParticleSystem;
		
		private var scoreDistance:int;
		private var scoreItem:int;
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
		/** Is game currently in paused state? */
		private var gamePaused:Boolean = false;
		private var questionTemporary:Number;
		/** GameOver Container. */
		private var gameOverScreen:GameOverScreen;
		/** Tween object for game over container. */
		private var tween_gameOverContainer:Tween;
		private var level:int;
		
		private var labelIntro:TextField;
		private var labelLose:TextField;
		private var labelTips:TextField;
		
		/*ITEM INFO*/
		private var quizBg:Quad;
		private var itemInfo11:Image;
		private var itemInfo12:Image;
		private var itemInfo13:Image;
		private var itemInfo21:Image;
		private var itemInfo22:Image;
		private var itemInfo23:Image;
		private var itemInfo24:Image;
		private var itemInfo31:Image;
		private var itemInfo32:Image;
		private var itemInfo33:Image;
		
		
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
			
			scoreText = new TextField(300,100, "Score: 0","nulshock", 14, 0xffffff);
			scoreText.hAlign = HAlign.LEFT;
			scoreText.vAlign = VAlign.TOP;
			scoreText.x = (stage.stageWidth/14);
			scoreText.y = (stage.stageHeight/14);
			this.addChild(scoreText);
			
			particle = new PDParticleSystem(XML(new ParticleAssets.ParticleXML()),Texture.fromBitmap(new ParticleAssets.ParticleTexture()));
			Starling.juggler.add(particle);
			particle.x = -100;
			particle.y = -100;
			particle.scaleX = 1.2;
			particle.scaleY = 1.2;
			this.addChild(particle);
			
			hero = new Hero();
			hero.x = stage.stageWidth/2;
			hero.y = stage.stageHeight/2;
			this.addChild(hero);
			
			enemy = new Enemy();
			enemy.x = stage.stageWidth/2;
			enemy.y = stage.stageHeight/2;
			this.addChild(enemy);
			
			obstacleToAnimate = new Vector.<Obstacle>();
			itemsToAnimate = new Vector.<Item>();
			eatParticlesToAnimate = new Vector.<Particle>();
			
			// Define lives. 5 nyawa broh,..
			lives = 5;
			scoreLife = new TextField(140,100, "Energi: -","nulshock", 14, 0xffffff);
			scoreLife.hAlign = HAlign.RIGHT;
			scoreLife.vAlign = VAlign.TOP;
			scoreLife.x = stage.stageWidth - scoreLife.width - (stage.stageWidth/14);
			scoreLife.y = (stage.stageHeight/14);
			this.addChild(scoreLife);
			
			
			labelTips = new TextField(stage.stageWidth,stage.stageHeight/2+stage.stageHeight/14, "","nulshock", 14, 0xffffff);
			labelTips.hAlign = HAlign.CENTER;
			labelTips.vAlign = VAlign.TOP;
			labelTips.x = stage.stageWidth/2-labelTips.width/2;
			labelTips.y = stage.stageHeight/2-labelTips.height/2;
			this.addChild(labelTips);
			
			startButton = new Button(GameAssets.getAtlasFix().getTexture("btn_mulai"));
			startButton.x = stage.stageWidth/2-startButton.width/2;
			startButton.y = labelTips.height+10;
			startButton.addEventListener(Event.TRIGGERED, onStartButtonClick);
			this.addChild(startButton);
			
			
			/*item info
			*/
			itemInfo11 = new Image(GameAssets.getAtlasFix().getTexture("P1-1"));
			itemInfo11.x = stage.stageWidth/2-itemInfo11.width/2;
			itemInfo11.y = stage.stageHeight/2-itemInfo11.height/2;
			this.addChild(itemInfo11);
			itemInfo12 = new Image(GameAssets.getAtlasFix().getTexture("P1-2"));
			itemInfo12.x = stage.stageWidth/2-itemInfo12.width/2;
			itemInfo12.y = stage.stageHeight/2-itemInfo12.height/2;
			this.addChild(itemInfo12);
			itemInfo13 = new Image(GameAssets.getAtlasFix().getTexture("P1-3"));
			itemInfo13.x = stage.stageWidth/2-itemInfo13.width/2;
			itemInfo13.y = stage.stageHeight/2-itemInfo13.height/2;
			this.addChild(itemInfo13);
			
			itemInfo21 = new Image(GameAssets.getAtlasFix().getTexture("P2-1"));
			itemInfo21.x = stage.stageWidth/2-itemInfo21.width/2;
			itemInfo21.y = stage.stageHeight/2-itemInfo21.height/2;
			this.addChild(itemInfo21);
			itemInfo22 = new Image(GameAssets.getAtlasFix().getTexture("P2-2"));
			itemInfo22.x = stage.stageWidth/2-itemInfo22.width/2;
			itemInfo22.y = stage.stageHeight/2-itemInfo22.height/2;
			this.addChild(itemInfo22);
			itemInfo23 = new Image(GameAssets.getAtlasFix().getTexture("P2-3"));
			itemInfo23.x = stage.stageWidth/2-itemInfo23.width/2;
			itemInfo23.y = stage.stageHeight/2-itemInfo23.height/2;
			this.addChild(itemInfo23);
			itemInfo24 = new Image(GameAssets.getAtlasFix().getTexture("P2-4"));
			itemInfo24.x = stage.stageWidth/2-itemInfo24.width/2;
			itemInfo24.y = stage.stageHeight/2-itemInfo24.height/2;
			this.addChild(itemInfo24);
			
			itemInfo31 = new Image(GameAssets.getAtlasFix().getTexture("P3-1"));
			itemInfo31.x = stage.stageWidth/2-itemInfo31.width/2;
			itemInfo31.y = stage.stageHeight/2-itemInfo31.height/2;
			this.addChild(itemInfo31);
			itemInfo32 = new Image(GameAssets.getAtlasFix().getTexture("P3-2"));
			itemInfo32.x = stage.stageWidth/2-itemInfo32.width/2;
			itemInfo32.y = stage.stageHeight/2-itemInfo32.height/2;
			this.addChild(itemInfo32);
			itemInfo33 = new Image(GameAssets.getAtlasFix().getTexture("P3-3"));
			itemInfo33.x = stage.stageWidth/2-itemInfo33.width/2;
			itemInfo33.y = stage.stageHeight/2-itemInfo33.height/2;
			this.addChild(itemInfo33);
						
			//end
			//quiz
			
			/* quiz button */
			
			quizBg = new Quad(stage.stageWidth, stage.stageHeight - (stage.stageHeight/14)*2, 0xFFFFFF);
			quizBg.y = stage.stageHeight/2-quizBg.height/2;
			quizBg.alpha = 0.5;
			this.addChild(quizBg);
			
			var yPosition:Number = stage.stageHeight - stage.stageHeight/10;

            finishButton = new Button(GameAssets.getAtlasFix().getTexture("btn_jawab"));
            finishButton.x =  stage.stageWidth/2 - finishButton.width/2;
            finishButton.y = yPosition- finishButton.height*2;
            finishButton.addEventListener(Event.TRIGGERED, finishHandler);
            this.addChild(finishButton);
			finishButton.visible = false;
			
			nextButton = new Button(GameAssets.getAtlasFix().getTexture("btn_lanjutkan"));
            nextButton.x = stage.stageWidth/2 - nextButton.width/2;
            nextButton.y = yPosition - nextButton.height*2;
            nextButton.addEventListener(Event.TRIGGERED, nextHandler);
            this.addChild(nextButton);
			nextButton.visible = false;
			
			statusT = new TextField(stage.stageWidth, 50, "", "nulshock", 14, 0xffffff);
			statusT.x = stage.stageWidth/2 - statusT.width/2;
			statusT.y = itemInfo11.y - statusT.height;
			statusT.hAlign = HAlign.CENTER;
			statusT.vAlign = VAlign.TOP;
			//statusT.border = true;
			this.addChild(statusT);
			
			//quizQuestions = new Array();
            //questionLevels();
			
			//var questionTemp:Number = Math.ceil(Math.random() * ((quizQuestions.length - 1) - 0)+0);
			//addQuestions(questionTemp);
			//questionTemporary = questionTemp;
			
			//end quiz
			
			
			labelIntro = new TextField(stage.stageWidth/2, 50, "", "nulshock", 10, 0xffffff);
			this.addChild(labelIntro);
			labelIntro.visible = false;
			//dialog
			labelLose = new TextField(stage.stageWidth/2, 50, "", "nulshock", 10, 0xffffff);
			this.addChild(labelLose);
			labelLose.visible = false;
			//end dialog
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
			gameOverScreen.visible = false;
			
			if (this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME, calculateElapsed);
			
			if (this.hasEventListener(TouchEvent.TOUCH)) this.removeEventListener(TouchEvent.TOUCH, onTouch);
			
			if (this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME, onGameTick);
			 
		}
		
		public function initialize(nLevel:int):void
		{
			// Dispose screen temporarily.
			disposeTemporarily();
			
			this.visible = true;
			
			// Calculate elapsed time.
			this.addEventListener(Event.ENTER_FRAME, calculateElapsed);
			gameArea = new Rectangle(0,(stage.stageHeight/14)*2,stage.stageWidth,stage.stageHeight - (stage.stageHeight/14)*2);
			trace((stage.stageHeight/14)*2);
			
			gameState = "idle";
			
			level = nLevel;
			playerSpeed = 0;
			enemySpeed = 0;
			hitObstacle = 0;
			bg.speed = 0;
			scoreDistance = 0;
			scoreItem = 0;
			obstacleGapCount = 0;
			// Reset background's state to idle.
			bg.state = 1;//"idle";
			// Reset hero's state to idle.
			hero.state = 1;//"idle";
			hero.x = -stage.stageWidth;
			hero.y = stage.stageHeight * 0.5;
			
			enemy.state = 1;//"idle";
			enemy.x = -stage.stageWidth;
			enemy.y = stage.stageHeight * 0.5 + 100;
			
			scoreText.text = "Score: "+scoreDistance;
			lives = 5;
			scoreLife.text = "Energi: "+String(lives);
			
			//bg.visible = false;
			labelTips.text = (SaveManager.getInstance().loadDataGodlike()==1)?"Cara Main\n\nGerakkan tangganmu keatas dan kebawah.\nAmbil batu pengetahuan yang bewarna merah.\nAmbil kertas untuk mendapatkan informasi.\nHindari pesawat yang berlalu-lalang.\n'AURA KEMERDEKAAN' memberikan kekebalan jika bertabrakan dengan pesawat, maka ENERGI berkurang 1 poin saja.\nScore Akumulasi:"+String(SaveManager.getInstance().loadDataScore())+" ":"Cara Main\n\nGerakkan tangganmu keatas dan kebawah.\nAmbil batu pengetahuan yang bewarna merah.\nAmbil kertas untuk mendapatkan informasi.\nHindari pesawat yang berlalu-lalang.";
			startButton.visible = true;
			labelTips.visible = true;
			//force startButton always in top of layers.
			this.setChildIndex(startButton, numChildren-1);
			
			quizBg.visible = false;
			//item info
			itemInfo11.visible = false;
			itemInfo12.visible = false;
			itemInfo13.visible = false;
			
			itemInfo21.visible = false;
			itemInfo22.visible = false;
			itemInfo23.visible = false;
			itemInfo24.visible = false;
			
			itemInfo31.visible = false;
			itemInfo32.visible = false;
			itemInfo33.visible = false;
			//end item info
			
			labelIntro.text = "Kembalikan lembaran sejarah INDONESIA !!";
			labelIntro.visible = false;
			labelLose.text = "Kamu masih belum bisa mengejarku! hahahaha..";
			labelLose.visible = false;
			
		}
		
		private function onStartButtonClick(event:Event):void
		{
			//trace("hiks")
			// Hide start button.
			startButton.visible = false;
			labelTips.visible = false;
			// Launch hero.
			launchHero();
		}
		
		private function launchHero():void
		{
			if(SaveManager.getInstance().loadDataGodlike() == 1)
				particle.start();
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
				
				// If no touch co-ordinates, reset touchX and touchY (for touch screen devices).
				if (isNaN(touchX))
				{
					touchX = stage.stageWidth * 0.5;
					touchY = stage.stageHeight * 0.5;
				}
				
				particle.x = hero.x + 60;
				particle.y = hero.y;
				
				switch(gameState)
				{
					case "idle":
						
						//take off
						if(enemy.x < stage.stageWidth * 0.5 + stage.stageWidth * 0.25)
						{
							enemy.x += (stage.stageWidth * 0.5 + stage.stageWidth * 0.25-enemy.x)*0.01;
							enemy.y -= (enemy.y - touchY) * 0.5;
							enemySpeed += (MIN_SPEED - enemySpeed)* 0.2;
						}
											
						if(hero.x < stage.stageWidth * 0.5 * 0.5)
						{
							hero.x += ((stage.stageWidth * 0.5 * 0.5 + 10)-hero.x)*0.01;
							hero.y -= (hero.y - touchY) * 0.1;
							playerSpeed += (MIN_SPEED - playerSpeed)* 0.01;
							
							
							bg.speed = playerSpeed * elapsed;
							labelIntro.visible = true;
							labelIntro.x = enemy.x-labelIntro.width/2;
							labelIntro.y = enemy.y+enemy.height/2+10;
							labelIntro.x = hero.x;
							labelIntro.y = hero.y+hero.height/2+10;
							if(enemy.x> stage.stageWidth/2)
							{
								labelIntro.text = "Coba ambil kalau bisa.. HAHAHA"
								labelIntro.x = enemy.x-labelIntro.width/2;
								labelIntro.y = enemy.y+enemy.height/2+10;
							}
						}
						else
						{
							gameState = "flying";
							hero.state = 2;
							labelIntro.visible = false;
						}
						
						trace(hero.rotation)
						// Limit the hero's rotation to < 30.
						hero.rotation = deg2rad(0);
						particle.rotation = deg2rad(0);
						/*
						// Rotate hero based on mouse position.
						if ((-(hero.y - touchY) * 0.2) < 30 && (-(hero.y - touchY) * 0.2) > -30) hero.rotation = deg2rad(-(hero.y - touchY) * 0.2);
						
						// Limit the hero's rotation to < 30.
						if (rad2deg(hero.rotation) > 30 ) hero.rotation = rad2deg(30);
						if (rad2deg(hero.rotation) < -30 ) hero.rotation = -rad2deg(30);
						
						// Confine the hero to stage area limit
						if (hero.y > gameArea.bottom - hero.height * 0.5)    
						{
							hero.y = gameArea.bottom - hero.height * 0.5;
							hero.rotation = deg2rad(0);
						}
						if (hero.y < gameArea.top + hero.height * 0.5)    
						{
							hero.y = gameArea.top + hero.height * 0.5;
							hero.rotation = deg2rad(0);
						}
						*/
						break;
					case "flying":
					
						if(hitObstacle <= 0)
						{
							//hero
							hero.y -= (hero.y - touchY) * 0.1;
							
							/*
							if(-(hero.y - touchY)<150 && -(hero.y - touchY)>-150)
							{
								hero.rotation = deg2rad(-(hero.y -touchY) * 0.2);
							}
							if(hero.y > gameArea.bottom)
							{
								hero.y = gameArea.bottom;
								hero.rotation = deg2rad(0);
							}
							if(hero.y < gameArea.top)
							{
								hero.y = gameArea.top;
								hero.rotation = deg2rad(0);
							}
							*/
						}
						else
						{
							hitObstacle--;
							cameraShake();
						}
						 
						playerSpeed -= (playerSpeed - MIN_SPEED) * 0.01;
						bg.speed = playerSpeed * elapsed;
						scoreDistance += (playerSpeed * elapsed)*0.1;
						
						initObstacle();
						animateObstacles();
						
						createFoodItems();
						animateItems();
						animateEatParticles();
						
						if(scoreDistance > 100)
						{
							enemy.x -= (playerSpeed + enemySpeed) * elapsed * 0.1;
							trace(enemy.x);
							if(enemy.x <= stage.stageWidth/2)
								gameState = "overWin";
						}
						else
						{
							enemy.x += (stage.stageWidth* 3-enemy.x)*0.05;
						}
						scoreDistance = scoreDistance+scoreItem;
						scoreText.text = "Score: "+scoreDistance;
						
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
						particle.rotation -= deg2rad(30);
						particle.stop();
						
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
							gameOver(false);
						}
						
						// Set the background's speed based on hero's speed.
						bg.speed = Math.floor(playerSpeed * elapsed);
					break;
					case "overWin":
						
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
						
						if (playerSpeed>=40)
						{
							//do nothing
							labelLose.visible = true;
							labelLose.x = enemy.x-labelLose.width/2;
							labelLose.y = enemy.y+enemy.height/2+10;
							playerSpeed -= playerSpeed * elapsed;
							trace("spee:"+playerSpeed)
							
						}
						else if(playerSpeed>33 && playerSpeed<40)
						{
							enemy.x=enemy.x+enemy.x*elapsed*1.4;
							labelLose.text = "Aku tidak akan menyerah!!";
							labelLose.x = hero.x-labelLose.width/2;
							labelLose.y = hero.y+hero.height/2+10;
							trace("elapsed"+elapsed);
							if(enemy.x > stage.stageWidth*2)
								playerSpeed = 5;
						}
						else
						{
							
							labelLose.visible = false;
							//enemy.x = enemy.x + elapsed;
							// Once he moves out, reset speed to 0.
							playerSpeed = 0;
							
							// Stop game tick.
							this.removeEventListener(Event.ENTER_FRAME, onGameTick);
							
							// Game over.
							gameOver(true);
							trace("game over")
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
					createEatParticles(itemToTrack);
					scoreItem += 10;
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
					disposeItemTemporarily(i, itemToTrack);
				}
			}
		}
		
		private function createEatParticles(itemToTrack:Item):void
		{
			var count:int = 5;
			
			while(count > 0)
			{
				count--;
				
				var eatParticle:Particle = new Particle();
				this.addChild(eatParticle);
				
				eatParticle.x = itemToTrack.x + Math.random() * 40 - 20;
				eatParticle.y = itemToTrack.y - Math.random() * 40;
				
				eatParticle.speedX = Math.random() * 2+1;
				eatParticle.speedY = Math.random() * 5;
				eatParticle.spin = Math.random() * 15;
				
				eatParticle.scaleX = eatParticle.scaleY = Math.random() * 0.3 + 0.3;
				eatParticlesToAnimate.push(eatParticle);
			}
		}
		
		private function animateEatParticles():void
		{
			for(var i:uint = 0;i<eatParticlesToAnimate.length;i++)
			{
				var eatParticleToTrack:Particle = eatParticlesToAnimate[i];
				
				if(eatParticleToTrack)
				{
					eatParticleToTrack.scaleX -= 0.03;
					eatParticleToTrack.scaleY = eatParticleToTrack.scaleX;
					eatParticleToTrack.y -= eatParticleToTrack.speedY;
					eatParticleToTrack.speedY -= eatParticleToTrack.speedY * 0.2;
					
					eatParticleToTrack.x += eatParticleToTrack.speedX;
					eatParticleToTrack.speedX --;
					
					eatParticleToTrack.rotation +=deg2rad(eatParticleToTrack.spin);
					eatParticleToTrack.spin *= 1.1;
					
					if(eatParticleToTrack.scaleY <=0.02)
					{
						eatParticlesToAnimate.splice(i,1);
						this.removeChild(eatParticleToTrack);
						eatParticleToTrack = null;
					}
					
				}
			}
		}
		
		private function createFoodItems():void
		{
			if(Math.random() > 0.95)
			{
				var itemToTrack:Item = new Item(Math.ceil(Math.random() * 2));
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
					
					trace("aduh")
					
					// Update lives.
					if(SaveManager.getInstance().loadDataGodlike() == 1)
						lives-=1;
					else
						lives-=5;
					
					if (lives <= 0)
					{
						lives = 0;
						endGame();
					}
					
					scoreLife.text = "Energi: "+String(lives);
					
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
			quizBg.visible = true;
			for(var i:uint = 0;i<itemsToAnimate.length;i++)
			{
				itemsToAnimate[i].visible = false;
			}
			//statusT = new TextField(480, 600, "", fontRegular.fontName, fontRegular.fontSize, 0xffffff);
			statusT.visible = true;
			
			finishButton.visible = true;
   			nextButton.visible = false;
			
			quizQuestions = new Array();
			questionLevels();
			
			var questionTemp:Number = Math.ceil(Math.random() * ((quizQuestions.length - 1) - 0)+0);
			addQuestions(questionTemp);
			questionTemporary = questionTemp;
			
		}
		
		private function questionLevels() {
			switch(level)
			{
				case 1:
					createQuestions1();
					break;
				case 2:
					createQuestions2();
					break;
				case 3:
					createQuestions3();
					break;
			}
		}
		
		private function createQuestions1() {
            quizQuestions.push(new QuizQuestion(stage.stageWidth/2,"Dummy",
                                                            0,
                                                            "Dummy",
                                                            "Dummy",
                                                            "Dummy",
                                                            "Dummy"));
            quizQuestions.push(new QuizQuestion(stage.stageWidth/2,"Didaerah mana pertama kali tentara jepang menduduki Indonesia?",
                                                            0,
                                                            "Tarakan",
                                                            "Makasar"));
            quizQuestions.push(new QuizQuestion(stage.stageWidth/2,"Kapan pemerintah Hindia Belanda menyerah tanpa syarat kepada Jepang?",
                                                            1,
                                                            "8 Januari 1942",
                                                            "8 Maret 1942"));
            quizQuestions.push(new QuizQuestion(stage.stageWidth/2,"Untuk memikat hari rakyat, Jepang membuat propaganda Tiga A, yang berisi?",
                                                            0,
                                                            "Jepang pemimpin Asia,Jepang pelindung Asia,Jepang cahaya Asia",
                                                            "Jepang pemimpin Asia,Jepang perisai Asia,Jepang cahaya Asia"));
        }
		
		private function createQuestions2() {
            quizQuestions.push(new QuizQuestion(stage.stageWidth/2,"Dummy",
                                                            0,
                                                            "Dummy",
                                                            "Dummy",
                                                            "Dummy",
                                                            "Dummy"));
            quizQuestions.push(new QuizQuestion(stage.stageWidth/2,"Kapan hari lahirnya pancasila?",
                                                            0,
                                                            "5 Agustus 1945",
                                                            "1 Juni 1945"));
            quizQuestions.push(new QuizQuestion(stage.stageWidth/2,"Disebut apakah peristiwa penculikan Soekarno dan Hatta oleh sejumlah pemuda?",
                                                            0,
                                                            "Peristiwa Reangasdengklok",
                                                            "Agresi Militer 2"));
            quizQuestions.push(new QuizQuestion(stage.stageWidth/2,"Kapan Soekarno dan Hatta memproklamasikan kemerdekaan Indonesia?",
                                                            0,
                                                            "17 Agustus 1945",
                                                            "18 Agustus 1945"));
			 quizQuestions.push(new QuizQuestion(stage.stageWidth/2,"Sebutkan salah satu hasil dari sidang pertama PPKI?",
                                                            1,
                                                            "Mengesahkan UUDs 1945",
                                                            "Mengangkat Soekarno sebagai presiden RI dan Hatta sebagawai wakilnya"));
        }
		
		private function createQuestions3() {
            quizQuestions.push(new QuizQuestion(stage.stageWidth/2,"Dummy",
                                                            0,
                                                            "Dummy",
                                                            "Dummy",
                                                            "Dummy",
                                                            "Dummy"));
            quizQuestions.push(new QuizQuestion(stage.stageWidth/2,"Kapan Belanda melancarkan agresi militer pertamanya?",
                                                            0,
                                                            "21 Juli-5 Agustus 1947",
                                                            "5 Desember 1948-19 Januari 1949"));
            quizQuestions.push(new QuizQuestion(stage.stageWidth/2,"Kapan Belanda melancarkan agresi militer keduanya?",
                                                            1,
                                                            "21 Juli-5 Agustus 1947",
                                                            "19 Desember 1948-5 Januari 1949"));
            quizQuestions.push(new QuizQuestion(stage.stageWidth/2,"Dimanakah tempat berlangsungnya Konferensi Meja Bundar?",
                                                            1,
                                                            "Jakarta, Indonesia",
                                                            "Den Haag, Belanda"));
        }
		
		 private function showMessage(theMessage:String) {
            statusT.text = theMessage;
            statusT.x = stage.stageWidth/2 - statusT.width/2;
        }
        private function addQuestions(numQuestion:Number) {
			quizQuestions[numQuestion].y = stage.stageHeight/2 - quizQuestions[numQuestion].height/2;

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
					if(level == 1)
					{
						createImageLevel1(questionTemporary);
					}
					if(level == 2)
					{
						createImageLevel2(questionTemporary);
					}
					if(level == 3)
					{
						createImageLevel3(questionTemporary);
					}
					//showMessage("Jawaban benar "+quizQuestions[questionTemporary].correctAnswer);
					showMessage("BENAR, Kamu mendapat gambar informasi dibawah ini.\n Detail silahkan dilihat di menu 'Galeri Info'");
					scoreLife.text = "Energi: "+String(lives);
					//SaveManager.getInstance().saveDataItemSingle(true);
            } else {
				lives-=1;
				removeQuestions(questionTemporary);	
				hideQuestion(questionTemporary);
				//showMessage("Jawaban Salah "+quizQuestions[questionTemporary].userAnswer);
				showMessage("SALAH, Coba lagi!!\nPeringatan:Energi berkurang 1 poin.");
				scoreLife.text = "Energi: "+String(lives);
            }
			
			nextButton.visible = true;
        }
		
		private function nextHandler(event:Event) {
			gamePaused = false;
			nextButton.visible = false;
			if(level == 1)
			{
				resetImageLevel1();
			}
			if(level == 2)
			{
				resetImageLevel2();
			}
			if(level == 3)
			{
				resetImageLevel3();
			}
			
			showMessage("");
			quizBg.visible = false;
			for(var i:uint = 0;i<itemsToAnimate.length;i++)
			{
				itemsToAnimate[i].visible = true;
			}
		}
		
		private function hideQuestion(numQuestion:Number):void
		{
			showMessage("");
			this.removeQuestions(numQuestion);
			finishButton.visible = false;
		}
		
		//end quiz
		
		
		private function createImageLevel1(index:int) {
			switch(index)
			{
				case 1:
					itemInfo11.visible = true;
					SaveManager.getInstance().saveGalInfo(true,1);
					break;
				case 2:
					itemInfo12.visible = true;
					SaveManager.getInstance().saveGalInfo(true,2);
					break;
				case 3:
					itemInfo13.visible = true;
					SaveManager.getInstance().saveGalInfo(true,3);
					break;
			}
			
		}
		
		private function createImageLevel2(index:int) {
			switch(index)
			{
				case 1:
					itemInfo21.visible = true;
					SaveManager.getInstance().saveGalInfo(true,4);
					break;
				case 2:
					itemInfo22.visible = true;
					SaveManager.getInstance().saveGalInfo(true,5);
					break;
				case 3:
					itemInfo23.visible = true;
					SaveManager.getInstance().saveGalInfo(true,6);
					break;
				case 4:
					itemInfo24.visible = true;
					SaveManager.getInstance().saveGalInfo(true,7);
					break;
			}
			
		}
		
		private function createImageLevel3(index:int) {
			switch(index)
			{
				case 1:
					itemInfo31.visible = true;
					SaveManager.getInstance().saveGalInfo(true,8);
					break;
				case 2:
					itemInfo32.visible = true;
					SaveManager.getInstance().saveGalInfo(true,9);
					break;
				case 3:
					itemInfo33.visible = true;
					SaveManager.getInstance().saveGalInfo(true,10);
					break;
			}
			
		}
		
		private function resetImageLevel1() {
			
			if(itemInfo11.visible == true)
			itemInfo11.visible = false;
			else if(itemInfo12.visible == true)
			itemInfo12.visible = false;
			else if(itemInfo13.visible == true)
			itemInfo13.visible = false;
			
		}
		
		private function resetImageLevel2() {
			
			if(itemInfo21.visible == true)
			itemInfo21.visible = false;
			else if(itemInfo22.visible == true)
			itemInfo22.visible = false;
			else if(itemInfo23.visible == true)
			itemInfo23.visible = false;
			else if(itemInfo24.visible == true)
			itemInfo24.visible = false;
			
		}
		
		private function resetImageLevel3() {
			
			if(itemInfo31.visible == true)
			itemInfo31.visible = false;
			else if(itemInfo32.visible == true)
			itemInfo32.visible = false;
			else if(itemInfo33.visible == true)
			itemInfo33.visible = false;
			
		}
		/**
		 * End game. 
		 * 
		 */
		private function endGame():void
		{
			this.x = 0;
			this.y = 0;
			
			//temporary using distance
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
			gameOverScreen.disposeTemporarily();
			initialize(level);
		}
		
		/**
		 * Game Over - called when hero falls out of screen and when Game Over data should be displayed. 
		 * 
		 */
		private function gameOver(isWin:Boolean):void
		{
			this.setChildIndex(gameOverScreen, this.numChildren-1);
			gameOverScreen.initialize(score, Math.round(scoreDistance),isWin);
			
			tween_gameOverContainer = new Tween(gameOverScreen, 1);
			tween_gameOverContainer.fadeTo(1);
			Starling.juggler.add(tween_gameOverContainer);
		}
	}
	
}
