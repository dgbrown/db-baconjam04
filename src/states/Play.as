package states 
{
	import ents.*;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Derek brown
	 */
	public class Play extends FlxState 
	{
		
		public function Play() { super(); }
		
		public var background:FlxSprite;
		public var brainy:FlxSprite;
		public var dream:Dream;
		
		public static const SCREEN_CENTER_X:Number = 640 * 0.5;
		public static const SCREEN_CENTER_Y:Number = 480 * 0.5;
		
		override public function create():void 
		{
			super.create();
			
			background = new FlxSprite( 0, 0, Assets.IMG_CLASS_MOCKUP );
			//background.scrollFactor.make();
			add( background );
			
			brainy = new FlxSprite( SCREEN_CENTER_X, SCREEN_CENTER_Y, Assets.IMG_CLASS_BRAINY );
			brainy.maxVelocity.make( 100, 100 );
			brainy.drag.make( 225, 225 );
			
			dream = createDream( SCREEN_CENTER_X - 50, SCREEN_CENTER_Y - 50 );
			
			add( brainy );
			add( dream );
			
			FlxG.camera.follow( brainy, FlxCamera.STYLE_TOPDOWN_TIGHT );
		}
		
		private function createDream( x_:Number = 0, y_:Number = 0, size_:Number = 30.0 ):Dream
		{
			var dream:Dream = new Dream( x_, y_, size_ );
			dream.creator = brainy;
			return dream;
		}
		
		override public function update():void 
		{
			if ( FlxG.keys.W )
				brainy.velocity.y = -brainy.maxVelocity.y;
			if ( FlxG.keys.A )
				brainy.velocity.x = -brainy.maxVelocity.x;
			if ( FlxG.keys.S )
				brainy.velocity.y = brainy.maxVelocity.y;
			if ( FlxG.keys.D )
				brainy.velocity.x = brainy.maxVelocity.x;
				
			super.update();
		}
		
	}

}