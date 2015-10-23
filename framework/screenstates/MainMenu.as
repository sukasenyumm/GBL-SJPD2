package framework.screenstates
{
	import starling.display.Sprite;
	import starling.display.Image;
	import framework.utils.GameAssets;
	import starling.display.BlendMode;
	import starling.events.Event;
	import starling.display.Button;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import framework.quiz.QuizQuestion;
	import flash.text.TextFieldAutoSize;
	import starling.animation.Tween;
	import starling.animation.Transitions;
	import starling.core.Starling;
	import framework.events.NavigationEvent;
	import framework.utils.SaveManager;
	import starling.display.Quad;
	import feathers.themes.MetalWorksMobileTheme;
	import feathers.controls.Alert;
	import feathers.data.ListCollection;
	import framework.gameobject.Hero;
	import framework.gameobject.Enemy;
	import flash.media.SoundMixer;
	
	
	/**
	 * This is the welcome or main menu class for the game.
	 *  
	 * @author hsharma
	 * 
	 */
	public class MainMenu extends Sprite
	{
		/** Background image. */
		private var bg:Image;
		/** Game title. */
		private var title:Image;
		/** hero */
		private var hero:Hero;
		/** enemy */
		private var enemy:Enemy;
		/** About button. */
		private var aboutBtn:Button;
		/** Items button. */
		private var itemsBtn:Button;
		/** Info button. */
		private var helpBtn:Button;
		/** Quiz button. */
		private var quizBtn:Button;
		/** Play button. */
		private var playBtn:Button;
		/** Back button. */
		private var backBtn:Button;
		/** Screen mode - "welcome" or "about". */
		private var screenMode:String;
		/** About text field. */
		private var aboutText:TextField;
		/** Quiz Tilte text field. */
		private var quizText:TextField;
		/** Quiz Keterangan text field. */
		private var ketText:TextField;
		
		/* for quiz declaration */
		private var quizBg:Quad;
		//for managing questions:
        private var quizQuestions:Array;
        private var currentQuestion:QuizQuestion;
        private var currentIndex:int = 0;
        //the buttons:
        private var prevButton:Button;
        private var nextButton:Button;
        private var finishButton:Button;
        //scoring and messages:
        private var score:int = 0;
        private var statusT:TextField;
		/*end quiz declaration */
		
		/*animation*/
		private var tweenHero:Tween;
		/*animation*/
		private var tweenEnemy:Tween;
		/** Current date. */
		private var _currentDate:Date;
		/*end animation*/
		
		private var bgInfo:Image;
		
		public function MainMenu()
		{
			super();
			new MetalWorksMobileTheme();
			this.visible = false;
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
			
			drawScreen();
		}
		
		/**
		 * Draw all the screen elements. 
		 * 
		 */
		private function drawScreen():void
		{
			// GENERAL ELEMENTS
			var bottomColor:uint = 0xFFFFFF; // white
			var topColor:uint    = 0xea0b0b; // red	
			
			bg = new Image(GameAssets.getTexture("BgMenu"));
			bg.width = stage.stageWidth;
			bg.height = stage.stageHeight;
			bg.blendMode = BlendMode.NONE;
			this.addChild(bg);
			
			bg.setVertexColor(0, topColor);
			bg.setVertexColor(1, topColor);
			bg.setVertexColor(2, bottomColor);
			bg.setVertexColor(3, bottomColor);
			
			hero = new Hero();
			hero.width = hero.width;
			hero.width = hero.height;
			this.addChild(hero);
			
			enemy = new Enemy();
			enemy.width = enemy.width;
			enemy.width = enemy.height;
			this.addChild(enemy);
			
			title = new Image(GameAssets.getAtlasFix().getTexture("lbl_title"));
			title.x = stage.stageWidth/14;
			title.y = stage.stageHeight/14;
			this.addChild(title);
			
			// ABOUT ELEMENTS
			//fontRegular = Fonts.getFont("Regular");
			
			aboutText = new TextField(stage.stageWidth - stage.stageWidth/14, stage.stageHeight -  stage.stageHeight/14, "", "nulshock", 10, 0xffffff);
			aboutText.text = "PESAWAT INSULINDE\n(Sejarah Indonesia 1942-1949)\n\nPESAWAT INSULINDE adalah sebuah game untuk mempelajari Sejarah Indonesia.\n\n" +
				" Pesawat Insulinde bertugas untuk mengejar pesawat X yang telah mencuri lembaran-lembaran sejarah yang ada di Indonesia." +
				" Dalam perjalanannya, pesawat X tadi menjatuhkan lembaran-lembaran sejarah disepanjang jalan." +
				" Jangan lupa kumpulkan juga batu pengetahuan untuk membuka sesi quiz pada menu game.\n\n"+
				" Game ini diciptakan oleh:\n"+
				" Abas Setiawan (Produser dan Programmer)\n"+
				" Muhammad Yusuf Priambodo (Desainer dan Ilustrator)\n"+
				" Copyright @2015";
			aboutText.x = stage.stageWidth/2 - aboutText.textBounds.width/2;
			aboutText.y = stage.stageHeight/2 - aboutText.textBounds.height/2;
			aboutText.hAlign = HAlign.CENTER;
			aboutText.vAlign = VAlign.TOP;
			//aboutText.border = true;
			this.addChild(aboutText);
			
			/* play button*/
			playBtn = new Button(GameAssets.getAtlasFix().getTexture("btn_play"));
			playBtn.x = stage.stageWidth/2 + playBtn.width;
			playBtn.y = stage.stageHeight/2 - playBtn.height/2;
			playBtn.addEventListener(Event.TRIGGERED, onPlayClick);
			this.addChild(playBtn);
			
			/* back button */
			backBtn = new Button(GameAssets.getAtlasFix().getTexture("btn_home"));
			backBtn.x = (stage.stageWidth/14);
			backBtn.y = stage.stageHeight - (stage.stageHeight/14) - backBtn.height;
			backBtn.addEventListener(Event.TRIGGERED, onAboutBackClick);
			this.addChild(backBtn);
			
			/* help button */
			helpBtn = new Button(GameAssets.getAtlasFix().getTexture("btn_info"));
			helpBtn.x = stage.stageWidth - helpBtn.width/2 - (stage.stageWidth/14) - helpBtn.width/2;
			helpBtn.y = stage.stageHeight - (stage.stageHeight/14) - helpBtn.height;
			helpBtn.addEventListener(Event.TRIGGERED, onHelpClick);
			this.addChild(helpBtn);
			
			
			/* about button */
			aboutBtn = new Button(GameAssets.getAtlasFix().getTexture("btn_credits"));
			aboutBtn.x = helpBtn.x-(stage.stageHeight/20)-aboutBtn.height;
			aboutBtn.y = helpBtn.y;
			aboutBtn.addEventListener(Event.TRIGGERED, onAboutClick);
			this.addChild(aboutBtn);
			
			/* items button */
			itemsBtn = new Button(GameAssets.getAtlasFix().getTexture("btn_item"));
			itemsBtn.x = aboutBtn.x-(stage.stageHeight/20)-itemsBtn.height;
			itemsBtn.y = helpBtn.y;
			itemsBtn.addEventListener(Event.TRIGGERED, onItemsClick);
			this.addChild(itemsBtn);
			
			/* quiz teks */
			quizText = new TextField(stage.stageWidth, 50, "", "nulshock", 20, 0xFFFFFF);
			quizText.text = "KUIS";
			quizText.x = stage.stageWidth/2-quizText.width/2;
			quizText.y = (stage.stageHeight/14);
			this.addChild(quizText);
			
			ketText = new TextField(stage.stageWidth, 50, "", "nulshock", 20, 0xFFFFFF);
			ketText.text = "KETERANGAN";
			ketText.x = stage.stageWidth/2-ketText.width/2;
			ketText.y = (stage.stageHeight/14);
			this.addChild(ketText);
			
			quizBtn = new Button(GameAssets.getAtlasFix().getTexture("btn_quiz"));
			quizBtn.x = itemsBtn.x-(stage.stageHeight/20)-quizBtn.height;
			quizBtn.y = helpBtn.y;
			quizBtn.addEventListener(Event.TRIGGERED, onQuizClick);
			this.addChild(quizBtn);
			
			bgInfo = new Image(GameAssets.getTexture("BgHelper"));
			bgInfo.width = stage.stageWidth;
			bgInfo.height = stage.stageHeight - (stage.stageHeight/14)*2 - backBtn.height*2;
			bgInfo.y = stage.stageHeight/2 - bgInfo.height/2;
			this.addChild(bgInfo);
			
			/* quiz button */
			quizBg = new Quad(stage.stageWidth, stage.stageHeight - (stage.stageHeight/14)*2 - backBtn.height*2, 0x1A0000);
			quizBg.y = stage.stageHeight/2-quizBg.height/2;
			quizBg.alpha = 0.5;
			this.addChild(quizBg);
			
			var yPosition:Number = backBtn.y - 10;
	
			nextButton = new Button(GameAssets.getAtlasFix().getTexture("btn_selanjutnya"));
            nextButton.x = stage.stageWidth/2 - nextButton.width/2;
            nextButton.y = yPosition - nextButton.height;
            nextButton.addEventListener(Event.TRIGGERED, nextHandler);
            this.addChild(nextButton);
			
			
			prevButton = new Button(GameAssets.getAtlasFix().getTexture("btn_sebelumnya"));
			prevButton.x = nextButton.x - nextButton.width - 50;
			prevButton.y = yPosition- prevButton.height;
			prevButton.addEventListener(Event.TRIGGERED, prevHandler);
			this.addChild(prevButton);

            finishButton = new Button(GameAssets.getAtlasFix().getTexture("btn_selesai"));
			finishButton.x = nextButton.x + nextButton.width + 50;
            finishButton.y = yPosition- finishButton.height;
            finishButton.addEventListener(Event.TRIGGERED, finishHandler);
            this.addChild(finishButton);
			
			//statusT = new TextField(480, 600, "", fontRegular.fontName, fontRegular.fontSize, 0xffffff);
			statusT = new TextField(stage.stageWidth, stage.stageHeight/4, "", "nulshock", 14, 0xffffff);
			statusT.x = stage.stageWidth/2 - statusT.width/2;
			statusT.y = stage.stageHeight/2 - statusT.height/2;
			statusT.hAlign = HAlign.CENTER;
			statusT.vAlign = VAlign.TOP;
			//statusT.border = true;
			this.addChild(statusT);
			statusT.visible = false;
			
			quizQuestions = new Array();
            createQuestions();
			/* end quiz button */
			
		}
		
		private function onPlayClick(event:Event):void
		{
			screenMode = "play";
			if (!Sounds.muted) Sounds.sndCoffee.play();
			this.dispatchEvent(new NavigationEvent(NavigationEvent.SWITCH_STATE, {id: "level"},true));
		}
		
		private function onItemsClick(event:Event):void
		{
			screenMode = "about";
			if (!Sounds.muted) Sounds.sndCoffee.play();
			this.dispatchEvent(new NavigationEvent(NavigationEvent.SWITCH_STATE, {id: "items"},true));
		}
		
		private function onQuizClick(event:Event):void
		{
			screenMode = "about";
			if (!Sounds.muted) Sounds.sndCoffee.play();
			if(int(SaveManager.getInstance().loadDataScore()) > 1000000)
				showQuiz();
			else
			{
				var alert:Alert = Alert.show("Belum bisa dibuka!! Kumpulkan skor akumulasi sebanyak lebih dari 1.000.000. Skor akumulasi sekarang: "+String(SaveManager.getInstance().loadDataScore()), "Peringatan", new ListCollection(
				[
					{ label: "OK"}
				]) );
				alert.addEventListener( Event.CLOSE, alert_closeHandler );
			}
		}
		
		private function onAboutClick(event:Event):void
		{
			if (!Sounds.muted) Sounds.sndCoffee.play();
			showMessage("");
			showAbout();
		}
		
		private function onHelpClick(event:Event):void
		{
			if (!Sounds.muted) Sounds.sndCoffee.play();
			showMessage("");
			showInfo();
		}
		
		private function onAboutBackClick(event:Event):void
		{
			if (!Sounds.muted) Sounds.sndMushroom.play();
			showMessage("");
			initialize();
		}
		
		public function showInfo():void
		{
			screenMode = "about";
			ketText.visible = true;
			title.visible = false;
			bgInfo.visible = true;
			hero.visible = false;
			enemy.visible = false;
			playBtn.visible = false;
			aboutBtn.visible = false;
			helpBtn.visible = false;
			aboutText.visible = false;
			backBtn.visible = true;
			quizBtn.visible = false;
			itemsBtn.visible = false;
		}
		
		
		public function showAbout():void
		{
			screenMode = "about";
			title.visible = false;
			ketText.visible = false;
			bgInfo.visible = false;
			hero.visible = false;
			enemy.visible = false;
			playBtn.visible = false;
			aboutBtn.visible = false;
			helpBtn.visible = false;
			aboutText.visible = true;
			backBtn.visible = true;
			quizBtn.visible = false;
			itemsBtn.visible = false;
		}
		
		public function showQuiz():void
		{
			screenMode = "about";
			bgInfo.visible = false;
			quizBg.visible = true;
			quizText.visible = true;
			ketText.visible = false;
			hero.visible = false;
			enemy.visible = false;
			title.visible = false;
			playBtn.visible = false;
			helpBtn.visible = false;
			backBtn.visible = true;
			aboutBtn.visible = false;
            prevButton.visible = true;
			nextButton.visible =true;
			finishButton.visible = true;
			quizBtn.visible = false;
			itemsBtn.visible = false;
			addAllQuestions();
            hideAllQuestions();
            firstQuestion();
		}
		

		public function initialize():void
		{
			disposeTemporarily();		
			this.visible = true;
			
			////trace(screenMode)
			// If not coming from about, restart playing background music.
			if (screenMode != "about")
			{
				if (!Sounds.muted) Sounds.sndBgMain.play(0, 999);
			}
			
			statusT.visible = false;
			bgInfo.visible = false;
			quizBg.visible = false;
			this.visible = true;
			title.visible = true;
			hero.visible = true;
			enemy.visible = true;
			aboutText.visible = false;
			quizText.visible = false;
			backBtn.visible = false;
			aboutBtn.visible = true;
			playBtn.visible = true;
			quizBtn.visible = true;
			helpBtn.visible = true;
			prevButton.visible = false;
			nextButton.visible =false;
			finishButton.visible = false;
			itemsBtn.visible = true;
			ketText.visible = false;
			
			hideAllQuestions();
			
			//animation
			hero.x = -hero.width;
			hero.y = stage.stageWidth/2-hero.height;
			
			enemy.x = -enemy.width;
			enemy.y = hero.y-enemy.height*2;
			
			tweenHero = new Tween(hero, 2, Transitions.EASE_OUT);
			tweenHero.animate("x", stage.stageWidth/4);
			Starling.juggler.add(tweenHero);
			Starling.juggler.removeTweens(tweenHero);
			
			tweenEnemy = new Tween(enemy, 2, Transitions.EASE_OUT);
			tweenEnemy.animate("x", stage.stageWidth/2);
			Starling.juggler.add(tweenEnemy);
			Starling.juggler.removeTweens(tweenEnemy);
			
			this.addEventListener(Event.ENTER_FRAME, floatingAnimation);
		}
		
		/**
		 * Animate floating objects. 
		 * @param event
		 * 
		 */
		private function floatingAnimation(event:Event):void
		{
			_currentDate = new Date();
			hero.y = stage.stageWidth/2-hero.height+20 + (Math.cos(_currentDate.getTime() * 0.002)) * 25;
			enemy.y = hero.y-enemy.height*2+20 + (Math.cos(_currentDate.getTime() * 0.002)) * 25;
			playBtn.y = (stage.stageHeight/2 - playBtn.height/2) + (Math.cos(_currentDate.getTime() * 0.002)) * 10;
		}
		
		/**
		 * Dispose objects temporarily. 
		 * 
		 */
		public function disposeTemporarily():void
		{
			this.visible = false;
			if(this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME,floatingAnimation);
			
			if (screenMode != "about") SoundMixer.stopAll();
		}
		
		/* quiz only here
		*
		*/
		 private function createQuestions() {
			score = 0;
            quizQuestions.push(new QuizQuestion(stage.stageWidth/2,"Didaerah mana pertama kali tentara jepang menduduki Indonesia?",
                                                            2,
                                                            "Semarang",
                                                            "Solo",
                                                            "Tarakan"));
            quizQuestions.push(new QuizQuestion(stage.stageWidth/2,"Kapan pemerintah Hindia Belanda menyerah tanpa syarat kepada Jepang?",
                                                            1,
                                                            "8 Januari 1942",
                                                            "8 Maret 1942",
                                                            "17 Agustus 1945"));
           quizQuestions.push(new QuizQuestion(stage.stageWidth/2,"Disebut apakah peristiwa penculikan Soekarno dan Hatta oleh sejumlah pemuda?",
                                                            0,
                                                            "Peristiwa Reangasdengklok",
                                                            "Agresi Militer 1",
                                                            "Agresi Militer 2"));
            quizQuestions.push(new QuizQuestion(stage.stageWidth/2,"Kapan Soekarno dan Hatta memproklamasikan kemerdekaan Indonesia?",
                                                            0,
                                                            "17 Agustus 1945",
                                                            "18 Agustus 1945",
                                                            "5 Agustus 1945"));
			 quizQuestions.push(new QuizQuestion(stage.stageWidth/2,"Kapan Belanda melancarkan agresi militer keduanya?",
                                                            2,
                                                            "21 Juli-5 Agustus 1947",
                                                            "5 Juli-21 Agustus 1947",
                                                            "19 Desember 1948-5 Januari 1949"));
            quizQuestions.push(new QuizQuestion(stage.stageWidth/2,"Dimanakah tempat berlangsungnya Konferensi Meja Bundar?",
                                                            1,
                                                            "Jakarta, Indonesia",
                                                            "Den Haag, Belanda",
                                                            "Amsterdam, Belanda"));
        }
		
   
        private function showMessage(theMessage:String) {
			statusT.visible = true;
            statusT.text = theMessage;
            statusT.x = stage.stageWidth/2 - statusT.width/2;
			statusT.y = stage.stageHeight/2 - statusT.height/2;
        }
		
        private function addAllQuestions() {
            for(var i:int = 0; i < quizQuestions.length; i++) {
				//quizQuestions[i].x = stage.stageWidth/2 - quizQuestions[i].width/2;
				quizQuestions[i].y = stage.stageHeight/14+stage.stageHeight/14 + 5;
                this.addChild(quizQuestions[i]);
            }
        }
        private function hideAllQuestions() {
            for(var i:int = 0; i < quizQuestions.length; i++) {
                quizQuestions[i].visible = false;
            }
        }
        private function firstQuestion() {
            currentQuestion = quizQuestions[0];
            currentQuestion.visible = true;
        }
        private function prevHandler(event:Event) {
			if (!Sounds.muted) Sounds.sndMushroom.play();
            if(currentIndex > 0) {
                currentQuestion.visible = false;
                currentIndex--;
                currentQuestion = quizQuestions[currentIndex];
                currentQuestion.visible = true;
            } else {
               // showMessage("sebelumnya");
            }
        }
        private function nextHandler(event:Event) {
			if (!Sounds.muted) Sounds.sndMushroom.play();
            if(currentQuestion.userAnswer < 0) {
                return;
            }
            if(currentIndex < (quizQuestions.length - 1)) {
                currentQuestion.visible = false;
                currentIndex++;
                currentQuestion = quizQuestions[currentIndex];
                currentQuestion.visible = true;
            } else {
               var alert:Alert = Alert.show("Semua pertanyaan telah dijawab! Lihat jawaban sebelumnya atau tekan selesai!", "Peringatan", new ListCollection(
				[
					{ label: "OK"}
				]) );
				alert.addEventListener( Event.CLOSE, alert_closeHandler );
            }
        }
        private function finishHandler(event:Event) {
			if (!Sounds.muted) Sounds.sndMushroom.play();
            var finished:Boolean = true;
            for(var i:int = 0; i < quizQuestions.length; i++) {
                if(quizQuestions[i].userAnswer == 0) {
                    finished = false;
                    break;
                }
            }
			if(finished || currentIndex == quizQuestions.length -1) {
                prevButton.visible = false;
                nextButton.visible = false;
                finishButton.visible = false;
                hideAllQuestions();
                computeScore();
				score = 0;
				currentIndex = 0;
				finished = false;
            } else {
                var alert:Alert = Alert.show("Selesaikan semua soal dahulu!", "Peringatan", new ListCollection(
				[
					{ label: "OK"}
				]) );
				alert.addEventListener( Event.CLOSE, alert_closeHandler );
            }
        }
		
		private function alert_closeHandler( event:Event, data:Object ):void
		{
			if( data.label == "OK" )
			{
				// the OK button was clicked
			}
		}
		
        private function computeScore() {
            for(var i:int = 0; i < quizQuestions.length; i++) {
                if(quizQuestions[i].userAnswer == quizQuestions[i].correctAnswer) {
                    score++;
					if(score == quizQuestions.length)
						SaveManager.getInstance().saveDataGodlike(true);
                }
            }
			if(score==quizQuestions.length)
            	showMessage("\n\nSELAMAT!!\n\nKamu berhasil menjawab " + score + " soal dari " + quizQuestions.length +" soal.\nKamu mendapatkan 'AURA KEMERDEKAAN', mainkan game dan lihat apa yang terjadi.");
			else
				showMessage("\n\nSELAMAT!!\n\nKamu berhasil menjawab " + score + " soal dari " + quizQuestions.length +" soal.\nCoba terus untuk mendapatkan 'AURA KEMERDEKAAN' pada Pesawat Insulinde!");
			////trace("You answered " + score + " correct out of " + quizQuestions.length + " questions.")
        }
		
		/*end quiz here*/
	
	}
}