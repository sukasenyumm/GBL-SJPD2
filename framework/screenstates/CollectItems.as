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
	//setStyleProviderForClass(DefaultListItemRenderer, myTileRenderer, "my-tile-renderer");
			
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
			
			
			// Navigation buttons.
			mainBtn = new Button(GameAssets.getAtlasFix().getTexture("btn_home"));
			mainBtn.x = (stage.stageWidth/14);
			mainBtn.y = stage.stageHeight - (stage.stageHeight/14) - mainBtn.height;
			mainBtn.addEventListener(Event.TRIGGERED, onMainClick);
			this.addChild(mainBtn);
		
			galeriInfo = new TextField(stage.stageWidth, 50, "", "nulshock", 20, 0x000000);
			galeriInfo.text = "GALERI INFO";
			galeriInfo.x = stage.stageWidth/2-galeriInfo.width/2;
			galeriInfo.y = (stage.stageHeight/14);
			this.addChild(galeriInfo);
			
			//a nice, fluid layout
			group = new LayoutGroup();
    
			this.layout = new AnchorLayout();
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

			//the data that will be displayed in the list
			var collection:ListCollection = new ListCollection(
			[
				{ label: "Batu Nisan ", texture: GameAssets.getAtlasFix().getTexture("P1-1") },
				{ label: "Belanda Menyerah ", texture: GameAssets.getAtlasFix().getTexture("P1-2") },
				{ label: "Semboyan Jepang ", texture: GameAssets.getAtlasFix().getTexture("P1-3") },
				{ label: "Garuda Pancasila ", texture: GameAssets.getAtlasFix().getTexture("P2-1") },
				{ label: "Rengasdengklok ", texture: GameAssets.getAtlasFix().getTexture("P2-2") },
				{ label: "Naskah Proklamasi ", texture: GameAssets.getAtlasFix().getTexture("P2-3") },
				{ label: "Sidang PPKI ", texture: GameAssets.getAtlasFix().getTexture("P2-4") },
				{ label: "Agresi Belanda I ", texture: GameAssets.getAtlasFix().getTexture("P3-1") },
				{ label: "Agresi Belanda II ", texture: GameAssets.getAtlasFix().getTexture("P3-2") },
				{ label: "Konferensi Meja Bundar ", texture: GameAssets.getAtlasFix().getTexture("P3-3") },
			]);
			
			this._list = new List();
			this._list.dataProvider = collection;
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
			//if (!Sounds.muted) Sounds.sndMushroom.play();
			
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
			this.visible = true;
		}
		
		public function disposeTemporarily():void
		{
			this.visible = false;
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
    		trace("selected item:", p_List.selectedIndex);
			if( p_List.selectedIndex == 0)
			{
				if(/*SaveManager.getInstance().loadDataItemSingle()*/0)
				{
					var alert:Alert = Alert.show( "Item ini merupakan simbol kedatangan jepang pada tahun xxxx di xxxx.", "Penjelasan", new ListCollection(
					[
						{ label: "OK"}
					]) );
					alert.addEventListener( Event.CLOSE, alert_closeHandler );
				}
				else
				{
					var alert:Alert = Alert.show( "Item masih terkunci.","Penjelasan", new ListCollection(
					[
						{ label: "OK"}
					]) );
					alert.addEventListener( Event.CLOSE, alert_closeHandler );
				}
			}
			
			if( p_List.selectedIndex == 1)
			{
				var alert:Alert = Alert.show( "I have something important to say", "Penjelasan", new ListCollection(
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