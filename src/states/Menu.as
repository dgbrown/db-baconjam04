package states 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Derek brown
	 */
	public class Menu extends FlxState 
	{
		
		public var background:FlxSprite;
		public var title:FlxSprite;
		
		override public function create():void 
		{
			super.create();
			
			if ( FlxG.music )
				FlxG.music.stop();
			FlxG.playMusic( Assets.SND_CLASS_DREAM, 0.5 );
			FlxG.flash( 0xff009cd0, 0.333 );
			
			background = new FlxSprite( FlxG.width * 0.5, FlxG.height * 0.5, Assets.IMG_CLASS_BACKGROUNDTILE );
			background.x -= background.width * 0.5;
			background.y -= background.height * 0.5;
			add( background );
			
			title = new FlxSprite( FlxG.width * 0.5 - ( 546 * 0.5 ), 0, Assets.IMG_CLASS_TITLE );
			add( title );
			
			var lblCallToAction:FlxText = new FlxText( FlxG.width * 0.5 - 100, FlxG.height * 0.5 + 80.0, 200, "[ Press ENTER to Forecast Your Life ]" );
			lblCallToAction.alignment = "center";
			add( lblCallToAction );
		}
		
		private function onFadeComplete():void
		{
			FlxG.switchState( new Play() );
		}
		
		override public function update():void 
		{
			var ticks:uint = FlxU.getTicks();
			title.y = 80 + ( Math.sin( ticks * 0.0025 + Math.PI * 0.25 ) * 13 + Math.sin( ticks * 0.0025 + Math.PI * 0.666 ) * 6 );
			
			background.x = ( FlxG.width * 0.5 - background.width * 0.5 ) + Math.sin( ticks * 0.0005 ) * 10;
			background.y = ( FlxG.height * 0.5 - background.height * 0.5 ) + Math.cos( ticks * 0.0005 ) * 10;
			
			if ( FlxG.keys.justPressed( "ENTER" ) )
				FlxG.fade( 0xff009cd0, 0.5, onFadeComplete, false );
				
			super.update();
		}
		
	}

}