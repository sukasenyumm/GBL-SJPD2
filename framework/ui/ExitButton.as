
package framework.ui
{
	import flash.display.BitmapData;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.Texture;
	import framework.utils.GameAssets;
	
	/**
	 * This class is the sound/mute button.
	 *  
	 * @author hsharma
	 * 
	 */
	public class ExitButton extends Button
	{
		/** Animation shown when sound is playing.  */
		private var image:Image;
		
		public function ExitButton()
		{
			super(Texture.fromBitmapData(new BitmapData(GameAssets.getAtlasFix().getTexture("btn_quit").width, GameAssets.getAtlasFix().getTexture("btn_quit").height, true, 0)));
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/**
		 * On added to stage. 
		 * @param event
		 * 
		 */
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			setButtonTextures();
		}
		
		/**
		 * Set textures for button states. 
		 * 
		 */
		private function setButtonTextures():void
		{
			// Normal state - image
			image = new Image(GameAssets.getAtlasFix().getTexture("btn_quit"));
			this.addChild(image);
		}
	}
}