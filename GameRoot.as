package  {
	import starling.display.Sprite;
	import framework.events.NavigationEvent;
	import framework.screenstates.MainMenu;
	import framework.events.NavigationEvent;
	import starling.events.Event;
	import framework.screenstates.GamePlay;
	import framework.screenstates.ChooseLevel;
	import framework.screenstates.CollectItems;
	import framework.utils.SaveManager;
	import starling.animation.Tween;
	import framework.utils.GameAssets;
	
	
	
	import flash.media.SoundMixer;
	import framework.ui.SoundButton;
	import framework.ui.ExitButton;
	import flash.desktop.NativeApplication;
	
	public class GameRoot extends Sprite{

		private var mainMenu:MainMenu;
		private var screenGamePlay:GamePlay;
		private var screenGameLevels:ChooseLevel;
		private var screenCollectItems:CollectItems;
		/** Exit button. */
		private var exitBtn:ExitButton;
		/** Sound button. */
		private var soundBtn:SoundButton;
		
		public function GameRoot() {
			// constructor code
			super();
			if(GameSettings.RESET_SAVE)
				SaveManager.getInstance().resetData();
			if(GameSettings.CHEAT_MODE)
				SaveManager.getInstance().cheatMode();
			SaveManager.getInstance().initialize();
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
			//screenGamePlay.disposeTemporarily();
			
			screenGameLevels = new ChooseLevel();
			screenGameLevels.addEventListener(NavigationEvent.SWITCH_STATE, onChooseLevelNavigation);
			this.addChild(screenGameLevels);
			//screenGameLevels.disposeTemporarily();
			
			screenCollectItems = new CollectItems();
			screenCollectItems.addEventListener(NavigationEvent.SWITCH_STATE, onCollectItemsNavigation);
			this.addChild(screenCollectItems);
			//screenCollectItems.disposeTemporarily();
			
			// Main menu screen.
			mainMenu = new MainMenu();
			this.addChild(mainMenu);
			
			/* exit button */
			exitBtn = new ExitButton();
			exitBtn.x = stage.stageWidth - exitBtn.width - (stage.stageWidth/14);
			exitBtn.y = (stage.stageHeight/14);
			exitBtn.addEventListener(Event.TRIGGERED, onExitClick);
			this.addChild(exitBtn);
			/* sound button */
			soundBtn = new SoundButton();
			soundBtn.x = stage.stageWidth - soundBtn.width - (stage.stageWidth/14) - soundBtn.width - (stage.stageHeight/20);
			soundBtn.y = (stage.stageHeight/14);
			soundBtn.addEventListener(Event.TRIGGERED, onSoundClick);
			this.addChild(soundBtn);
			
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
					screenGamePlay.disposeTemporarily();
					mainMenu.initialize();
					break;
				case "about":
					screenGamePlay.disposeTemporarily();
					mainMenu.initialize();
					mainMenu.showAbout();
					break;
				case "items":
					screenGamePlay.disposeTemporarily();
					screenCollectItems.initialize();
					break;
			}
		}
		
		private function onCollectItemsNavigation(event:NavigationEvent):void
		{
			switch (event.params.id)
			{
				case "mainMenu":
					screenCollectItems.disposeTemporarily();
					mainMenu.initialize();
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
				case "mainMenu":
					screenGameLevels.disposeTemporarily();
					mainMenu.initialize();
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
				case "items":
					mainMenu.disposeTemporarily();
					screenCollectItems.initialize();
					break;
			}
		}
		
		private function onSoundClick(event:Event = null):void
		{
			if (Sounds.muted)
			{
				Sounds.muted = false;
				
				if (mainMenu.visible) Sounds.sndBgMain.play(0, 999);
				else if (screenGamePlay.visible) Sounds.sndBgGame.play(0, 999);
				
				soundBtn.showUnmuteState();
			}
			else
			{
				Sounds.muted = true;
				SoundMixer.stopAll();
				
				soundBtn.showMuteState();
			}
		}
		
		private function onExitClick(event:Event):void
		{
			NativeApplication.nativeApplication.exit(); 
		}
		
	}
	
}
