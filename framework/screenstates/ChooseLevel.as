package framework.screenstates
{

	import starling.display.Button;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.VAlign;
	import framework.events.NavigationEvent;
	import framework.utils.GameAssets;
	
	public class ChooseLevel extends Sprite
	{
		/** Background image. */
		private var bg:Quad;
		
		/** Message text field. */
		private var messageText:TextField;
		
		/** Play again button. */
		private var playAgainBtn:Button;
		
		/** Main Menu button. */
		private var mainBtn:Button;
		
		/** Level button. */
		private var level1Btn:Button;
		private var level2Btn:Button;
		private var level3Btn:Button;
		
		public function ChooseLevel()
		{
			super();
			
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
			
			drawChooseLevel();
		}
		
		/**
		 * Draw game over screen. 
		 * 
		 */
		private function drawChooseLevel():void
		{
			
			// Background quad.
			bg = new Quad(stage.stageWidth, stage.stageHeight, 0x000000);
			//bg.alpha = 0.75;
			this.addChild(bg);
			
			// Message text field.
			messageText = new TextField(stage.stageWidth, stage.stageHeight * 0.5, "CHOOSE LEVEL!", "nulshock", 20, 0xFFFFFF);
			messageText.vAlign = VAlign.TOP;
			messageText.height = messageText.textBounds.height;
			messageText.y = (stage.stageHeight/14);
			this.addChild(messageText);
			
			// Navigation buttons.
			mainBtn = new Button(GameAssets.getAtlasFix().getTexture("btn_home"));
			mainBtn.x = (stage.stageWidth/14);
			mainBtn.y = stage.stageHeight - (stage.stageHeight/14) - mainBtn.height;
			mainBtn.addEventListener(Event.TRIGGERED, onMainClick);
			this.addChild(mainBtn);
			
			var yPosition:Number = stage.stageHeight/2;
			
			level2Btn = new Button(GameAssets.getAtlasFix().getTexture("btn_1945"));
			level2Btn.x = stage.stageWidth/2 - level2Btn.width/2;
			level2Btn.y = yPosition - level2Btn.height/2;
			level2Btn.addEventListener(Event.TRIGGERED, onPlayClick2);
			this.addChild(level2Btn);
			
			level1Btn = new Button(GameAssets.getAtlasFix().getTexture("btn_1942"));
			level1Btn.x = level2Btn.x - level2Btn.width - 10;
			level1Btn.y = yPosition- level2Btn.height/2;
			level1Btn.addEventListener(Event.TRIGGERED, onPlayClick1);
			this.addChild(level1Btn);
			
			level3Btn = new Button(GameAssets.getAtlasFix().getTexture("btn_1950"));
			level3Btn.x = level2Btn.x + level2Btn.width + 10;
            level3Btn.y = yPosition- level3Btn.height/2;
			level3Btn.addEventListener(Event.TRIGGERED, onPlayClick3);
			this.addChild(level3Btn);
			
			
			
			
		}
		
		/**
		 * On main menu button click. 
		 * @param event
		 * 
		 */
		private function onMainClick(event:Event):void
		{
			//if (!Sounds.muted) Sounds.sndMushroom.play();
			
			this.dispatchEvent(new NavigationEvent(NavigationEvent.SWITCH_STATE, {id: "mainMenu"}, true));
		}
		
		private function onPlayClick1(event:Event):void
		{
			this.dispatchEvent(new NavigationEvent(NavigationEvent.SWITCH_STATE, {id: "play1"},true));
		}
		
		private function onPlayClick2(event:Event):void
		{
			this.dispatchEvent(new NavigationEvent(NavigationEvent.SWITCH_STATE, {id: "play2"},true));
		}
		
		private function onPlayClick3(event:Event):void
		{
			this.dispatchEvent(new NavigationEvent(NavigationEvent.SWITCH_STATE, {id: "play3"},true));
		}
		
		/**
		 * Initialize Game Over container. 
		 * @param _score
		 * @param _distance
		 * 
		 */
		public function initialize():void
		{
			this.visible = true;
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
		}
		
	}
}