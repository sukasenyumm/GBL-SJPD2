package framework.screenstates
{

	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.VAlign;
	import framework.events.NavigationEvent;
	import framework.utils.GameAssets;
	
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.renderers.BaseDefaultItemRenderer;
	import feathers.controls.PageIndicator;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.TiledRowsLayout;
	import starling.display.Image;
	import starling.textures.Texture;
	import feathers.text.BitmapFontTextFormat;
	import starling.display.Button;
	import starling.events.TouchEvent;
	import feathers.controls.Alert;
	import framework.utils.SaveManager;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import feathers.themes.MetalWorksMobileTheme;
	import flash.media.SoundMixer;
	
	public class CollectItems extends Sprite
	{
		/** Background image. */
		private var bg:Quad;
		
		/** Main Menu button. */
		private var mainBtn:Button;
		
		private var _list:List;
		private var _pageIndicator:PageIndicator;
		private var layout:AnchorLayout;
		private var group:LayoutGroup;
		private var galeriInfo:TextField;
		private var _themes:MetalWorksMobileTheme;
		
		private var collection:ListCollection;
		
		
		public function CollectItems()
		{
			super();
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
			this._themes = new MetalWorksMobileTheme();
			this._themes.getStyleProviderForClass( DefaultListItemRenderer ).setFunctionForStyleName( "my-tile-renderer", myTileRenderer );
			drawChooseLevel();
		}
		
		/**
		 * Draw game over screen. 
		 * 
		 */
		private function drawChooseLevel():void
		{
			
			// Background quad.
			bg = new Quad(stage.stageWidth, stage.stageHeight, 0xFFFFFF);
			bg.alpha = 0.75;
			this.addChild(bg);
			bg.visible = false;
			
			
			// Navigation buttons.
			mainBtn = new Button(GameAssets.getAtlasFix().getTexture("btn_home"));
			mainBtn.x = (stage.stageWidth/14);
			mainBtn.y = stage.stageHeight - (stage.stageHeight/14) - mainBtn.height;
			mainBtn.addEventListener(Event.TRIGGERED, onMainClick);
			this.addChild(mainBtn);
			mainBtn.visible = false;
		
			galeriInfo = new TextField(stage.stageWidth, 50, "", "nulshock", 20, 0x000000);
			galeriInfo.text = "GALERI INFO";
			galeriInfo.x = stage.stageWidth/2-galeriInfo.width/2;
			galeriInfo.y = (stage.stageHeight/14);
			this.addChild(galeriInfo);
			galeriInfo.visible = false;
			
			//a nice, fluid layout
			group = new LayoutGroup();
    
			layout = new AnchorLayout();
			group.y = stage.stageHeight/6;
			group.width = stage.stageWidth;
			group.height = stage.stageHeight - stage.stageHeight/6;
			
			
			group.autoSizeMode = LayoutGroup.AUTO_SIZE_MODE_STAGE;
			
			var pageIndicatorNormalSymbol:Texture = GameAssets.getTexture("scrollIdle");
			var pageIndicatorSelectedSymbol:Texture = GameAssets.getTexture("scrollOn");

			//the page indicator can be used to scroll the list
			this._pageIndicator = new PageIndicator();
			this._pageIndicator.pageCount = 1;
			this._pageIndicator.normalSymbolFactory = function():Image
			{
				return new Image(pageIndicatorNormalSymbol);
			}
			this._pageIndicator.selectedSymbolFactory = function():Image
			{
				return new Image(pageIndicatorSelectedSymbol);
			}
			this._pageIndicator.direction = PageIndicator.DIRECTION_HORIZONTAL;
			this._pageIndicator.gap = 4;
			this._pageIndicator.padding = 6;

			//we listen to the change event to update the list's scroll position
			this._pageIndicator.addEventListener(Event.CHANGE, pageIndicator_changeHandler);

			//we'll position the page indicator on the bottom and stretch its
			//width to fill the container's width
			var pageIndicatorLayoutData:AnchorLayoutData = new AnchorLayoutData();
			pageIndicatorLayoutData.bottom = 100;
			pageIndicatorLayoutData.left = 0;
			pageIndicatorLayoutData.right = 0;
			this._pageIndicator.layoutData = pageIndicatorLayoutData;

			group.addChild(this._pageIndicator);

			
			
			this._list = new List();
			this._list.snapToPages = true;
			this._list.scrollBarDisplayMode = List.SCROLL_BAR_DISPLAY_MODE_NONE;
			this._list.horizontalScrollPolicy = List.SCROLL_POLICY_ON;
			this._list.itemRendererFactory = tileListItemRendererFactory;

			//we listen to the scroll event to update the page indicator
			this._list.addEventListener(Event.SCROLL, list_scrollHandler);
			this._list.addEventListener(Event.CHANGE, onItemClicked);
			
			//this is the list's layout...
			var listLayout:TiledRowsLayout = new TiledRowsLayout();
			listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			listLayout.useSquareTiles = false;
			listLayout.tileHorizontalAlign = TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER;
			listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.padding = 2;
			listLayout.gap = 2;
			this._list.layout = listLayout;
			group.layout = layout;
			this.addChild( group );
			group.visible = false;

			//...while this is the layout data used by the list's parent
			var listLayoutData:AnchorLayoutData = new AnchorLayoutData();
			listLayoutData.top = 0;
			listLayoutData.right = 0;
			listLayoutData.bottom = 0;
			listLayoutData.bottomAnchorDisplayObject = this._pageIndicator;
			listLayoutData.left = 0;
			//this list fills the container's width and the remaining height
			//above the page indicator
			this._list.layoutData = listLayoutData;

			group.addChild(this._list);	
			
		}
		
		/**
		 * On main menu button click. 
		 * @param event
		 * 
		 */
		private function onMainClick(event:Event):void
		{
			if (!Sounds.muted) Sounds.sndMushroom.play();
			this.dispatchEvent(new NavigationEvent(NavigationEvent.SWITCH_STATE, {id: "mainMenu"}, true));
		}
		
		/**
		 * Initialize Game Over container. 
		 * @param _score
		 * @param _distance
		 * 
		 */
		public function initialize():void
		{
			disposeTemporarily();
			this.visible = true;
			bg.visible = true;
			mainBtn.visible = true;
			galeriInfo.visible = true;
			group.visible = true;
			
			//the data that will be displayed in the list
			collection = new ListCollection(
			[
				{ label: (SaveManager.getInstance().loadGalInfo(1) == 1)?"Tugu Perabuan ":"Terkunci", texture: (SaveManager.getInstance().loadGalInfo(1) == 1)?GameAssets.getAtlasFix().getTexture("P1-1"):GameAssets.getAtlasFix().getTexture("P0") },
				{ label: (SaveManager.getInstance().loadGalInfo(2) == 1)?"Belanda Menyerah ":"Terkunci", texture: (SaveManager.getInstance().loadGalInfo(2) == 1)?GameAssets.getAtlasFix().getTexture("P1-2"):GameAssets.getAtlasFix().getTexture("P0") },
				{ label: (SaveManager.getInstance().loadGalInfo(3) == 1)?"Semboyan Jepang ":"Terkunci", texture: (SaveManager.getInstance().loadGalInfo(3) == 1)?GameAssets.getAtlasFix().getTexture("P1-3"):GameAssets.getAtlasFix().getTexture("P0") },
				{ label: (SaveManager.getInstance().loadGalInfo(4) == 1)?"Garuda Pancasila ":"Terkunci", texture: (SaveManager.getInstance().loadGalInfo(4) == 1)?GameAssets.getAtlasFix().getTexture("P2-1"):GameAssets.getAtlasFix().getTexture("P0") },
				{ label: (SaveManager.getInstance().loadGalInfo(5) == 1)?"Rengasdengklok ":"Terkunci", texture: (SaveManager.getInstance().loadGalInfo(5) == 1)?GameAssets.getAtlasFix().getTexture("P2-2"):GameAssets.getAtlasFix().getTexture("P0") },
				{ label: (SaveManager.getInstance().loadGalInfo(6) == 1)? "Naskah Proklamasi ":"Terkunci", texture: (SaveManager.getInstance().loadGalInfo(6) == 1)?GameAssets.getAtlasFix().getTexture("P2-3"):GameAssets.getAtlasFix().getTexture("P0") },
				{ label: (SaveManager.getInstance().loadGalInfo(7) == 1)? "Sidang PPKI ":"Terkunci", texture: (SaveManager.getInstance().loadGalInfo(7) == 1)?GameAssets.getAtlasFix().getTexture("P2-4"):GameAssets.getAtlasFix().getTexture("P0") },
				{ label: (SaveManager.getInstance().loadGalInfo(8) == 1)? "Agresi Belanda I ":"Terkunci", texture: (SaveManager.getInstance().loadGalInfo(8) == 1)?GameAssets.getAtlasFix().getTexture("P3-1"):GameAssets.getAtlasFix().getTexture("P0") },
				{ label: (SaveManager.getInstance().loadGalInfo(9) == 1)?"Agresi Belanda II ":"Terkunci", texture: (SaveManager.getInstance().loadGalInfo(9) == 1)?GameAssets.getAtlasFix().getTexture("P3-2"):GameAssets.getAtlasFix().getTexture("P0") },
				{ label: (SaveManager.getInstance().loadGalInfo(10) == 1)?"Konferensi Meja Bundar ":"Terkunci", texture: (SaveManager.getInstance().loadGalInfo(10) == 1)?GameAssets.getAtlasFix().getTexture("P3-3"):GameAssets.getAtlasFix().getTexture("P0") },
			]);
			this._list.dataProvider = collection;
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
			//if (!Sounds.muted) SoundMixer.stopAll();
		}
		
		private function tileListItemRendererFactory():IListItemRenderer
		{
			var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			//renderer.labelField = "label";
			renderer.iconSourceField = "texture";
			renderer.nameList.add("my-tile-renderer");
			renderer.width = 300;
			return renderer;
		}

		private function myTileRenderer(renderer:BaseDefaultItemRenderer):void
		{
			const defaultSkin:Quad = new Quad(stage.stageWidth, stage.stageHeight, 0x1a1a1a);
			renderer.defaultSkin = defaultSkin;
			renderer.defaultSelectedSkin = defaultSkin;
			
			var tf:TextFormat = new TextFormat("nulshock", 18, 0xFFFFFF);
			tf.align = TextFormatAlign.CENTER;
			renderer.defaultLabelProperties.textFormat = tf;
			renderer.downLabelProperties.textFormat = tf;
			renderer.defaultSelectedLabelProperties.textFormat = tf;
			renderer.iconPosition = feathers.controls.Button.ICON_POSITION_TOP;
			renderer.horizontalAlign = feathers.controls.Button.HORIZONTAL_ALIGN_CENTER;
			
		}

		private function onItemClicked(event:Event):void
		{
			var p_List:List  = List (event.currentTarget);
    		//trace("selected item:", p_List.selectedIndex);
			if( p_List.selectedIndex == 0)
			{
				if(SaveManager.getInstance().loadGalInfo(1) == 1)
				{
					var alert1:Alert = Alert.show( "Tugu perabuan Jepang terletak di jalan Markoni Gg.III dengan jarak 4 km dari pusat Kota Tarakan (Kalimantan), tugu ini merupakan saksi sejarah kehadiran orang-orang Jepang ini berbentuk segi empat pipih di lengkapi dengan tulisan kanji. Pertempuran Tarakan terjadi pada tanggal 11-12 Januari 1942. Meskipun Tarakan hanya pulau berawa-rawa kecil di Kalimantan timur laut di Hindia Belanda, tetapi terdapat 700 sumur minyak, penyulingan minyak dan lapangan udara, yang merupakan tujuan utama Kekaisaran Jepang dalam Perang Pasifik.", "Penjelasan", new ListCollection(
					[
						{ label: "OK"}
					]) );
					alert1.addEventListener( Event.CLOSE, alert_closeHandler );
				}
				else
				{
					var alert2:Alert = Alert.show( "Item masih terkunci.","Penjelasan", new ListCollection(
					[
						{ label: "OK"}
					]) );
					alert2.addEventListener( Event.CLOSE, alert_closeHandler );
				}
			}
			
			if( p_List.selectedIndex == 1)
			{
				if(SaveManager.getInstance().loadGalInfo(2) == 1)
				{
					var alert3:Alert = Alert.show( "Pada 1 Maret 1942, Tentara Jepang melancarkan serangan ke Pulau Jawa, setelah sebelumnya Angkatan Laut Jepang menghancurkan armada Sekutu dalam pertempuran sengit di Laut Jawa, yang dikenal sebagai The Battle of Java Sea. Setelah digempur selama satu pekan, tentara Belanda di Hindia-Belanda menyerah kepada tentara Jepang. Pada 8 Maret 1942 di Kalijati, dekat Subang, Jawa Barat, Ter Poorten (mewakili Gubernur Jenderal Hindia-Belanda, Jonkheer Alidus Warmmoldus Lambertus Tjarda van Starkenborgh-Stachouwer) menandatangani dokumen menyerah tanpa syarat.", "Penjelasan", new ListCollection(
					[
						{ label: "OK"}
					]) );
					alert3.addEventListener( Event.CLOSE, alert_closeHandler );
				}
				else
				{
					var alert4:Alert = Alert.show( "Item masih terkunci.","Penjelasan", new ListCollection(
					[
						{ label: "OK"}
					]) );
					alert4.addEventListener( Event.CLOSE, alert_closeHandler );
				}
			}
			
			if( p_List.selectedIndex == 2)
			{
				if(SaveManager.getInstance().loadGalInfo(3) == 1)
				{
					var alert5:Alert = Alert.show( "Tiga A adalah propaganda Kekaisaran Jepang pada masa Perang Dunia 2 yaitu 'Jepang Pemimpin Asia', 'Jepang Pelindung Asia' dan 'Jepang Cahaya Asia'. Gerakan Tiga A didirikan pada tanggal 29 April 1942. Pelopor gerakan Tiga A ialah Shimizu Hitoshi. Ketua Gerakan Tiga A dipercayakan kapada Mr. Syamsuddin. Gerakan Tiga A bukanlah gerakan kebangsaan Indonesia. Gerakan ini lahir semata - mata untuk memikat hati dan menarik simpati bangsa Indonesia agar mau membantu Jepang.", "Penjelasan", new ListCollection(
					[
						{ label: "OK"}
					]) );
					alert5.addEventListener( Event.CLOSE, alert_closeHandler );
				}
				else
				{
					var alert6:Alert = Alert.show( "Item masih terkunci.","Penjelasan", new ListCollection(
					[
						{ label: "OK"}
					]) );
					alert6.addEventListener( Event.CLOSE, alert_closeHandler );
				}
			}
			
			if( p_List.selectedIndex == 3)
			{
				if(SaveManager.getInstance().loadGalInfo(4) == 1)
				{
					var alert7:Alert = Alert.show( "Lahirnya Pancasila adalah judul pidato yang disampaikan oleh Soekarno dalam sidang Dokuritsu Junbi Cosakai (bahasa Indonesia: 'Badan Penyelidik Usaha Persiapan Kemerdekaan') pada tanggal 1 Juni 1945. Dalam pidato inilah konsep dan rumusan awal 'Pancasila' pertama kali dikemukakan oleh Soekarno sebagai dasar negara Indonesia merdeka.", "Penjelasan", new ListCollection(
					[
						{ label: "OK"}
					]) );
					alert7.addEventListener( Event.CLOSE, alert_closeHandler );
				}
				else
				{
					var alert8:Alert = Alert.show( "Item masih terkunci.","Penjelasan", new ListCollection(
					[
						{ label: "OK"}
					]) );
					alert8.addEventListener( Event.CLOSE, alert_closeHandler );
				}
			}
			
			if( p_List.selectedIndex == 4)
			{
				if(SaveManager.getInstance().loadGalInfo(5) == 1)
				{
					var alert9:Alert = Alert.show( "Peristiwa Rengasdengklok adalah peristiwa penculikan yang dilakukan oleh sejumlah pemuda antara lain Soekarni, Wikana dan Chaerul Saleh dari perkumpulan 'Menteng 31' terhadap Soekarno dan Hatta. Peristiwa ini terjadi pada tanggal 16 Agustus 1945 pukul 03.00. WIB, Soekarno dan Hatta dibawa ke Rengasdengklok, Karawang, untuk kemudian didesak agar mempercepat proklamasi kemerdekaan Republik Indonesia", "Penjelasan", new ListCollection(
					[
						{ label: "OK"}
					]) );
					alert9.addEventListener( Event.CLOSE, alert_closeHandler );
				}
				else
				{
					var alert10:Alert = Alert.show( "Item masih terkunci.","Penjelasan", new ListCollection(
					[
						{ label: "OK"}
					]) );
					alert10.addEventListener( Event.CLOSE, alert_closeHandler );
				}
			}
			
			if( p_List.selectedIndex == 5)
			{
				if(SaveManager.getInstance().loadGalInfo(6) == 1)
				{
					var alert11:Alert = Alert.show( "Perundingan antara golongan muda dan golongan tua dalam penyusunan teks Proklamasi Kemerdekaan Indonesia berlangsung pukul 02.00 - 04.00 dini hari. Teks proklamasi ditulis di ruang makan di laksamana Tadashi Maeda Jln Imam Bonjol No 1. Para penyusun teks proklamasi itu adalah Ir. Soekarno, Drs. Moh. Hatta, dan Mr. Ahmad Soebarjo.Pagi harinya, 17 Agustus 1945, di kediaman Soekarno, Jalan Pegangsaan Timur 56 telah hadir antara lain Soewirjo, Wilopo, Gafar Pringgodigdo, Tabrani dan Trimurti. Acara dimulai pada pukul 10:00 dengan pembacaan proklamasi oleh Soekarno dan disambung pidato singkat tanpa teks. ", "Penjelasan", new ListCollection(
					[
						{ label: "OK"}
					]) );
					alert11.addEventListener( Event.CLOSE, alert_closeHandler );
				}
				else
				{
					var alert12:Alert = Alert.show( "Item masih terkunci.","Penjelasan", new ListCollection(
					[
						{ label: "OK"}
					]) );
					alert12.addEventListener( Event.CLOSE, alert_closeHandler );
				}
			}
			
			if( p_List.selectedIndex == 6)
			{
				if(SaveManager.getInstance().loadGalInfo(7) == 1)
				{
					var alert13:Alert = Alert.show( "PPKI memiliki kepanjangan Panitia Persiapan Kemerdekaan Indonesia, tujuan dibentuknya panitia ini adalah untuk mempersiapkan kemerdekaan bangsa Indonesia. Hasil sidang PPKI yaitu mengesahkan Undang-Undang Dasar 1945, memilih Ir. Soekarno sebagai Presiden dan Drs. Mohammad Hatta sebagai wakil, dan dibentuk Komite Nasional untuk membantu tugas Presiden sementara, sebelum dibentuknya MPR dan DPR.", "Penjelasan", new ListCollection(
					[
						{ label: "OK"}
					]) );
					alert13.addEventListener( Event.CLOSE, alert_closeHandler );
				}
				else
				{
					var alert14:Alert = Alert.show( "Item masih terkunci.","Penjelasan", new ListCollection(
					[
						{ label: "OK"}
					]) );
					alert14.addEventListener( Event.CLOSE, alert_closeHandler );
				}
			}
			
			if( p_List.selectedIndex == 7)
			{
				if(SaveManager.getInstance().loadGalInfo(8) == 1)
				{
					var alert15:Alert = Alert.show( "Agresi Militer Belanda I adalah operasi militer Belanda di Jawa dan Sumatera terhadap Republik Indonesia yang dilaksanakan dari 21 Juli 1947 sampai 5 Agustus 1947. Operasi militer ini merupakan bagian dari Aksi Polisionil yang diberlakukan Belanda dalam rangka mempertahankan penafsiran Belanda atas Perundingan Linggarjati. Dari sudut pandang Republik Indonesia, operasi ini dianggap merupakan pelanggaran dari hasil Perundingan Linggarjati. ", "Penjelasan", new ListCollection(
					[
						{ label: "OK"}
					]) );
					alert15.addEventListener( Event.CLOSE, alert_closeHandler );
				}
				else
				{
					var alert16:Alert = Alert.show( "Item masih terkunci.","Penjelasan", new ListCollection(
					[
						{ label: "OK"}
					]) );
					alert16.addEventListener( Event.CLOSE, alert_closeHandler );
				}
			}
			
			if( p_List.selectedIndex == 8)
			{
				if(SaveManager.getInstance().loadGalInfo(9) == 1)
				{
					var alert17:Alert = Alert.show( "Agresi Militer Belanda II atau Operasi Gagak (bahasa Belanda: Operatie Kraai) terjadi pada 19 Desember 1948 yang diawali dengan serangan terhadap Yogyakarta, ibu kota Indonesia saat itu, serta penangkapan Soekarno, Mohammad Hatta, Sjahrir dan beberapa tokoh lainnya. Jatuhnya ibu kota negara ini menyebabkan dibentuknya Pemerintah Darurat Republik Indonesia di Sumatra yang dipimpin oleh Sjafruddin Prawiranegara. ", "Penjelasan", new ListCollection(
					[
						{ label: "OK"}
					]) );
					alert17.addEventListener( Event.CLOSE, alert_closeHandler );
				}
				else
				{
					var alert18:Alert = Alert.show( "Item masih terkunci.","Penjelasan", new ListCollection(
					[
						{ label: "OK"}
					]) );
					alert18.addEventListener( Event.CLOSE, alert_closeHandler );
				}
			}
			
			if( p_List.selectedIndex == 9)
			{
				if(SaveManager.getInstance().loadGalInfo(10) == 1)
				{
					var alert19:Alert = Alert.show( "Konferensi Meja Bundar adalah sebuah pertemuan yang dilaksanakan di Den Haag, Belanda, dari 23 Agustus hingga 2 November 1949 antara perwakilan Republik Indonesia, Belanda, dan BFO (Bijeenkomst voor Federaal Overleg), yang mewakili berbagai negara yang diciptakan Belanda di kepulauan Indonesia. Sebelum konferensi ini, berlangsung tiga pertemuan tingkat tinggi antara Belanda dan Indonesia, yaitu Perjanjian Linggarjati (1947), Perjanjian Renville (1948), dan Perjanjian Roem-Royen (1949). Konferensi ini berakhir dengan kesediaan Belanda untuk menyerahkan kedaulatan kepada Republik Indonesia Serikat. ", "Penjelasan", new ListCollection(
					[
						{ label: "OK"}
					]) );
					alert19.addEventListener( Event.CLOSE, alert_closeHandler );
				}
				else
				{
					var alert20:Alert = Alert.show( "Item masih terkunci.","Penjelasan", new ListCollection(
					[
						{ label: "OK"}
					]) );
					alert20.addEventListener( Event.CLOSE, alert_closeHandler );
				}
			}
			
		}
		
		private function alert_closeHandler( event:Event, data:Object ):void
		{
			if (!Sounds.muted) Sounds.sndCoffee.play();
			if( data.label == "OK" )
			{
				// the OK button was clicked
			}
		}
		
		private function list_scrollHandler(event:Event):void
		{
			this._pageIndicator.pageCount = this._list.horizontalPageCount;
			this._pageIndicator.selectedIndex = this._list.horizontalPageIndex;
		}
		
		private function pageIndicator_changeHandler(event:Event):void
		{
			this._list.scrollToPageIndex(this._pageIndicator.selectedIndex, 0, this._list.pageThrowDuration);
		}
	}
}