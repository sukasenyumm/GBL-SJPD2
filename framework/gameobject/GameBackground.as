package framework.gameobject {
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class GameBackground extends Sprite{

		private var bgLayer1:BgLayer;
		private var bgLayer2:BgLayer;
		private var bgLayer3:BgLayer;
		private var bgLayer4:BgLayer;
		private var _speed:Number = 0;
		/** State of the game. */		
		private var _state:int;
		
		public function GameBackground() {
			// constructor code
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			bgLayer1 = new BgLayer(1);
			bgLayer1.parallax = 0.02;
			this.addChild(bgLayer1);
			
			bgLayer2 = new BgLayer(2);
			bgLayer2.parallax = 0.2;
			this.addChild(bgLayer2);
			
			bgLayer3 = new BgLayer(3);
			bgLayer3.parallax = 0.5;
			this.addChild(bgLayer3);
			
			bgLayer4 = new BgLayer(4);
			bgLayer4.parallax = 1;
			this.addChild(bgLayer4);
			
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void
		{
			// Background 1 - Sky
			bgLayer1.x -= Math.ceil(_speed * bgLayer1.parallax);
			// Hero flying right
			if (bgLayer1.x < -stage.stageWidth ) bgLayer1.x = 0;
			
			// Background 2 - Hills
			bgLayer2.x -= Math.ceil(_speed * bgLayer2.parallax);
			// Hero flying right
			if (bgLayer2.x < -stage.stageWidth ) bgLayer2.x = 0;
			
			// Background 3 - Buildings
			bgLayer3.x -= Math.ceil(_speed * bgLayer3.parallax);
			// Hero flying right
			if (bgLayer3.x < -stage.stageWidth ) bgLayer3.x = 0;
			
			// Background 4 - Trees
			bgLayer4.x -= Math.ceil(_speed * bgLayer4.parallax);
			// Hero flying right
			if (bgLayer4.x < -stage.stageWidth ) bgLayer4.x = 0;
		}
		
		public function get speed():Number
		{
			return _speed;
		}
		
		public function set speed(value:Number):void
		{
			_speed = value;
		}
		
		/**
		 *  
		 * State of the game.
		 * 
		 */
		public function get state():int { return _state; }
		public function set state(value:int):void { _state = value; }

	}
	
}
