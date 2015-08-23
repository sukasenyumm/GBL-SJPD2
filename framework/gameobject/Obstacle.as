package framework.gameobject {
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.display.MovieClip;
	import framework.utils.GameAssets;
	import starling.core.Starling;
	import starling.display.Image;
	
	import starling.core.Starling;
	
	public class Obstacle extends Sprite{
		
		private var _type:int;
		private var _speed:int;
		private var _distance:int;
		private var _watchOut:Boolean;
		private var _alreadyHit:Boolean;
		private var _position:String;
		private var obstacleCrashAnimation:MovieClip;
		private var obstacleAnimation:MovieClip;
		private var watchOutAnimation:MovieClip;
		
		public function Obstacle(_type:int,_distance:int,_watchOut:Boolean = true,_speed:int = 0) {
			// constructor code
			super();
			
			this._type = _type;
			this._distance = _distance;
			this._watchOut = _watchOut;
			this._speed = _speed;
			
			_alreadyHit = false;
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			createObstacleArt();
			createObstacleCrashArt();
			createWatchOutAnimation();
		}
		
		private function createWatchOutAnimation():void
		{
			watchOutAnimation = new MovieClip(GameAssets.getAtlasFix().getTextures("watchOut_"),10);
			Starling.juggler.add(watchOutAnimation);
			
			watchOutAnimation.x = -watchOutAnimation.texture.width;
			watchOutAnimation.y = obstacleAnimation.y + (obstacleAnimation.texture.height * 0.5)-(watchOutAnimation.texture.height * 0.5);
			
			this.addChild(watchOutAnimation);
		}
		
		
		private function createObstacleCrashArt():void
		{
			obstacleCrashAnimation = new MovieClip(GameAssets.getAtlasFix().getTextures("obstacle" + _type + "_crash" + "_0"),10);
			Starling.juggler.add(obstacleCrashAnimation);
			obstacleCrashAnimation.x = 0;
			obstacleCrashAnimation.y = 0;
			this.addChild(obstacleCrashAnimation);
			obstacleCrashAnimation.visible = false;
		}
		
		private function createObstacleArt():void
		{
			obstacleAnimation = new MovieClip(GameAssets.getAtlasFix().getTextures("obstacle" + _type + "_0"),10);
			Starling.juggler.add(obstacleAnimation);
			obstacleAnimation.x = 0;
			obstacleAnimation.y = 0;
			this.addChild(obstacleAnimation);
			
		}
		
		public function forceWatchOutDisposes(state:String):void
		{
			if(state == "over")
			{
				Starling.juggler.remove(watchOutAnimation);
				watchOutAnimation.visible = false;
				this.removeChild(watchOutAnimation);
			}
			
		}
		
		public function get watchOut():Boolean
		{
			return _watchOut;
		}
		
		public function set watchOut(value:Boolean):void
		{
			_watchOut = value;
			
			if(watchOutAnimation)
			{
				if(value) watchOutAnimation.visible = true;
				else 
				{
					watchOutAnimation.visible = false;
					Starling.juggler.remove(watchOutAnimation);
				}
			}
		}
		
		public function get alreadyHit():Boolean
		{
			return _alreadyHit;
		}
		
		public function set alreadyHit(value:Boolean):void
		{
			_alreadyHit = value;
			
			if(value)
			{
				obstacleCrashAnimation.visible = true;
				obstacleAnimation.visible = false;
			}
		}
		
		public function get speed():int
		{
			return _speed;
		}
		
		public function set speed(value:int):void
		{
			_speed = value;
		}
		
		public function get distance():int
		{
			return _distance;
		}
		
		public function set distance(value:int):void
		{
			_distance = value;
		}
		
		public function get position():String
		{
			return _position;
		}
		
		public function set position(value:String):void
		{
			_position = value;
		}

	}
	
}
