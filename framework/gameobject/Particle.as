package framework.gameobject{
	import starling.display.Sprite;
	import starling.display.Image;
	import framework.utils.GameAssets;
	
	public class Particle extends Sprite{
		
		private var _speedX:Number;
		private var _speedY:Number;
		private var _spin:Number;
		
		private var _image:Image;
		
		public function Particle() {
			// constructor code
			super();
			
			_image = new Image(GameAssets.getTexture("particle"));
			_image.x = _image.width * 0.5;
			_image.y = _image.height * 0.5;
			this.addChild(_image);
		}
		
		public function get speedX():int
		{
			return _speedX;
		}
		
		public function set speedX(value:int):void
		{
			_speedX = value;
		}
		
		public function get speedY():int
		{
			return _speedY;
		}
		
		public function set speedY(value:int):void
		{
			_speedY = value;
		}
		
		public function get spin():int
		{
			return _spin;
		}
		
		public function set spin(value:int):void
		{
			_spin = value;
		}
	}
	
}
