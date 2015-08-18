
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
	public class SoundButton extends Button
	{
		/** Animation shown when sound is playing.  */
		private var mcUnmuteState:Image;
		
		/** Image shown when the sound is muted. */
		private var imageMuteState:Image;
		
		public function SoundButton()
		{
			super(Texture.fromBitmapData(new BitmapData(GameAssets.getAtlasFix().getTexture("btn_sound").width, GameAssets.getAtlasFix().getTexture("btn_sound").height, true, 0)));
			
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
			showUnmuteState();
		}
		
		/**
		 * Set textures for button states. 
		 * 
		 */
		private function setButtonTextures():void
		{
			// Normal state - image
			mcUnmuteState = new Image(GameAssets.getAtlasFix().getTexture("btn_sound"));
			this.addChild(mcUnmuteState);
			
			// Selected state - animation
			imageMuteState = new Image(GameAssets.getAtlasFix().getTexture("btn_sound"));
			this.addChild(imageMuteState);
		}
		
		/**
		 * Show Off State - Show the mute symbol (sound is muted). 
		 * 
		 */
		public function showUnmuteState():void
		{
			mcUnmuteState.visible = true;
			imageMuteState.visible = false;
		}
		
		/**
		 * Show On State - Show the unmute animation (sound is playing). 
		 * 
		 */
		public function showMuteState():void
		{
			mcUnmuteState.visible = false;
			imageMuteState.visible = true;
		}
	}
}