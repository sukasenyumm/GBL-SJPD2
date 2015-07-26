package  {
	import starling.display.Sprite;
	import framework.events.NavigationEvent;
	import framework.screenstates.MainMenu;
	import framework.events.NavigationEvent;
	import starling.events.Event;
	import framework.screenstates.GamePlay;
	import framework.screenstates.ChooseLevel;
	
	public class GameRoot extends Sprite{

		private var mainMenu:MainMenu;
		private var screenGamePlay:GamePlay;
		private var screenGameLevels:ChooseLevel;
		public function GameRoot() {
			// constructor code
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			// Initialize Game Menu.
			initGameMenuComponents();
		}
		
		/**
		* fungsi init Game menu, bangkitkan objek pada state menu disini
		*/
		private function initGameMenuComponents():void
		{
			this.addEventListener(NavigationEvent.SWITCH_STATE, onChangeScreen);
			
			screenGamePlay = new GamePlay();
			screenGamePlay.addEventListener(NavigationEvent.SWITCH_STATE, onInGameNavigation);
			this.addChild(screenGamePlay);
			//sembunyikan gameplay dari screen
			screenGamePlay.disposeTemporarily();
			
			screenGameLevels = new ChooseLevel();
			screenGameLevels.addEventListener(NavigationEvent.SWITCH_STATE, onChooseLevelNavigation);
			this.addChild(screenGameLevels);
			screenGameLevels.disposeTemporarily();
			
			// Main menu screen.
			mainMenu = new MainMenu();
			this.addChild(mainMenu);
			
			mainMenu.initialize();
		}
		
		/**
		 * On navigation from different screens. 
		 * @param event
		 * 
		 */
		private function onInGameNavigation(event:NavigationEvent):void
		{
			switch (event.params.id)
			{
				case "mainMenu":
					mainMenu.initialize();
					break;
				case "about":
					mainMenu.initialize();
					mainMenu.showAbout();
					break;
			}
		}
		
		/**
		 * On navigation from different screens. 
		 * @param event
		 * 
		 */
		private function onChooseLevelNavigation(event:NavigationEvent):void
		{
			switch (event.params.id)
			{
				case "play1":
					screenGameLevels.disposeTemporarily();
					screenGamePlay.initialize(1);
					break;
				case "play2":
					screenGameLevels.disposeTemporarily();
					screenGamePlay.initialize(2);
					break;
				case "play3":
					screenGameLevels.disposeTemporarily();
					screenGamePlay.initialize(3);
					break;
			}
		}
		
		private function onChangeScreen(event:NavigationEvent):void
		{
			switch (event.params.id)
			{
				case "level":
					mainMenu.disposeTemporarily();
					screenGameLevels.initialize();
					break;
			}
		}
	}
	
}
