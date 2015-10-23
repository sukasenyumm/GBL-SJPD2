package  {
	import flash.display.Sprite;
	import starling.core.Starling;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import framework.events.TimelineEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	
	
	//Konfigurasi embed meta tag untuk screen
	[SWF(backgroundColor="0x000000")]
	
	public class Main extends Sprite{

		//deklarasi objek starling
		private var starlingObj:Starling;
		private var splashScreenMc:SplashScreen;
		private var intro:Introduction;
		private var preloader:LoaderGame;
		private var btnSkip:SkipBtn;
		
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
			intro = new Introduction();
			this.addChild(intro);
			intro.x = stage.stageWidth/2;
			intro.y = stage.stageHeight/2;
			intro.play();
			intro.addEventListener(TimelineEvent.LAST_FRAME, onGame2);
			
			btnSkip = new SkipBtn();
			btnSkip.x = stage.stageWidth - btnSkip.width/2 - (stage.stageWidth/14) - btnSkip.width/2;
			btnSkip.y = stage.stageHeight - (stage.stageHeight/14) - btnSkip.height;
			this.addChild(btnSkip);
			btnSkip.addEventListener(MouseEvent.CLICK, onClicked);
			
			this.stage.frameRate = 13;
			 
		}
		private function onClicked(e:MouseEvent):void 
		{
			btnSkip.removeEventListener(MouseEvent.CLICK, onClicked);
			this.removeChild(btnSkip);
			IntroToStop();
		}
		
		private function IntroToStop():void
		{
			if (btnSkip.hasEventListener(MouseEvent.CLICK)) 
			{
				btnSkip.removeEventListener(MouseEvent.CLICK, onClicked);
				this.removeChild(btnSkip);
			}
			
			intro.stop();
			intro.removeEventListener(TimelineEvent.LAST_FRAME, onGame);
			this.removeChild(intro);
			this.stage.frameRate = 60;
			preloader = new LoaderGame();
			preloader.x = stage.fullScreenWidth/2 - preloader.width/2;
			preloader.y = stage.fullScreenHeight/2 - preloader.height/2;
		
			Starling.handleLostContext = true;
			var viewPort:Rectangle = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);

			// inisialisasi starling object
			starlingObj = new Starling(GameRoot, stage, viewPort);
			
			//main configs
			starlingObj.stage.stageWidth  = viewPort.width / 1.2;
			starlingObj.stage.stageHeight = viewPort.height / 1.2;

			// Definisi anti-aliasing dasar
			starlingObj.antiAliasing = 1;
			
			// Lihat penggunaan status memory dan statistik CPU
			//starlingObj.showStats = false;
			// Posisi status
			//starlingObj.showStatsAt("left", "bottom");
			
			// Start Starling Framework.
			starlingObj.start();
			
			starlingObj.nativeOverlay.addChild(preloader);
			// Wait Context3D
			starlingObj.stage3D.addEventListener(Event.CONTEXT3D_CREATE, context3DCreateHandler);
		
		}
		private function onGame2(e:TimelineEvent = null):void 
		{
			IntroToStop();
		}
		
		private function context3DCreateHandler(e:Event):void
		{
			starlingObj.stage3D.removeEventListener(Event.CONTEXT3D_CREATE, context3DCreateHandler);
		 
			// Start Starling
			starlingObj.start();
			// Remove loader
			if ((null != preloader) && (starlingObj.nativeOverlay.contains(preloader)))
			{
				starlingObj.nativeOverlay.removeChild(preloader);
				preloader = null;
			}
		}

	}
	
}
