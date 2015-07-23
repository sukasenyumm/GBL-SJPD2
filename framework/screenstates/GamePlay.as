package framework.screenstates{
	import framework.gameobject.Hero;
	import starling.events.Event;
	import starling.display.Sprite;
	import framework.gameobject.GameBackground;
	import flash.utils.getTimer;
	import starling.display.Button;
	import framework.utils.GameAssets;
	
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
		
		public function GamePlay() {
			// constructor code
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			drawGame();
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
			this.addEventListener(Event.ENTER_FRAME, onGameTick);
		}
		
		private function onGameTick(event:Event):void
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
				playerSpeed -= (playerSpeed - MIN_SPEED) * 0.01;
				bg.speed = playerSpeed * elapsed;
				break;
				case "over":
				break;
			}
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
	}
	
}
