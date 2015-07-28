package framework.screenstates
{

	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.VAlign;
	import framework.customobjects.Font;
	import framework.events.NavigationEvent;
	import framework.utils.Fonts;
	import framework.utils.GameAssets;
	
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
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
			
			drawChooseLevel();
		}
		
		/**
		 * Draw game over screen. 
		 * 
		 */
		private function drawChooseLevel():void
		{
			
			// Background quad.
			//bg = new Quad(stage.stageWidth, stage.stageHeight, 0x000000);
			//bg.alpha = 0.75;
			//this.addChild(bg);
			
			
			// Navigation buttons.
			mainBtn = new Button(GameAssets.getAtlas().getTexture("gameOver_mainButton"));
			mainBtn.x = stage.stageWidth * 0.5 - mainBtn.width * 0.5;
			mainBtn.y = (stage.stageHeight * 70)/80;
			mainBtn.addEventListener(Event.TRIGGERED, onMainClick);
			this.addChild(mainBtn);
			//a nice, fluid layout
			group = new LayoutGroup();
    
			this.layout = new AnchorLayout();
			group.width = stage.stageWidth;
			group.height = stage.stageHeight - 100;
			
			
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
			pageIndicatorLayoutData.bottom = 0;
			pageIndicatorLayoutData.left = 0;
			pageIndicatorLayoutData.right = 0;
			this._pageIndicator.layoutData = pageIndicatorLayoutData;

			group.addChild(this._pageIndicator);

			//the data that will be displayed in the list
			var collection:ListCollection = new ListCollection(
			[
				{ label: "Facebook", texture: GameAssets.getTexture("scrollOn") },
				{ label: "Twitter", texture:GameAssets.getTexture("scrollOn") },
				{ label: "Google", texture: GameAssets.getTexture("scrollOn") },
				{ label: "YouTube", texture: GameAssets.getTexture("scrollOn") },
				{ label: "StumbleUpon", texture: GameAssets.getTexture("scrollOn") },
				{ label: "Yahoo", texture:GameAssets.getTexture("scrollOn") },
				{ label: "Facebook", texture: GameAssets.getTexture("scrollOn") },
				{ label: "Twitter", texture:GameAssets.getTexture("scrollOn") },
				{ label: "Facebook", texture: GameAssets.getTexture("scrollOn") },
				{ label: "Twitter", texture:GameAssets.getTexture("scrollOn") },
				{ label: "Google", texture: GameAssets.getTexture("scrollOn") },
				{ label: "YouTube", texture: GameAssets.getTexture("scrollOn") },
				{ label: "StumbleUpon", texture: GameAssets.getTexture("scrollOn") },
				{ label: "Yahoo", texture:GameAssets.getTexture("scrollOn") },
				{ label: "Facebook", texture: GameAssets.getTexture("scrollOn") },
				{ label: "Twitter", texture:GameAssets.getTexture("scrollOn") },
				{ label: "Facebook", texture: GameAssets.getTexture("scrollOn") },
				{ label: "Twitter", texture:GameAssets.getTexture("scrollOn") },
				{ label: "Google", texture: GameAssets.getTexture("scrollOn") },
				{ label: "YouTube", texture: GameAssets.getTexture("scrollOn") },
				{ label: "StumbleUpon", texture: GameAssets.getTexture("scrollOn") },
				{ label: "Yahoo", texture:GameAssets.getTexture("scrollOn") },
				{ label: "Facebook", texture: GameAssets.getTexture("scrollOn") },
				{ label: "Twitter", texture:GameAssets.getTexture("scrollOn") },
				{ label: "Facebook", texture: GameAssets.getTexture("scrollOn") },
				{ label: "Twitter", texture:GameAssets.getTexture("scrollOn") },
				{ label: "Google", texture: GameAssets.getTexture("scrollOn") },
				{ label: "YouTube", texture: GameAssets.getTexture("scrollOn") },
				{ label: "StumbleUpon", texture: GameAssets.getTexture("scrollOn") },
				{ label: "Yahoo", texture:GameAssets.getTexture("scrollOn") },
				{ label: "Facebook", texture: GameAssets.getTexture("scrollOn") },
				{ label: "Twitter", texture:GameAssets.getTexture("scrollOn") },
				
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
			listLayout.padding = 20;
			listLayout.gap = 20;
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
			renderer.labelField = "label";
			renderer.iconSourceField = "texture";
			//renderer.iconPosition = Button.ICON_POSITION_TOP;
			//renderer.defaultLabelProperties.textFormat = new BitmapFontTextFormat("chiller", NaN, 0x000000);
			renderer.width = 140;
			renderer.height = 100;
			//renderer.addEventListener( Event.TRIGGERED, onItemClicked );
			return renderer;
		}


		private function onItemClicked(event:Event):void
		{
			var p_List:List  = List (event.currentTarget);
    		trace("selected item:", p_List.selectedIndex);
			if( p_List.selectedIndex == 0)
			{
				if(SaveManager.getInstance().loadDataItemSingle())
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