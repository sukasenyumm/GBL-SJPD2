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
		private var level:int;
		
		public function BgLayer(nlayer:int,mlevel:int) {
			// constructor code
			super();
			level = mlevel;
			this.layer = nlayer;
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			if(level == 1)
			{
				if(layer == 1)
				{
					image1 = new Image(GameAssets.getTexture("BgLayerExt" + layer));
					image1.blendMode = BlendMode.NONE;
					image2 = new Image(GameAssets.getTexture("BgLayerExt" + layer));
					image2.blendMode = BlendMode.NONE;
					var bottomColor1:uint = 0x000000; // white
					var topColor1:uint    = 0x0000CC; // red	
					image1.setVertexColor(0, topColor1);
					image1.setVertexColor(1, topColor1);
					image1.setVertexColor(2, bottomColor1);
					image1.setVertexColor(3, bottomColor1);
					image2.setVertexColor(0, topColor1);
					image2.setVertexColor(1, topColor1);
					image2.setVertexColor(2, bottomColor1);
					image2.setVertexColor(3, bottomColor1);
				}
				else
				{
					image1 = new Image(GameAssets.getAtlasFix().getTexture("bgLayerExt"+layer));
					image2 = new Image(GameAssets.getAtlasFix().getTexture("bgLayerExt"+layer));
					
				}
			}
			else if(level == 2)
			{
				if(layer == 1)
				{
					image1 = new Image(GameAssets.getTexture("BgLayer" + layer));
					image1.blendMode = BlendMode.NONE;
					image2 = new Image(GameAssets.getTexture("BgLayer" + layer));
					image2.blendMode = BlendMode.NONE;
					var bottomColor2:uint = 0x000066;
					var topColor2:uint    = 0xCCCCFF;
					image1.setVertexColor(0, topColor2);
					image1.setVertexColor(1, topColor2);
					image1.setVertexColor(2, bottomColor2);
					image1.setVertexColor(3, bottomColor2);
					image2.setVertexColor(0, topColor2);
					image2.setVertexColor(1, topColor2);
					image2.setVertexColor(2, bottomColor2);
					image2.setVertexColor(3, bottomColor2);
				}
				else
				{
					image1 = new Image(GameAssets.getAtlasFix().getTexture("bgLayer"+layer));
					image2 = new Image(GameAssets.getAtlasFix().getTexture("bgLayer"+layer));
					
				}
			}
			else if(level == 3)
			{
				if(layer == 1)
				{
					image1 = new Image(GameAssets.getTexture("BgLayerEx" + layer));
					image1.blendMode = BlendMode.NONE;
					image2 = new Image(GameAssets.getTexture("BgLayerEx" + layer));
					image2.blendMode = BlendMode.NONE;
					var bottomColor3:uint = 0xFFFFFF; // white
					var topColor3:uint    = 0xea0b0b; // red	
					image1.setVertexColor(0, topColor3);
					image1.setVertexColor(1, topColor3);
					image1.setVertexColor(2, bottomColor3);
					image1.setVertexColor(3, bottomColor3);
					image2.setVertexColor(0, topColor3);
					image2.setVertexColor(1, topColor3);
					image2.setVertexColor(2, bottomColor3);
					image2.setVertexColor(3, bottomColor3);
				}
				else
				{
					image1 = new Image(GameAssets.getAtlasFix().getTexture("bgLayerEx"+layer));
					image2 = new Image(GameAssets.getAtlasFix().getTexture("bgLayerEx"+layer));
					
				}
			}
			else
			{
				if(layer == 1)
				{
					image1 = new Image(GameAssets.getTexture("BgLayer" + layer));
					image1.blendMode = BlendMode.NONE;
					image2 = new Image(GameAssets.getTexture("BgLayer" + layer));
					image2.blendMode = BlendMode.NONE;
				}
				else
				{
					image1 = new Image(GameAssets.getAtlasFix().getTexture("bgLayer"+layer));
					image2 = new Image(GameAssets.getAtlasFix().getTexture("bgLayer"+layer));
					
				}
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
