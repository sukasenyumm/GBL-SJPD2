package  {
	import flash.display.Sprite;
	import starling.core.Starling;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	//Konfigurasi embed meta tag untuk screen
	[SWF(frameRate="60", width="800", height="600", backgroundColor="0xFFFFFF")]
	public class Main extends Sprite{

		//deklarasi objek starling
		private var starlingObj:Starling;
		
		public function Main() {
			// constructor code
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			var viewPort:Rectangle = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);

			// inisialisasi starling object
			starlingObj = new Starling(GameRoot, stage, viewPort);
			
			//main configs
			starlingObj.stage.stageWidth  = viewPort.width / 1.2;
			starlingObj.stage.stageHeight = viewPort.height / 1.2;

			// Definisi anti-aliasing dasar
			starlingObj.antiAliasing = 1;
			
			// Lihat penggunaan status memory dan statistik CPU
			starlingObj.showStats = true;
			
			// Posisi status
			starlingObj.showStatsAt("left", "bottom");
			
			// Start Starling Framework.
			starlingObj.start();
		}

	}
	
}
