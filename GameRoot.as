package  {
	import starling.display.Sprite;
	import framework.events.NavigationEvent;
	import framework.screenstates.MainMenu;
	import framework.events.NavigationEvent;
	import starling.events.Event;
	
	public class GameRoot extends Sprite{

		private var mainMenu:MainMenu;
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
			
			
			// Main menu screen.
			mainMenu = new MainMenu();
			this.addChild(mainMenu);
			
			mainMenu.initialize();
		}
		
		private function onChangeScreen(event:NavigationEvent):void
		{
			switch (event.params.id)
			{
				case "play":
					//screenWelcome.disposeTemporarily();
					//screenInGame.initialize();
					break;
			}
		}
	}
	
}
