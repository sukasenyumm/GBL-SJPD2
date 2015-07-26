package  {
	import starling.display.Sprite;
	import framework.events.NavigationEvent;
	import framework.screenstates.MainMenu;
	import framework.events.NavigationEvent;
	import starling.events.Event;
	import framework.screenstates.GamePlay;
	
	public class GameRoot extends Sprite{

		private var mainMenu:MainMenu;
		private var screenGamePlay:GamePlay;
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
			//sembunyikan gameplay dari screen
			//screenGamePlay.disposeTemporarily();
			this.addChild(screenGamePlay);
			
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
					//screenWelcome.initialize();
					//screenWelcome.showAbout();
					break;
			}
		}
		
		private function onChangeScreen(event:NavigationEvent):void
		{
			switch (event.params.id)
			{
				case "play":
					mainMenu.disposeTemporarily();
					screenGamePlay.initialize();
					break;
			}
		}
	}
	
}
