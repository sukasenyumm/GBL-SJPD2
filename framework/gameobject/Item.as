package framework.gameobject {
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.display.MovieClip;
	import framework.utils.GameAssets;
	import starling.core.Starling;
	import starling.display.Image;
	
	public class Item extends Sprite{

		private var _foodItemType:int;
		private var itemImage:Image;
		public function Item(_foodItemType:int) {
			// constructor code
			super();
			this.foodItemType = _foodItemType;
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		public function get foodItemType():int
		{
			return _foodItemType;
		}
		
		public function set foodItemType(value:int):void
		{
			_foodItemType = value;
			itemImage = new Image(GameAssets.getAtlasFix().getTexture("item" + _foodItemType));
			itemImage.x = itemImage.texture.width * 0.5;
			itemImage.y = itemImage.texture.height * 0.5;
			this.addChild(itemImage);
		}
	}
	
}
