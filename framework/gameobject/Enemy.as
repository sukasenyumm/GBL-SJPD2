package framework.gameobject {
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.display.MovieClip;
	import framework.utils.GameAssets;
	import starling.core.Starling;
	
	public class Enemy extends Sprite{

		private var enemyArt:MovieClip;
		/** State of the hero. */
		private var _state:int;
		public function Enemy() {
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
			enemyArt = new MovieClip(GameAssets.getAtlasFix().getTextures("enemy_"), 20);
			enemyArt.x = Math.ceil(-enemyArt.width/2);
			enemyArt.y = Math.ceil(-enemyArt.height/2);
			
			Starling.juggler.add(enemyArt);
			this.addChild(enemyArt);
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
