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
	import starling.display.Image;
	import starling.display.BlendMode;
	
	public class ChooseLevel extends Sprite
	{
		/** Background image. */
		private var bg:Image;
		
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
		
		/** Current date. */
		private var _currentDate:Date;
		
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
			bg = new Image(GameAssets.getTexture("BgMenu"));
			bg.width = stage.stageWidth;
			bg.height = stage.stageHeight;
			//bg.alpha = 0.75;
			this.addChild(bg);
			bg.blendMode = BlendMode.NONE;
			bg.visible = false;
			
			// GENERAL ELEMENTS
			var bottomColor:uint = 0xFFFFFF; // white
			var topColor:uint    = 0xea0b0b; // red	
			bg.setVertexColor(0, topColor);
			bg.setVertexColor(1, topColor);
			bg.setVertexColor(2, bottomColor);
			bg.setVertexColor(3, bottomColor);
			
			// Message text field.
			messageText = new TextField(stage.stageWidth, stage.stageHeight * 0.5, "CHOOSE LEVEL!", "nulshock", 20, 0xFFFFFF);
			messageText.vAlign = VAlign.TOP;
			messageText.height = messageText.textBounds.height;
			messageText.y = (stage.stageHeight/14);
			this.addChild(messageText);
			messageText.visible = false;
			
			// Navigation buttons.
			mainBtn = new Button(GameAssets.getAtlasFix().getTexture("btn_home"));
			mainBtn.x = (stage.stageWidth/14);
			mainBtn.y = stage.stageHeight - (stage.stageHeight/14) - mainBtn.height;
			mainBtn.addEventListener(Event.TRIGGERED, onMainClick);
			this.addChild(mainBtn);
			mainBtn.visible = false;
			
			var yPosition:Number = stage.stageHeight/2;
			
			level2Btn = new Button(GameAssets.getAtlasFix().getTexture("btn_1945"));
			level2Btn.x = stage.stageWidth/2 - level2Btn.width/2;
			level2Btn.y = yPosition - level2Btn.height/2;
			level2Btn.addEventListener(Event.TRIGGERED, onPlayClick2);
			this.addChild(level2Btn);
			level2Btn.visible = false;
			
			level1Btn = new Button(GameAssets.getAtlasFix().getTexture("btn_1942"));
			level1Btn.x = level2Btn.x - level2Btn.width - 10;
			level1Btn.y = yPosition- level2Btn.height/2;
			level1Btn.addEventListener(Event.TRIGGERED, onPlayClick1);
			this.addChild(level1Btn);
			level1Btn.visible = false;
			
			level3Btn = new Button(GameAssets.getAtlasFix().getTexture("btn_1950"));
			level3Btn.x = level2Btn.x + level2Btn.width + 10;
            level3Btn.y = yPosition- level3Btn.height/2;
			level3Btn.addEventListener(Event.TRIGGERED, onPlayClick3);
			this.addChild(level3Btn);
			level3Btn.visible = false;
			
		}
		
		/**
		 * On main menu button click. 
		 * @param event
		 * 
		 */
		private function onMainClick(event:Event):void
		{
			this.dispatchEvent(new NavigationEvent(NavigationEvent.SWITCH_STATE, {id: "mainMenu"}, true));
			if (!Sounds.muted) Sounds.sndMushroom.play();
		}
		
		private function onPlayClick1(event:Event):void
		{
			this.dispatchEvent(new NavigationEvent(NavigationEvent.SWITCH_STATE, {id: "play1"},true));
			if (!Sounds.muted) Sounds.sndCoffee.play();
		}
		
		private function onPlayClick2(event:Event):void
		{
			this.dispatchEvent(new NavigationEvent(NavigationEvent.SWITCH_STATE, {id: "play2"},true));
			if (!Sounds.muted) Sounds.sndCoffee.play();
		}
		
		private function onPlayClick3(event:Event):void
		{
			this.dispatchEvent(new NavigationEvent(NavigationEvent.SWITCH_STATE, {id: "play3"},true));
			if (!Sounds.muted) Sounds.sndCoffee.play();
		}
		
		/**
		 * Initialize Game Over container. 
		 * @param _score
		 * @param _distance
		 * 
		 */
		public function initialize():void
		{
			disposeTemporarily();
			if (!Sounds.muted) Sounds.sndBgMain.play(0, 999);
			this.visible = true;
			bg.visible = true;
			messageText.visible = true;
			level1Btn.visible = true;
			level2Btn.visible = true;
			level3Btn.visible = true;
			mainBtn.visible = true;
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
			level1Btn.y = (stage.stageHeight/2 - level1Btn.height/2) + (Math.cos(_currentDate.getTime() * 0.002)) * 10;
			level2Btn.y = (stage.stageHeight/2 - level2Btn.height/2) + (Math.cos(_currentDate.getTime() * 0.002)) * 10;
			level3Btn.y = (stage.stageHeight/2 - level3Btn.height/2) + (Math.cos(_currentDate.getTime() * 0.002)) * 10;
			
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
			if(this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME,floatingAnimation);
			
		}
		
	}
}