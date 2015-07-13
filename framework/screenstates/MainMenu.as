package framework.screenstates
{
	import starling.display.Sprite;
	import starling.display.Image;
	import framework.utils.GameAssets;
	import starling.display.BlendMode;
	import starling.events.Event;
	import starling.display.Button;
	import starling.text.TextField;
	import framework.customObjects.Font;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import framework.utils.Fonts;

	
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
		
		
		public function MainMenu()
		{
			super();
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
			

		}
		
		private function onAboutClick(event:Event):void
		{
			showAbout();
		}
		
		private function onAboutBackClick(event:Event):void
		{
			initialize();
		}
		
		public function showAbout():void
		{
			screenMode = "about";
			aboutBtn.visible = false;
			aboutText.visible = true;
			backBtn.visible = true;
		}
		

		public function initialize():void
		{
			disposeTemporarily();		
			aboutText.visible = false;
			backBtn.visible = false;
			aboutBtn.visible = true;
			this.visible = true;
		}
		
		/**
		 * Dispose objects temporarily. 
		 * 
		 */
		public function disposeTemporarily():void
		{
			this.visible = false;
		}
	}
}