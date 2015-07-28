package framework.gameobject {
	import starling.display.Sprite;
	import starling.display.Image;
	import framework.utils.GameAssets;
	import starling.events.Event;
	import starling.display.BlendMode;
	
	public class BgLayer extends Sprite{
		
		private var image1:Image;
		private var image2:Image;
		
		private var layer:int;
		private var _parallax:Number;
		
		public function BgLayer(nlayer:int) {
			// constructor code
			super();
			this.layer = nlayer;
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			if(layer == 1)
			{
				image1 = new Image(GameAssets.getTexture("BgLayer" + layer));
				image1.blendMode = BlendMode.NONE;
				image2 = new Image(GameAssets.getTexture("BgLayer" + layer));
				image2.blendMode = BlendMode.NONE;
			}
			else
			{
				image1 = new Image(GameAssets.getAtlasTest().getTexture("bgLayer"+layer));
				image2 = new Image(GameAssets.getAtlasTest().getTexture("bgLayer"+layer));
				
			}
			
			image1.x = 0;
			image1.y = stage.stageHeight - image1.height;
			
			image2.x = image1.x + image1.width;
			image2.y = image1.y;
			
			this.addChild(image1);
			this.addChild(image2);
		}
		
		public function get parallax():Number
		{
			return _parallax;
		}
		
		public function set parallax(value:Number):void
		{
			_parallax = value;
		}

	}
	
}
