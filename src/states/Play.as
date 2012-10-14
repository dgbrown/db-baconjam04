package states 
{
	import ents.*;
	import flash.display.GraphicsPathWinding;
	import flash.geom.Point;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Derek brown
	 */
	public class Play extends FlxState 
	{
		
		public function Play() { super(); }
		
		public var backgroundFillX:FlxSprite;
		public var backgroundFillY:FlxSprite;
		public var backgroundFillXY:FlxSprite;
		public var background:FlxSprite;
		public var brainy:Brainy;
		public var dreams:FlxGroup;
		public var distractions:FlxGroup;
		public var lightnings:FlxGroup;
		public var lblFulfillment:FlxText;
		
		private var _nextDistractionSpawnMark:Number;
		private var _playingFulfilledTheme:Boolean;
		
		public static const SCREEN_CENTER_X:Number = 640 * 0.5;
		public static const SCREEN_CENTER_Y:Number = 480 * 0.5;
		public static const DISTRACTION_MAX_SPAWN_RADIUS:Number = 380.0;
		public static const DISTRACTION_MIN_SPAWN_RADIUS:Number = 100.0;
		public static const DISTRACTION_SPAWN_MAX_DELAY:Number = 1300;
		public static const DISTRACTION_SPAWN_MIN_DELAY:Number = 400;
		
		override public function create():void 
		{
			super.create();
			FlxG.flash( 0xff009cd0, 0.5 );
			
			//FlxG.debug = true;
			//FlxG.visualDebug = true;
			_playingFulfilledTheme = false;
			setNextDistractionSpawnTime();
			
			background = new FlxSprite( 0, 0, Assets.IMG_CLASS_BACKGROUNDTILE );
			add( background );
			backgroundFillX = new FlxSprite( -background.width, 0, Assets.IMG_CLASS_BACKGROUNDTILE );
			add( backgroundFillX );
			backgroundFillY = new FlxSprite( 0, -background.height, Assets.IMG_CLASS_BACKGROUNDTILE );
			add( backgroundFillY );
			backgroundFillXY = new FlxSprite( -background.width, -background.height, Assets.IMG_CLASS_BACKGROUNDTILE );
			add( backgroundFillXY );
			
			brainy = new Brainy( SCREEN_CENTER_X, SCREEN_CENTER_Y );
			
			distractions = new FlxGroup(40);
			for ( var i:int = 0; i < 40; ++i )
			{
				var distraction:Distraction = new Distraction( Math.random() * FlxG.width, Math.random() * FlxG.height );
				distractions.add( distraction );
				distraction.kill();
			}
			add( distractions );
			
			add( brainy );
			
			dreams = new FlxGroup(8);
			for ( var n:int = 0; n < dreams.maxSize; ++n )
			{
				var a:Number = (Math.PI * 2.0) / dreams.maxSize * n;
				var px:Number = brainy.centerX + Math.cos( a ) * 225;
				var py:Number = brainy.centerY + Math.sin( a ) * 225;
				dreams.add( createDream( px, py ) );
			}
			add( dreams );
			/*
			dream = createDream( SCREEN_CENTER_X - 50, SCREEN_CENTER_Y - 50 );
			add( dream );
			*/
			
			lightnings = new FlxGroup( 20 );
			for ( var j:uint = 0; j < 20; ++j )
				lightnings.add( createLightning() );
			add( lightnings );
			
			lblFulfillment = new FlxText( FlxG.width - 100, 0, 100, "50" );
			lblFulfillment.alignment = "right";
			lblFulfillment.scrollFactor.make();
			//add( lblFulfillment );
			
			FlxG.camera.follow( brainy, FlxCamera.STYLE_TOPDOWN_TIGHT );
		}
		
		public function setNextDistractionSpawnTime():void
		{
			_nextDistractionSpawnMark = FlxU.getTicks() + Math.random() * ( Play.DISTRACTION_SPAWN_MAX_DELAY - Play.DISTRACTION_SPAWN_MIN_DELAY ) + Play.DISTRACTION_SPAWN_MIN_DELAY;
		}
		
		public function createDream( x_:Number = 0, y_:Number = 0, size_:Number = 30.0, parentDream_:Dream = null ):Dream
		{
			var dream:Dream = new Dream( x_, y_, size_ );
			dream.world = this;
			dream.creator = brainy;
			dream.parentDream = parentDream_ ? parentDream_ : null;
			return dream;
		}
		
		public function createLightning():Lightning
		{
			var lightning:Lightning = new Lightning();
			lightning.kill();
			lightning.creator = brainy;
			return lightning;
		}
		
		public function spawnLightning( toPoint_:Point ):void
		{
			var lightning:Lightning = lightnings.getFirstDead() as Lightning;
			if ( !lightning )
				lightning = lightnings.members[0] as Lightning;
			lightning.spawn( toPoint_ );
		}
		
		public function spawnDistraction():void
		{
			var a:Number = Math.random() * ( Math.PI * 2.0 );
			var d:Number = Math.random() * ( Play.DISTRACTION_MAX_SPAWN_RADIUS - Play.DISTRACTION_MIN_SPAWN_RADIUS ) + Play.DISTRACTION_MIN_SPAWN_RADIUS;
			var distraction:Distraction = distractions.getFirstDead() as Distraction;
			if ( !distraction ) // get the longest living distraction if there isn't a dead one
			{
				var lowestSpawnMark:Number = FlxU.getTicks();
				for ( var i:int = 0; i < distractions.maxSize; ++i )
				{
					if ( (distractions.members[i] as Distraction).spawnMark < lowestSpawnMark )
					{
						lowestSpawnMark = (distractions.members[i] as Distraction).spawnMark;
						distraction = distractions.members[i] as Distraction;
					}
				}
				distraction.kill();
			}
			distraction.x = brainy.x + Math.cos( a ) * d;
			distraction.y = brainy.y + Math.sin( a ) * d;
			distraction.spawn();
		}
		
		public function updateInfiniteBackground():void
		{
			// reposition main background peice
			if ( brainy.x < background.x )
				background.x -= background.width;
			else if ( brainy.x > background.x + background.width )
				background.x += background.width;
			if ( brainy.y < background.y )
				background.y -= background.height;
			else if ( brainy.y > background.y + background.height )
				background.y += background.height;
				
			// reposition x axis filler
			backgroundFillX.y = background.y;
			if ( brainy.x > background.x + background.width * 0.5 )
				backgroundFillX.x = background.x + background.width;
			else
				backgroundFillX.x = background.x - background.width;
			// reposition y axis filler
			backgroundFillY.x = background.x;
			if ( brainy.y > background.y + background.height * 0.5 )
				backgroundFillY.y = background.y + background.height;
			else
				backgroundFillY.y = background.y - background.height;
				
			// reposition xy filler
			backgroundFillXY.x = backgroundFillX.x;
			backgroundFillXY.y = backgroundFillY.y;
		}
		
		public function updateUI():void
		{
			lblFulfillment.text = brainy.fulfillment.toFixed(2);
		}
		
		public function brainyCollideDistractionCB( obj1:FlxObject, obj2:FlxObject ):void
		{
			FlxG.play( Assets.SND_CLASS_PICKUP );
			brainy.grow( Brainy.GROWTH_DISTRACTION );
			obj2.kill();
		}
		
		override public function update():void 
		{
			var ticks:Number = FlxU.getTicks();
			
			updateInfiniteBackground();
			
			if ( FlxG.keys.W )
				brainy.velocity.y = -brainy.maxVelocity.y;
			if ( FlxG.keys.A )
				brainy.velocity.x = -brainy.maxVelocity.x;
			if ( FlxG.keys.S )
				brainy.velocity.y = brainy.maxVelocity.y;
			if ( FlxG.keys.D )
				brainy.velocity.x = brainy.maxVelocity.x;
				
			if ( ticks >= _nextDistractionSpawnMark )
			{
				spawnDistraction();
				setNextDistractionSpawnTime();
			}
				
			var d:Number, dx:Number, dy:Number;
			var distraction:Distraction;
			for ( var i:int = 0; i < distractions.maxSize; ++i )
			{
				distraction = distractions.members[i] as Distraction;
				if ( distraction.alive )
				{
					dx = distraction.x - brainy.centerX;
					dy = distraction.y - brainy.centerY;
					d = Math.sqrt( dx * dx + dy * dy );
					if ( brainy.fulfilled && d < brainy.radius + distraction.radius + 150.0 )
					{
						spawnLightning( new Point( distraction.x, distraction.y ) );
						distraction.kill();
					}
					if ( d < brainy.radius + distraction.radius )
					{
						brainyCollideDistractionCB( brainy, distraction );
					}
				}
			}
			
			if ( !_playingFulfilledTheme && brainy.fulfilled )
			{
				_playingFulfilledTheme = true;
				FlxG.music.stop();
				FlxG.playMusic( Assets.SND_CLASS_FULFILLMENT_THEME, 0.5 );
				FlxG.play( Assets.SND_CLASS_FULFILLED );
			}
			
			updateUI();
				
			super.update();
			
			if ( brainy.dying )
				FlxG.fade( 0xff009cd0, 3.0, onFadeComplete );
		}
		
		public function onFadeComplete():void
		{
			FlxG.switchState( new Menu() );
		}
		
	}

}