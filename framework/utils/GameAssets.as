﻿package framework.utils
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class GameAssets
	{
		/**
		 * Texture Atlas 
		 */
		[Embed(source="../media/graphics/gameAtlas.png")]
		public static const AtlasTextureGameTest:Class;
	
		[Embed(source="../media/graphics/gameAtlas.xml", mimeType="application/octet-stream")]
		public static const AtlasXmlGameTest:Class;
		
		/**
		 * Background Assets 
		 */
		[Embed(source="../media/graphics/bgLayer1.png")]
		public static const BgLayer1:Class;
		[Embed(source="../media/graphics/bgLayerEx1.png")]
		public static const BgLayerEx1:Class;
		[Embed(source="../media/graphics/bgLayerExt1.png")]
		public static const BgLayerExt1:Class;
		[Embed(source="../media/graphics/bgHelper.png")]
		public static const BgHelper:Class;
		[Embed(source="../media/graphics/bgMenu.png")]
		public static const BgMenu:Class;
		
		
		[Embed(source="../media/graphics/normal-page-symbol.png")]
		public static const scrollIdle:Class;
		
		[Embed(source="../media/graphics/selected-page-symbol.png")]
		public static const scrollOn:Class;
		
		[Embed(source="../media/graphics/particle.png")]
		public static const particle:Class;
		
		[Embed(source="../media/graphics/nulshock bd.TTF", fontFamily="nulshock", embedAsCFF="false")]
		public static var MyFont:Class;		
		
		
		/**
		 * Texture Cache 
		 */
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameTextureAtlas:TextureAtlas;
				private static var gameTextureAtlas2:TextureAtlas;
		
		/**
		 * Returns the Texture atlas instance.
		 * @return the TextureAtlas instance (there is only oneinstance per app)
		 */
		
		public static function getAtlasFix():TextureAtlas
		{
			if (gameTextureAtlas2 == null)
			{
				var texture:Texture = getTexture("AtlasTextureGameTest");
				var xml:XML = XML(new AtlasXmlGameTest());
				gameTextureAtlas2=new TextureAtlas(texture, xml);
			}
			
			return gameTextureAtlas2;
		}
		
		/**
		 * Returns a texture from this class based on a string key.
		 * 
		 * @param name A key that matches a static constant of Bitmap type.
		 * @return a starling texture.
		 */
		public static function getTexture(name:String):Texture
		{
			if (gameTextures[name] == undefined)
			{
				var bitmap:Bitmap = new GameAssets[name]();
				gameTextures[name]=Texture.fromBitmap(bitmap);
				gameTextures[name].root.onRestore = function():void
				{
					gameTextures[name].root.uploadBitmap(bitmap);
				};
			}
			
			return gameTextures[name];
		}
	}
}
