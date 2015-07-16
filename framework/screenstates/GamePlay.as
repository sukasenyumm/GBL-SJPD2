package framework.screenstates{
	import framework.gameobject.Hero;
	import starling.events.Event;
	import starling.display.Sprite;
	
	public class GamePlay extends Sprite{

		private var hero:Hero;
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
			hero = new Hero();
			hero.x = stage.stageWidth/2;
			hero.y = stage.stageHeight/2;
			this.addChild(hero);
		}
		public function disposeTemporarily():void
		{
			this.visible = false;
		}
		
		public function initialize():void
		{
			this.visible = true;
		}
	}
	
}
