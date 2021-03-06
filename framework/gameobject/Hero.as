﻿package framework.gameobject {
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.display.MovieClip;
	import framework.utils.GameAssets;
	import starling.core.Starling;
	
	public class Hero extends Sprite{

		private var heroArt:MovieClip;
		/** State of the hero. */
		private var _state:int;
		public function Hero() {
			// constructor code
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			createHeroArt();
		}
		
		private function createHeroArt():void
		{
			heroArt = new MovieClip(GameAssets.getAtlasFix().getTextures("hero_"), 20);
			heroArt.x = Math.ceil(-heroArt.width/2);
			heroArt.y = Math.ceil(-heroArt.height/2);
			
			Starling.juggler.add(heroArt);
			this.addChild(heroArt);
		}
		
		/**
		 * State of the hero. 
		 * @return 
		 * 
		 */
		public function get state():int { return _state; }
		public function set state(value:int):void { _state = value; }
	}
	
}
