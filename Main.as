package  {
	import flash.display.Sprite;
	import starling.core.Starling;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import framework.events.TimelineEvent;
	
	//Konfigurasi embed meta tag untuk screen
	[SWF(backgroundColor="0x000000")]
	
	//[SWF(frameRate="60", width="800", height="600", backgroundColor="0xFFFFFF")]
	//[SWF(frameRate="60", width="1024", height="768", backgroundColor="0x000000")]
	public class Main extends Sprite{

		//deklarasi objek starling
		private var starlingObj:Starling;
		private var splashScreenMc:SplashScreen;
		
		public function Main() {
			// constructor code
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.stage.frameRate = 12;
			splashScreenMc = new SplashScreen();
			this.addChild(splashScreenMc);
			splashScreenMc.x = stage.stageWidth/2;
			splashScreenMc.y = stage.stageHeight/2;
			splashScreenMc.play();
			splashScreenMc.addEventListener(TimelineEvent.LAST_FRAME, onGame);
		}
		
		private function onGame(e:TimelineEvent = null):void 
		{
			splashScreenMc.stop();
			splashScreenMc.removeEventListener(TimelineEvent.LAST_FRAME, onGame);
			this.removeChild(splashScreenMc);
			this.stage.frameRate = 60;
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
