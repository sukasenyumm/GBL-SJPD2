package 
{
	import flash.media.Sound;
	public class Sounds
	{
		/**
		 * Embedded sound files. 
		 */		
		[Embed(source="framework/media/sounds/POL-random-encounter-long.mp3")]
		public static const SND_BG_GAME:Class;
		
		[Embed(source="framework/media/sounds/17agustusBGM.mp3")]
		public static const SND_BG_MAIN:Class;
		
		[Embed(source="framework/media/sounds/eat.mp3")]
		public static const SND_EAT:Class;
		
		[Embed(source="framework/media/sounds/coffee.mp3")]
		public static const SND_COFFEE:Class;
		
		[Embed(source="framework/media/sounds/mushroom.mp3")]
		public static const SND_MUSHROOM:Class;
		
		[Embed(source="framework/media/sounds/hit.mp3")]
		public static const SND_HIT:Class;
		
		[Embed(source="framework/media/sounds/win.mp3")]
		public static const SND_WIN:Class;
		
		[Embed(source="framework/media/sounds/lose.mp3")]
		public static const SND_LOSE:Class;
		
		/**
		 * Initialized Sound objects. 
		 */		
		public static var sndBgMain:Sound = new Sounds.SND_BG_MAIN() as Sound;
		public static var sndBgGame:Sound = new Sounds.SND_BG_GAME() as Sound;
		public static var sndEat:Sound = new Sounds.SND_EAT() as Sound;
		public static var sndCoffee:Sound = new Sounds.SND_COFFEE() as Sound;
		public static var sndMushroom:Sound = new Sounds.SND_MUSHROOM() as Sound;
		public static var sndHit:Sound = new Sounds.SND_HIT() as Sound;
		public static var sndWin:Sound = new Sounds.SND_WIN() as Sound;
		public static var sndLose:Sound = new Sounds.SND_LOSE() as Sound;
		
		/**
		 * Sound mute status. 
		 */
		public static var muted:Boolean = false;
	}
}